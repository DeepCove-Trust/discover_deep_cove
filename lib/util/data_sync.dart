import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/entry_media_pivot.dart';
import 'package:discover_deep_cove/data/models/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/permissions.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:http/http.dart' as http;

/// Facilitates communication between this application, and the CMS server.
///
/// Disclaimer: Most likely a complete misuse of the term 'Provider'.
class SyncProvider {
  SyncProvider._();

  /// Retrieve the checksum for the zipped resources file that will be
  /// sent by the CMS server. This can be compared with the checksum of
  /// the actual file that has been downloaded from the server.
  static Future<String> _getFileChecksum() async {
    http.Response response = await http.get(Env.filesHashUrl);
    if (response.statusCode != 200) {
      throw Exception('API error'); // TODO: make this better
    }
    return response.body;
  }

  /// Retrieve the checksum for the JSON data that will be sent by the
  /// CMS server. This can be compared with the checksum of the actual
  /// JSON data that was downloaded from the server.
  static Future<String> _getJsonChecksum() async {
    http.Response response = await http.get(Env.dataHashUrl);
    if (response.statusCode != 200) {
      throw Exception('API error'); // TODO: make this better
    }
    return response.body;
  }

  /// Makes the API get request for the zipped resources on the remote server.
  ///
  /// Returns the [http.Response] of the request.
  static Future<http.Response> _requestFile() async {
    http.Response response = await http.get(Env.filesSyncUrl);
    if (response.statusCode != 200) {
      throw Exception('API error'); // TODO: make this better
    }
    return response;
  }

  /// Makes the API get request for the remote database data in JSON
  /// format.
  ///
  /// Returns the [http.Response] of the request.
  static Future<String> _requestData() async {
    http.Response response = await http.get(Env.dataSyncUrl);
    if (response.statusCode != 200) {
      throw Exception('API error. Response status ${response.statusCode}');
      // TODO: make this better
    }
    return response.body;
  }

  /// Downloads JSON string from the server, checks its integrity, then
  /// returns it as a JSON object.
  static Future<Map<String, dynamic>> _downloadData() async {
    // Download json data from server.
    print('Requesting application data from server...');
    String jsonString = await _requestData();
    print('JSON data received...');

    // Calculate checksum of downloaded data.
    Digest dataDigest = sha256.convert(Utf8Encoder().convert(jsonString));

    // Compare with expected checksum from server.
    if (dataDigest.toString() != await _getJsonChecksum()) {
      // Retrieved data is corrupted.
      print('JSON data failed integrity check...');
      // TODO: Handle this better?
      return null;
    }

    print('JSON passed integrity check...');

    // Convert JSON string to a JSON object.
    var jsonData = json.decode(jsonString);

    // Convert the _InternalHashMap into a regular, more strictly typed map.
    // This allows us to use it with the database beans `fromMap()` method when
    // inserting this data in the database.
    Map<String, dynamic> dataMap = Map<String, dynamic>.from(jsonData);

    return dataMap;
  }

  /// Retrieves fresh ZIP file from the server and returns true if the new
  /// file passes the integrity check.
  static Future<File> _downloadZipFile() async {
    // get the resources directory
    Directory rootDir = Directory(await Env.rootStorageDirPath);

    print('Requesting zip file from server.');

    // Request the file and store to temp file 'payload.zip'
    File resourcesZip = await Util.httpResponseToFile(
        response: await _requestFile(),
        absPath: rootDir.path,
        fileName: 'resources.zip');

    print('Zip file saved to \'${rootDir.path}\'.');

    // integrity check
    Digest fileDigest = sha256.convert(await resourcesZip.readAsBytes());

    // integrity check
    if (fileDigest.toString() != await _getFileChecksum()) {
      // retrieved file is corrupted
      print('Zip file failed integrity check.');
      //await payload.delete();
      return null;
      // TODO: make this better
    }

    print('Zip file passed integrity check.');
    return resourcesZip;
  }

  /// Extracts the supplied [File} to the path specified at [Env.resourcesPath]
  ///
  /// ** Any pre-existing directory will be deleted **
  ///
  /// Returns true if successful.
  static Future<bool> _extractFileStructure(File payload) async {
    Directory resourceDir = Directory(await Env.resourcesPath);
    // delete existing resource directory
    if (await resourceDir.exists()) {
      print('Deleting existing resource directory,');
      await resourceDir.delete(recursive: true);
    }
    // create fresh directory
    print('Creating new resource directory.');
    await resourceDir.create(recursive: true);

    // extract zip to resource directory
    bool extracted = await Util.extractZip(zip: payload, dir: resourceDir);

    // delete zip when finished
    if (extracted) {
      print('Zip extracted to \'${resourceDir.path}\'.');
      print('Deleting zip file...');
      await payload.delete();
      return true;
    } else {
      // something went wrong with extraction
      throw Exception('Something went wrong with file extraction.');
      // TODO: Improve the handling of this.
    }
  }

