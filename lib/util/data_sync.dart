import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/activity_images.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry_images.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_nugget.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/permissions.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

/// Facilitates communication between this application, and the CMS server.
///
/// Disclaimer: Most likely a complete misuse of the term 'Provider'.
class SyncProvider {
  SyncProvider._();

  /// Retrieve the hash for the zipped resources file that will be
  /// sent by the CMS server. This can be compared with the hash of
  /// the actual file that has been downloaded from the server.
  static Future<String> _getFilesHash() async {
    http.Response response = await http.get(Env.filesHashUrl);
    if (response.statusCode != 200) {
      throw Exception('API error'); // TODO: make this better
    }
    return response.body;
  }

  /// Retrieve the hash for the JSON data that will be sent by the
  /// CMS server. This can be compared with the hash of the actual
  /// JSON data that was downloaded from the server.
  static Future<String> _getJsonHash() async {
    http.Response response = await http.get(Env.dataHashUrl);
    if (response.statusCode != 200) {
      throw Exception('API error'); // TODO: make this better
    }
    return response.body;
  }

  /// Makes the API get request for the zipped resources on the remote server.
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

    // Calculate hash of downloaded data.
    String downloadHash =
        sha256.convert(Utf8Encoder().convert(jsonString)).toString();
    String expectedHash = await _getJsonHash();

//    print('Calculated hash: $downloadHash');
//    print('Expected hash: $expectedHash');

    // Compare with expected hash from server.
    if (downloadHash.toString() != expectedHash) {
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
    Directory rootDir = Directory(Env.rootStorageDirPath);

    print('Requesting zip file from server.');

    // Request the file and store to temp file 'payload.zip'
    File resourcesZip = await Util.httpResponseToFile(
        response: await _requestFile(),
        absPath: rootDir.path,
        fileName: 'resources.zip');

    print('Zip file saved to \'${rootDir.path}\'.');

    // integrity check
    String downloadHash =
        sha256.convert(await resourcesZip.readAsBytes()).toString();
    String expectedHash = await _getFilesHash();

//    print('Calculated checksum: $downloadHash');
//    print('Expected checksum: $expectedHash');

    // integrity check
    if (downloadHash != expectedHash) {
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
    Directory resourceDir = Directory(Env.resourcesPath);
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
      // TODO: Improve the handling of this. This will break the application.
    }
  }

