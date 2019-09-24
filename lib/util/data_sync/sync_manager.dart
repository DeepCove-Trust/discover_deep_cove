import 'dart:io';

import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/activity_image.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry_images.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_nugget.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/data/models/user_photo.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/data_sync/config_sync.dart';
import 'package:discover_deep_cove/util/data_sync/media_sync.dart';
import 'package:discover_deep_cove/util/exeptions.dart';
import 'package:discover_deep_cove/util/network_util.dart';

enum SyncState {
  /// The sync process has not yet begun
  None,

  /// In the process of checking connectivity, creating and connecting to
  /// databases.
  Initialization,

  /// A CMS server has been successfully contacted.
  ServerDiscovered,

  /// Downloading media files
  MediaDownload,

  /// Downloading other data/content
  DataDownload,

  /// Overwriting original db with new one, deleting unneeded media files
  Cleanup,

  /// The sync process has completed successfully.
  Done,

  /// The sync process has terminated due to an error
  Error_Permission,
  Error_Storage,
  Error_ServerUnreachable,
  Error_Other
}

class SyncManager {
  SyncState syncState = SyncState.None;
  CmsServerLocation serverLocation;
  SqfliteAdapter tempAdapter, adapter;

  // State, percentage complete, up to file, out of files, total size bytes
  void Function(SyncState, int, int, int, int) onProgressChange;

  SyncManager({this.onProgressChange}) : syncState = SyncState.None;

  /// Returns progress information to the widget that called the sync
  /// method.
  void _updateProgress(SyncState syncState, int percent,
      {int upTo, int outOf, int totalSize}) {
    this.syncState = syncState;
    onProgressChange(syncState, percent, upTo, outOf, totalSize);
  }

  Future<void> _failUpdate(Exception exception) async {

    SyncState errorState;

    if(exception is ServerUnreachableException) errorState = SyncState.Error_ServerUnreachable;
    else if(exception is InsufficientStorageException) errorState = SyncState.Error_Storage;
    else if(exception is InsufficientPermissionException) errorState = SyncState.Error_Permission;
    else errorState = SyncState.Error_Other;

    // Delete temp database - ignore exception if it wasn't yet created
    await File(Env.tempDbPath).delete().catchError((_){});

    _updateProgress(errorState, 0);
  }

  /// Initiates the sync process for the application
  Future<void> sync({bool firstLoad}) async {
    try {
      _updateProgress(SyncState.Initialization, 0);

      // -----------------------------------------------
      // ** Determine which server to use for update **

      // First, check whether the intranet is available
      serverLocation = await _getServerLocation();
      _updateProgress(SyncState.ServerDiscovered, 5);

      // -----------------------------------------------
      // ** Establish database connections **

      // Check if database file already exists, copy as temp db if so.
      // Then open the connection to the database.
      File dbFile = File(Env.dbPath);
      if (await dbFile.exists()) dbFile.copy(Env.tempDbPath);

      tempAdapter = await DB.instance.tempAdapter;
      adapter = await DB.instance.adapter;

      // Ensure all tables exist
      _initializeDatatables(tempAdapter);
      _initializeDatatables(adapter);

      // ----------------------------------------------
      // ** Media files sync **

      _updateProgress(SyncState.MediaDownload, 10);

      MediaSync mediaSync = MediaSync(
          adapter: adapter,
          tempAdapter: tempAdapter,
          server: serverLocation,
          onProgress: _updateProgress);

      // Build the download, update and deletion queues for media files
      await mediaSync.buildQueues();

      _updateProgress(SyncState.MediaDownload, 15);

      // Process the update queue for media files
      await mediaSync.processUpdateQueue();

      _updateProgress(SyncState.MediaDownload, 20);

      // Process the download queue for media files
      await mediaSync.processDownloadQueue(asyncDownload: true);
      //await mediaSync.processDownloadQueueSync();

      _updateProgress(SyncState.DataDownload, 80);

      // Sync the config table
      await ConfigSync(tempAdapter, server: serverLocation).sync();
    }
    on Exception catch(ex){
      _failUpdate(ex);
    }
  }

  /// Returns intranet if intranet CMS is available, else returns internet if
  /// internet CMS is available, else throws [ServerUnreachableException].
  Future<CmsServerLocation> _getServerLocation() async {
    if (await NetworkUtil.canAccessCMSLocal()) {
      print('Connectivity established with intranet server.');
      return CmsServerLocation.Intranet;
    } else if (await NetworkUtil.canAccessCMSRemote()) {
      print('Connectivity established with internet server.');
      return CmsServerLocation.Internet;
    } else
      throw ServerUnreachableException(message: 'CMS server was not reachable');
  }

  /// Creates all database tables for the provided database adapter, if not
  /// exists.
  void _initializeDatatables(SqfliteAdapter a) {
    ConfigBean(a).createTable(ifNotExists: true);
    ActivityBean(a).createTable(ifNotExists: true);
    ActivityImageBean(a).createTable(ifNotExists: true);
    TrackBean(a).createTable(ifNotExists: true);
    FactFileEntryBean(a).createTable(ifNotExists: true);
    FactFileCategoryBean(a).createTable(ifNotExists: true);
    FactFileNuggetBean(a).createTable(ifNotExists: true);
    FactFileEntryImageBean(a).createTable(ifNotExists: true);
    QuizBean(a).createTable(ifNotExists: true);
    QuizQuestionBean(a).createTable(ifNotExists: true);
    QuizAnswerBean(a).createTable(ifNotExists: true);
    MediaFileBean(a).createTable(ifNotExists: true);
    UserPhotoBean(a).createTable(ifNotExists: true);
  }
}
