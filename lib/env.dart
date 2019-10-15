import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong/latlong.dart';

enum CmsServerLocation { Intranet, Internet }

/// This class provides easy access to the applications environment variables,
/// and other variables derived from these.
class Env {
  // The following variables are configured in the .env file.
  // There inclusion here means that we can use intellisense when
  // referring to them in code, via the [Env] class.

  static Future<void> load() async {
    Directory dir = debugStorageMode
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    _rootStorageDirPath = join(dir.path, 'discover_deep_cove');
  }

  static String get appName => DotEnv().env['appName'];

  /// Root URL of the content management system
  static String get remoteCmsUrl => DotEnv().env['remoteUrl'];

  /// IP address or domain name of the on-site server
  static String get intranetCmsUrl => DotEnv().env['intranetUrl'];

  // API Endpoints
  static String get _configUrl => DotEnv().env['config'];
  static String get _mediaUrl => DotEnv().env['media'];
  static String get _mediaDownloadUrl => DotEnv().env['mediaDownload'];
  static String get _quizzesUrl => DotEnv().env['quizzes'];
  static String get _factFilesUrl => DotEnv().env['factFiles'];
  static String get _tracksUrl => DotEnv().env['tracks'];
  static String get _activitiesUrl => DotEnv().env['activities'];


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

  static bool get asyncDownload =>
      DotEnv().env['asyncMediaDownload'].toLowerCase() == 'true';

  static String _rootStorageDirPath;

  /// Relative path of the database file, from the applications root
  /// storage directory.
  static String get _dbPath => DotEnv().env['databasePath'];

  /// Relative path of the temp database file, from the applications root
  /// storage directory.
  static String get _tempDbPath => DotEnv().env['tempDatabasePath'];

  /// Relative path to which the zip file from the server will be extracted.
  static String get _resourcesPath => DotEnv().env['resourcesPath'];

  //----------------------------MAP SETTINGS------------------------------------
  // These settings provide the zoom and pan limits for the map, as well as
  // default starting position.

  static double get mapMinZoom => double.parse(DotEnv().env['minZoom']);

  static double get mapMaxZoom => double.parse(DotEnv().env['maxZoom']);

  static double get mapDefaultZoom => double.parse(DotEnv().env['defaultZoom']);

  static LatLng get swPanBoundary => LatLng(
      double.parse(DotEnv().env['swPanBoundaryLat']),
      double.parse(DotEnv().env['swPanBoundaryLong']));

  static LatLng get nePanBoundary => LatLng(
        double.parse(DotEnv().env['nePanBoundaryLat']),
        double.parse(DotEnv().env['nePanBoundaryLong']),
      );

  static LatLng get mapDefaultCenter => LatLng(
        double.parse(DotEnv().env['defaultCenterLat']),
        double.parse(DotEnv().env['defaultCenterLong']),
      );

  //---------------------- HELPER METHODS - PATHS ------------------------------
  // These perform basic processing on configured variables, in order to return
  // more useful information to the application code.

  static String get rootStorageDirPath => _rootStorageDirPath;

  /// Returns the path to the database file.
  static String get dbPath => join(_rootStorageDirPath, _dbPath);

  /// Returns the path to the temp database file.
  static String get tempDbPath => join(_rootStorageDirPath, _tempDbPath);

  /// Returns the path to the resources directory.
  static String get resourcesPath => join(_rootStorageDirPath, _resourcesPath);

  /// Returns the absolute path to a resource file, given the relative
  /// path from the applications root storage directory.
  static String getResourcePath(String relativePath) {
    String rootPath = resourcesPath;
    return join(rootPath, relativePath);
  }

  //----------------------- HELPER METHODS - API  ------------------------------
  // These methods configure URLs to use when making requests to the CMS API

  static String _getCmsUrl(CmsServerLocation server) {
    return server == CmsServerLocation.Internet ? remoteCmsUrl : intranetCmsUrl;
  }

  /// API endpoint to return the latest config from the server.
  static String configUrl(CmsServerLocation server) {
    return _getCmsUrl(server) + _configUrl;
  }

  /// API endpoint to return summary of all required media files.
  static String mediaListUrl(CmsServerLocation server) {
    return _getCmsUrl(server) + _mediaUrl;
  }

  /// API endpoint to return details of a single media file.
  static String mediaDetailsUrl(CmsServerLocation server, int id) {
    return _getCmsUrl(server) + _mediaUrl + '/$id';
  }

  /// API endpoint to return the specified media file.
  static String mediaDownloadUrl(CmsServerLocation server, String filename) {
    return _getCmsUrl(server) +
        _mediaDownloadUrl +
        '?filename=$filename&original=true'; // Todo: remove original
  }

  /// API endpoint to return a summary of active quizzes.
  static String quizzesUrl(CmsServerLocation server) {
    return _getCmsUrl(server) + _quizzesUrl;
  }

  /// API endpoint to return details, questions and answers for a given
  /// quiz ID.
  static String quizDetailsUrl(CmsServerLocation server, int id) {
    return _getCmsUrl(server) + _quizzesUrl + '/$id';
  }

  /// API endpoint to retrieve summary of active fact files.
  static String factFilesListUrl(CmsServerLocation server){
    return _getCmsUrl(server) + _factFilesUrl;
  }

  /// API endpoint to retrieve details, including nuggets and gallery
  /// image IDs, for a given fact file ID.
  static String factFileDetailsUrl(CmsServerLocation server, int id){
    return _getCmsUrl(server) + _factFilesUrl + '/$id';
  }

  /// API endpoint to retrieve summary of active fact file categories.
  static String factFileCategoriesListUrl(CmsServerLocation server){
    return _getCmsUrl(server) + _factFilesUrl + '/categories';
  }

  /// API endpoint to retrieve list of active tracks, and their names.
  static String tracksListUrl(CmsServerLocation server){
    return _getCmsUrl(server) + _tracksUrl;
  }

  /// API endpoint to retrieve list of active activities.
  static String activitiesListUrl(CmsServerLocation server){
    return _getCmsUrl(server) + _activitiesUrl;
  }

  /// API endpoint to retrieve details for a given activity ID.
  static String activityDetailsUrl(CmsServerLocation server, int id){
    return _getCmsUrl(server) + _activitiesUrl + '/$id';
  }
}
