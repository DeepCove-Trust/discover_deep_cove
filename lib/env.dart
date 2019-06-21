import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// This class provides easy access to the applications environment variables,
/// and other variables derived from these.
class Env {
  // The following variables are configured in the .env file.
  // There inclusion here means that we can use intellisense when
  // referring to them in code, via the [Env] class.

  static String get appName => DotEnv().env['appName'];

  /// API access token
  static String get _accessToken => DotEnv().env['accessToken'];

  /// Root URL of the content management system
  static String get _cmsUrl => DotEnv().env['remoteUrl'];

  /// API URL for retrieving database data in JSON format
  static String get _dataSyncUrl => DotEnv().env['dataSyncUrl'];

  /// API URL for retrieving the SHA256 hash of the JSON payload delivered
  /// by the [_dataSyncUrl] request.
  static String get _dataHashUrl => DotEnv().env['dataHashUrl'];

  /// API URL for retrieving zipped application files (images/audio)
  static String get _filesSyncUrl => DotEnv().env['filesSyncUrl'];

  /// API URL for retrieving the SHA256 hash of the zipped file retrieved by
  /// the [_filesSyncUrl] request.
  static String get _filesHashUrl => DotEnv().env['filesHashUrl'];

  //-------------------------------- PATHS  ------------------------------------

  // If `debugStorageMode` is true, then the application will store its files
  // in the external storage directory provided by the PATH_PROVIDER package.
  // ***NOTE: This mode will break the app for iOS, and should be set to false
  // in production.***

  /// If true, application storage paths will be relative to the external
  /// storage directory, otherwise the internal storage directory will be
  /// used. ** Setting to true will break app for iOS. Turn off for release.
  static bool get debugStorageMode =>
      DotEnv().env['debugStorageMode'].toLowerCase() == 'true';

  /// Relative path of the database file, from the applications root
  /// storage directory.
  static String get _dbPath => DotEnv().env['databasePath'];

  /// Relative path to which the zip file from the server will be extracted.
  static String get _resourcesPath => DotEnv().env['resourcesPath'];

  //-------------------------- HELPER METHODS ----------------------------------
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
