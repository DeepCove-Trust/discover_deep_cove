import 'dart:io';

import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/activity_image.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry_image.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_nugget.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_answer.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz_question.dart';
import 'package:discover_deep_cove/data/models/user_photo.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/data_sync/config_sync.dart';
import 'package:discover_deep_cove/util/data_sync/fact_file_sync.dart';
import 'package:discover_deep_cove/util/data_sync/media_sync.dart';
import 'package:discover_deep_cove/util/data_sync/quiz_sync.dart';
import 'package:discover_deep_cove/util/data_sync/track_sync.dart';
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
  SyncState _syncState = SyncState.None;
  CmsServerLocation _serverLocation;
  SqfliteAdapter _tempAdapter, _adapter;

  // State, percentage complete, up to file, out of files, total size bytes
  void Function(SyncState, int, int, int, int) onProgressChange;

  SyncManager({this.onProgressChange}) : _syncState = SyncState.None;

  /// Returns progress information to the widget that called the sync
  /// method.
  void _updateProgress(SyncState syncState, int percent,
      {int upTo, int outOf, int totalSize}) {
    this._syncState = syncState;
    onProgressChange(syncState, percent, upTo, outOf, totalSize);
  }

  Future<void> _failUpdate(Exception exception) async {
    SyncState errorState;

    if (exception is ServerUnreachableException)
      errorState = SyncState.Error_ServerUnreachable;
    else if (exception is InsufficientStorageException)
      errorState = SyncState.Error_Storage;
    else if (exception is InsufficientPermissionException)
      errorState = SyncState.Error_Permission;
    else
      errorState = SyncState.Error_Other;

    // Delete temp database - ignore exception if it wasn't yet created
    await File(Env.tempDbPath).delete().catchError((_) {});

    _updateProgress(errorState, 0);
  }

  /// Initiates the sync process for the application
  Future<void> sync({bool firstLoad}) async {
    try {
      _updateProgress(SyncState.Initialization, 0);

      // -----------------------------------------------
      // ** Determine which server to use for update **

      // First, check whether the intranet is available
      _serverLocation = await _getServerLocation();
      _updateProgress(SyncState.ServerDiscovered, 5);

      // -----------------------------------------------
      // ** Establish database connections **

      // Check if database file already exists, copy as temp db if so.
      // Then open the connection to the database.
      File dbFile = File(Env.dbPath);
      if (await dbFile.exists()) dbFile.copy(Env.tempDbPath);

      _tempAdapter = await DB.instance.tempAdapter;
      _adapter = await DB.instance.adapter;

      // Ensure all tables exist
      _initializeDatatables(_tempAdapter);
      _initializeDatatables(_adapter);

      // ================================================================
      // ** BEGIN MEDIA FILES SYNC **

      _updateProgress(SyncState.MediaDownload, 10);

      MediaSync mediaSync = MediaSync(
          adapter: _adapter,
          tempAdapter: _tempAdapter,
          server: _serverLocation,
          onProgress: _updateProgress);

      // Build the download, update and deletion queues for media files -
      await mediaSync.buildQueues();
      _updateProgress(SyncState.MediaDownload, 15);
      // ----------------------------------------------------------------

      // Process the update queue for media files -----------------------
      await mediaSync.processUpdateQueue();
      _updateProgress(SyncState.MediaDownload, 20);
      // ----------------------------------------------------------------

      // Process the download queue for media files ---------------------
      await mediaSync.processDownloadQueue(asyncDownload: Env.asyncDownload);
      _updateProgress(SyncState.DataDownload, 80);
      // ----------------------------------------------------------------

      // ** END MEDIA FILES SYNC ** -------------------------------------
      // ================================================================

      // ================================================================
      // ** BEGIN DATA SYNC **

      TrackSync trackSync = TrackSync(_tempAdapter, server: _serverLocation);

      // Sync the config table ------------------------------------------
      await ConfigSync(_tempAdapter, server: _serverLocation).sync();
      _updateProgress(SyncState.DataDownload, 84);
      //-----------------------------------------------------------------

      // Sync the quiz related tables -----------------------------------
      await QuizSync(_tempAdapter, server: _serverLocation).sync();
      _updateProgress(SyncState.DataDownload, 88);
      // ----------------------------------------------------------------

      // Sync the fact files --------------------------------------------
      await FactFileSync(_tempAdapter, server: _serverLocation).sync();
      _updateProgress(SyncState.DataDownload, 92);
      // ----------------------------------------------------------------

      // Sync tracks and activities -------------------------------------
      await trackSync.sync();
      // ----------------------------------------------------------------

      // ** END DATA SYNC ** --------------------------------------------
      // ================================================================

      // ================================================================
      // ** CLEANUP PHASE ** --------------------------------------------

      _updateProgress(SyncState.Cleanup, 95);

      // Overwrite original database
      await File(Env.tempDbPath).copy(Env.dbPath);

      _updateProgress(SyncState.Cleanup, 98);

      // Delete files in the deletion queues
      await mediaSync.processDeletionQueue(); // Delete unused media files
      await trackSync.processDeletionQueue(_adapter); // Delete old user photos

      // Delete temp database
      await File(Env.tempDbPath).delete();

      // ** END CLEANUP PHASE **
      // ================================================================

      // DATA SYNC COMPLETE!
      _updateProgress(SyncState.Done, 100);
    } on Exception catch (ex) {
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
    }
    throw ServerUnreachableException();
  }

  /// Creates all database tables for the provided database adapter, if not
  /// exists.
  void _initializeDatatables(SqfliteAdapter adapter) {
    ConfigBean(adapter).createTable(ifNotExists: true);
    ActivityBean(adapter).createTable(ifNotExists: true);
    ActivityImageBean(adapter).createTable(ifNotExists: true);
    TrackBean(adapter).createTable(ifNotExists: true);
    FactFileEntryBean(adapter).createTable(ifNotExists: true);
    FactFileCategoryBean(adapter).createTable(ifNotExists: true);
    FactFileNuggetBean(adapter).createTable(ifNotExists: true);
    FactFileEntryImageBean(adapter).createTable(ifNotExists: true);
    QuizBean(adapter).createTable(ifNotExists: true);
    QuizQuestionBean(adapter).createTable(ifNotExists: true);
    QuizAnswerBean(adapter).createTable(ifNotExists: true);
    MediaFileBean(adapter).createTable(ifNotExists: true);
    UserPhotoBean(adapter).createTable(ifNotExists: true);
  }
}