  /// Removes the existing database files and builds new database.
  ///
  /// Quizzes and activities will only be replaced if the models from the CMS
  /// have more recent 'lastModified' timestamps. This means that user inputs
  /// and scores will be retained for unmodified quizzes/activities.
  static Future<bool> _rebuildDatabase(Map<String, dynamic> data) async {
    // Below code causes new database file to be created if it doesn't exist.
    SqfliteAdapter adapter = await DB.instance.adapter;

    MediaFileBean mediaFileBean = MediaFileBean(adapter);
    await mediaFileBean.drop();
    await mediaFileBean.createTable();
    for (Map<String, dynamic> map in data['mediaFiles']) {
      mediaFileBean.insert(mediaFileBean.fromMap(map));
    }

    FactFileCategoryBean factFileCategoryBean = FactFileCategoryBean(adapter);
    await factFileCategoryBean.drop();
    await factFileCategoryBean.createTable();
    for (Map<String, dynamic> map in data['factFileCategories']) {
      await factFileCategoryBean.insert(factFileCategoryBean.fromMap(map));
    }

    FactFileEntryBean factFileEntryBean = FactFileEntryBean(adapter);
    await factFileEntryBean.drop();
    await factFileEntryBean.createTable();
    for (Map<String, dynamic> map in data['factFileEntries']) {
      await factFileEntryBean.insert(factFileEntryBean.fromMap(map));
    }

    FactFileEntryImageBean factFileEntryImageBean =
        FactFileEntryImageBean(adapter);
    await factFileEntryImageBean.drop();
    await factFileEntryImageBean.createTable();
    for (Map<String, dynamic> map in data['factFileEntryImages']) {
      await factFileEntryImageBean.insert(factFileEntryImageBean.fromMap(map));
    }

    FactFileNuggetBean factFileNuggetBean = FactFileNuggetBean(adapter);
    await factFileNuggetBean.drop();
    await factFileNuggetBean.createTable();
    for (Map<String, dynamic> map in data['factFileNuggets']) {
      await factFileNuggetBean.insert(factFileNuggetBean.fromMap(map));
    }

    TrackBean trackBean = TrackBean(adapter);
    await trackBean.drop();
    await trackBean.createTable();
    for (Map<String, dynamic> map in data['tracks']) {
      await trackBean.insert(trackBean.fromMap(map));
    }

    // Only replace activity if it has been modified.
    // This means user inputs will be retained where appropriate.
    ActivityBean activityBean = ActivityBean(adapter);
    await activityBean.createTable(ifNotExists: true);
    for (Map<String, dynamic> map in data['activities']) {
      // The activity retrieved from the CMS.
      Activity newActivity = activityBean.fromMap(map);

      // The activity already in the database.
      Activity oldActivity = await activityBean.find(newActivity.id);

      // If the new activity doesn't exist, create it.
      if (oldActivity == null) {
        await activityBean.insert(newActivity);
        print("Activity created");
        continue;
      }

      // If the activity has been modified, replace it with the newer
      // version.
      if (oldActivity.lastModified.isBefore(newActivity.lastModified)) {
        await activityBean.remove(newActivity.id);
        await activityBean.insert(newActivity);
        print("Activity updated");
        continue;
      }

      print("Activity unmodified");
    }

    ActivityImageBean activityImageBean = ActivityImageBean(adapter);
    await activityImageBean.drop();
    await activityImageBean.createTable();
    for (Map<String, dynamic> map in data['activityImages']) {
      await activityImageBean.insert(activityImageBean.fromMap(map));
    }

    QuizBean quizBean = QuizBean(adapter);
    await quizBean.createTable(ifNotExists: true);
    for (Map<String, dynamic> map in data['quizzes']) {
      Quiz newQuiz = quizBean.fromMap(map);
      newQuiz.unlocked = map['unlock_code'] == null;
      Quiz oldQuiz = await quizBean.find(newQuiz.id);

      // Insert new quiz if it doesn't already exist in database.
      if (oldQuiz == null) {
        quizBean.insert(newQuiz);
        print("Quiz inserted");
        continue;
      }

      // Replace quiz if the CMS provided a newer version.
      // This will remove user scores for this quiz.
      if (oldQuiz.lastModified.isBefore(newQuiz.lastModified)) {
        await quizBean.remove(newQuiz.id);
        await quizBean.insert(newQuiz);
        print("Quiz updated.");
        continue;
      }

      print("Quiz unmodified");
    }

    QuizQuestionBean quizQuestionBean = QuizQuestionBean(adapter);
    await quizQuestionBean.drop();
    await quizQuestionBean.createTable();
    for (Map<String, dynamic> map in data['quizQuestions']) {
      await quizQuestionBean.insert(quizQuestionBean.fromMap(map));
    }

    QuizAnswerBean quizAnswerBean = QuizAnswerBean(adapter);
    await quizAnswerBean.drop();
    await quizAnswerBean.createTable();
    for (Map<String, dynamic> map in data['quizAnswers']) {
      await quizAnswerBean.insert(quizAnswerBean.fromMap(map));
    }

    ConfigBean configBean = ConfigBean(adapter);
    await configBean.drop();
    await configBean.createTable();
    for (Map<String, dynamic> map in data['config']) {
      await configBean.insert(configBean.fromMap(map));
    }

    return true;

    // TODO: Gotta be a better way of doing this without so much repeated code
  }

  /// Downloads and checks integrity of new data and files, before deleting
  /// existing content and rebuilding.
  ///
  /// Current implementation will result in the loss of any user data
  /// (activity inputs, answers, scores, etc) if a newer version of the
  /// activity/quiz is available.
  static Future<bool> syncResources(Map<String, bool> updatesAvailable) async {
    print('Syncing application resources with CMS server...');

    if (!await Permissions.ensurePermission(PermissionGroup.storage)) {
      print('Permission to write to storage not granted');
      return false;
    }

    Map<String, bool> updatesAvailable = await updatedDataAvailable();
    Map<String, dynamic> data;
    File payload;

    if (updatesAvailable['data']) {
      data = await _downloadData();
      if (data == null) return false;
    } else {
      print('Application database up to date!');
    }

    if (updatesAvailable['files']) {
      payload = await _downloadZipFile();
      if (payload == null) return false;
    } else {
      print('Application media files up to date!');
    }

    // Removing existing files and extracting zip in its place.
    if (payload != null) bool extracted = await _extractFileStructure(payload);

    // Deleting existing database and rebuilding
    if (data != null) bool dataRebuilt = await _rebuildDatabase(data);

    print('Application content successfully synced.');
    return true;
  }

  /// Returns true is updated resources are available on the remote server.
  static Future<Map<String, bool>> updatedDataAvailable() async {
    Config local;
    ConfigBean cfgBean = ConfigBean(await DB.instance.adapter);

    try {
      local = await cfgBean.find(1);
    } catch (ex) {
      if (ex is DatabaseException) {
        // Probably first-time sync, tables don't exist yet.
        return {'data': true, 'files': true};
      }
      throw ex; // otherwise, throw the exception
    }

    http.Response response = await http.get(Env.versionsUrl);
    if (response.statusCode != 200) {
      throw Exception('API responded with error - Error code: ' +
          response.statusCode.toString());
    }

    var remote = json.decode(response.body);

// Compare remote versions to local versions, setting to 'true' if a
// newer version is available on the server.
    return {
      'data': (remote['data'] as int) > local.dataVersion,
      'files': (remote['files'] as int) > local.filesVersion,
    };
  }
}
