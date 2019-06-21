import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Env {
  //----------------------- APP CONFIGURATION ----------------------------------
  // Here you can configure basic information about the app.

  /// Name of the app
  static const String appName = 'Discover Deep Cove';

  //----------------------- API CONFIGURATION ----------------------------------
  // Here you are able to configure the various API routes that will be used
  // when communicating with the CMS server.

  /// API access token
  static const String _accessToken = '8WU6AMYEcWvdvJXYiWLS6MMaUtpO96E8';

  /// Root URL of the content management system
  static const String _cmsUrl = 'https://mylittleblue.xyz';

  /// API URL for retrieving database data in JSON format
  static const String _dataSyncUrl = '/api/sync-data';

  /// API URL for retrieving the SHA256 hash of the JSON payload delivered
  /// by the [_dataSyncUrl] request.
  static const String _dataHashUrl = '/api/sync-data-hash';

  /// API URL for retrieving zipped application files (images/audio)
  static const String _filesSyncUrl = '/api/sync-files';

  /// API URL for retrieving the SHA256 hash of the zipped file retrieved by
  /// the [_filesSyncUrl] request.
  static const String _filesHashUrl = '/api/sync-files-hash';

  //------------------------- PATH CONFIGURATION -------------------------------
  // Here you are able to configure the paths that will be used to store
  // application files. Paths are relative to the internal storage directory
  // provided by the PATH_PROVIDER package.
  //
  // If `debugStorageMode` is true, then the application will store its files
  // in the external storage directory provided by the PATH_PROVIDER package.
  // ***NOTE: This mode will break the app for iOS, and should be set to false
  // in production.***

  /// If true, application storage paths will be relative to the external
  /// storage directory, otherwise the internal storage directory will be
  /// used. ** Setting to true will break app for iOS. Turn off for release.
  static const bool debugStorageMode = true;

  /// Relative path of the database file, from the applications root
  /// storage directory.
  static const String _dbPath = 'data/deep_cove.db';

  /// Relative path to which the zip file from the server will be extracted.
  static const String _resourcesPath = 'resources';

  //-------------------------- HELPER METHODS ----------------------------------
  //---------------------------(do not edit)------------------------------------
  // These perform basic processing on configured variables, in order to return
  // more useful information to the application code.

  /// Returns the full URL for retrieving database data in JSON format,
  /// including the access token.
  static String get dataSyncUrl {
    return _cmsUrl + _dataSyncUrl + '?token=' + _accessToken;
  }

  /// Returns the full URL for retrieving zipped application files
  /// (images/audio)
  static String get filesSyncUrl {
    return _cmsUrl + _filesSyncUrl + '?token=' + _accessToken;
  }

  /// Returns the full URL for retrieving the SHA256 hash of the JSON data
  /// retrieved by the [dataSyncUrl] request.
  static String get dataHashUrl {
    return _cmsUrl + _dataHashUrl + '?token=' + _accessToken;
  }

  /// Returns the full URL for retrieving the SHA256 hash of the zipped
  /// file downloaded by the [filesSyncUrl] request.
  static String get filesHashUrl {
    return _cmsUrl + _filesHashUrl + '?token=' + _accessToken;
  }

  /// Returns the root storage directory for application files.
  static Future<String> get rootStorageDirPath async {
    Directory dir = debugStorageMode
        ? await getExternalStorageDirectory()
        : getApplicationDocumentsDirectory();

    return join(dir.path, 'discover_deep_cove');
  }

  /// Returns the path to the database file.
  static Future<String> get dbPath async =>
      join(await rootStorageDirPath, _dbPath);

  /// Returns the path to the resources directory.
  static Future<String> get resourcesPath async =>
      join(await rootStorageDirPath, _resourcesPath);

  /// Returns the absolute path to a resource file, given the relative
  /// path from the applications root storage directory.
  static Future<String> getResource(String relativePath) async {
    String rootPath = await resourcesPath;
    return join(rootPath, relativePath);
  }
}