  /// Removes the existing database files and builds new database.
  static Future<bool> _rebuildDatabase(Map<String, dynamic> data) async {
    // Establish the path to the database file
    File dbFile = File(await Env.dbPath);

    // Remove database file if it exists
    if (dbFile.existsSync()) {
      // Disconnect the database adaptor before deleting database.
      await DB.instance.adapter
        ..close();
      // Reset the adaptor so that database will be recreated upon next
      // retrieval of [DBProvider.db.adapter].
      DB.instance.resetAdapter();
      print('Removing existing database file...');
      dbFile.deleteSync();
    }

    // Below code causes new database file to be created.
    SqfliteAdapter adapter = await DB.instance.adapter;

    FactFileCategoryBean factFileCategoryBean = FactFileCategoryBean(adapter);
    FactFileEntryBean factFileEntryBean = FactFileEntryBean(adapter);
    MediaFileBean mediaFileBean = MediaFileBean(adapter);
    EntryToMediaPivotBean entryToMediaPivotBean =
        EntryToMediaPivotBean(adapter);

    // Create database tables
    mediaFileBean.createTable();
    factFileCategoryBean.createTable();
    factFileEntryBean.createTable();
    entryToMediaPivotBean.createTable();

    // Insert all media files from JSON
    for (Map<String, dynamic> map in data['media_files']) {
      mediaFileBean.insert(mediaFileBean.fromMap(map));
    }

    // Insert all categories from JSON
    for (Map<String, dynamic> map in data['categories']) {
      factFileCategoryBean.insert(factFileCategoryBean.fromMap(map));
    }

    // Insert all entries from JSON
    for (Map<String, dynamic> map in data['entries']) {
      factFileEntryBean.insert(factFileEntryBean.fromMap(map));
    }

    // Insert all entry_images from JSON
    for(Map<String, dynamic> map in data['entry_images']){
      entryToMediaPivotBean.insert(entryToMediaPivotBean.fromMap(map));
    }

    return true;

    // TODO: Gotta be a better way of doing this without so much repeated code
  }

  /// Downloads and checks integrity of new data and files, before deleting
  /// existing content and rebuilding.
  ///
  /// Current implementation will result in the loss of any user data
  /// (activity inputs, answers, scores, etc).
  static Future<bool> syncResources() async {
    print('Syncing application resources with CMS server...');

    if (!await Permissions.ensurePermission(PermissionGroup.storage)) {
      print('Permission to write to storage not granted');
      return false;
    }

    // Download and check data
    Map<String, dynamic> data = await _downloadData();
    if (data == null) {
      print('Data was not downloaded successfully. Aborting');
      // TODO: Review what to do here
      return false;
    }

    // Download and check zip file.
    File payload = await _downloadZipFile();
    if (payload == null) {
      print('Files were not downloaded successfully. Aborting');
      // TODO: Review what to do here
      return false;
    }

    // We now have good, updated data and files.

    // Removing existing files and extracting zip in its place.
    bool extracted = await _extractFileStructure(payload);

    // Deleting existing database and rebuilding
    bool dataRebuilt = await _rebuildDatabase(data);

    print('Application content successfully synced.');
    return true;
  }

  /// Retrieves the version number of the current online resources.
  /// TODO: Implement this locally and on the server
  static Future<double> getRemoteResourcesVersion() async {
    // retrieve current version from CMS

    // return value
  }

  /// Checks the version number of the local resources
  /// TODO: Implement this locally and on the server
  static Future<double> getLocalResourcesVersion() async {
    // retrieve current version number from database

    // return value
  }

  /// Fetches remote and local resource versions. If the remote version is
  /// greater than the local, then updated resources are available.
  ///
  /// Returns a map containing both remote and local resources versions.
  /// TODO: Implement this locally and on the server
  static Future<Map<String, double>> getResourcesVersions() async {
    // call getRemoteResourcesVersion

    // call getLocalResourcesVersion

    // return map of following data
    //    'remoteVersion' : 3.0,
    //    'localVersion' : 2.2
    // TODO: Review below idea and determine suitability for this project
    // Idea: Minor version number increase indicates that new data is compatible
    // with any existing user data. Major version increase indicates that all
    // user data will be wiped during sync.
  }

  /// Returns true is updated resources are available on the remote server.
  static Future<bool> updatedResourcesAvailable() async =>
      await getRemoteResourcesVersion() > await getLocalResourcesVersion();
}
