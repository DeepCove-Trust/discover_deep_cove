import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/db.dart';
import '../../data/models/activity/activity.dart';
import '../../data/models/activity/activity_image.dart';
import '../../data/models/activity/track.dart';
import '../../data/models/config.dart';
import '../../data/models/factfile/fact_file_category.dart';
import '../../data/models/factfile/fact_file_entry.dart';
import '../../data/models/factfile/fact_file_entry_image.dart';
import '../../data/models/factfile/fact_file_nugget.dart';
import '../../data/models/media_file.dart';
import '../../data/models/notice.dart';
import '../../data/models/quiz/quiz.dart';
import '../../data/models/quiz/quiz_answer.dart';
import '../../data/models/quiz/quiz_question.dart';
import '../../data/models/user_photo.dart';
import '../../env.dart';
import '../exeptions.dart';
import '../network_util.dart';
import '../noticeboard_sync.dart';
import 'config_sync.dart';
import 'fact_file_sync.dart';
import 'media_sync.dart';
import 'quiz_sync.dart';
import 'track_sync.dart';

enum SyncState {
  /// The sync process has not yet begun
  none,

  /// In the process of checking connectivity, creating and connecting to
  /// databases.
  initialization,

  /// A CMS server has been successfully contacted.
  serverDiscovered,

  /// Discovering required media files
  mediaDiscovery,

  /// Downloading media files
  mediaDownload,

  /// Downloading other data/content
  dataDownload,

  /// Overwriting original db with new one, deleting unneeded media files
  cleanup,

  /// The sync process has completed successfully.
  done,

  /// The sync process has terminated due to an error
  errorPermission,
  errorStorage,
  errorServerUnreachable,
  rrorOther
}

class SyncManager {
  // ignore: unused_field
  SyncState _syncState = SyncState.none;
  CmsServerLocation _serverLocation;
  SqfliteAdapter _tempAdapter, _adapter;
  BuildContext context;

  // State, percentage complete, up to file, out of files, total size bytes
  void Function(SyncState, int, int, int, int) onProgressChange;

  SyncManager({this.onProgressChange, @required this.context}) : _syncState = SyncState.none;

  /// Returns progress information to the widget that called the sync
  /// method.
  void _updateProgress(SyncState syncState, int percent, {int upTo, int outOf, int totalSize}) {
    _syncState = syncState;
    onProgressChange(syncState, percent, upTo, outOf, totalSize);
  }

  Future<void> _failUpdate(Exception exception) async {
    SyncState errorState;

    if (exception is ServerUnreachableException) {
      errorState = SyncState.errorServerUnreachable;
    } else if (exception is InsufficientStorageException) {
      errorState = SyncState.errorStorage;
    } else if (exception is InsufficientPermissionException) {
      errorState = SyncState.errorPermission;
    } else {
      errorState = SyncState.rrorOther;
    }

    // Delete temp database - ignore exception if it wasn't yet created
    await File(Env.tempDbPath).delete().catchError((_) {});

    _updateProgress(errorState, 0);
  }

  /// Initiates the sync process for the application
  Future<void> sync({bool firstLoad}) async {
    try {
      _updateProgress(SyncState.initialization, 0);

      // -----------------------------------------------
      // ** Determine which server to use for update **

      // First, check whether the intranet is available
      _serverLocation = await _getServerLocation();
      _updateProgress(SyncState.serverDiscovered, 5);

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

      _updateProgress(SyncState.mediaDiscovery, 10);

      MediaSync mediaSync = MediaSync(
          adapter: _adapter,
          tempAdapter: _tempAdapter,
          server: _serverLocation,
          context: context,
          onProgress: _updateProgress);

      // Build the download, update and deletion queues for media files -
      await mediaSync.buildQueues();
      _updateProgress(SyncState.mediaDiscovery, 15);
      // ----------------------------------------------------------------

      // Process the update queue for media files -----------------------
      await mediaSync.processUpdateQueue();
      _updateProgress(SyncState.mediaDiscovery, 20);
      // ----------------------------------------------------------------

      // Process the download queue for media files ---------------------
      await mediaSync.processDownloadQueue();
      _updateProgress(SyncState.dataDownload, 80);
      // ----------------------------------------------------------------

      // ** END MEDIA FILES SYNC ** -------------------------------------
      // ================================================================

      // ================================================================
      // ** BEGIN DATA SYNC **

      TrackSync trackSync = TrackSync(_tempAdapter, server: _serverLocation);

      // Sync the config table ------------------------------------------
      await ConfigSync(_tempAdapter, server: _serverLocation).sync();
      _updateProgress(SyncState.dataDownload, 84);
      //-----------------------------------------------------------------

      // Sync the quiz related tables -----------------------------------
      await QuizSync(_tempAdapter, server: _serverLocation).sync();
      _updateProgress(SyncState.dataDownload, 88);
      // ----------------------------------------------------------------

      // Sync the fact files --------------------------------------------
      await FactFileSync(_tempAdapter, server: _serverLocation).sync();
      _updateProgress(SyncState.dataDownload, 92);
      // ----------------------------------------------------------------

      // Sync tracks and activities -------------------------------------
      await trackSync.sync();
      // ----------------------------------------------------------------

      // ** END DATA SYNC ** --------------------------------------------
      // ================================================================

      // ================================================================
      // ** CLEANUP PHASE ** --------------------------------------------

      _updateProgress(SyncState.cleanup, 95);

      // Overwrite original database
      await File(Env.tempDbPath).copy(Env.dbPath);

      _updateProgress(SyncState.cleanup, 98);

      // Delete files in the deletion queues
      await mediaSync.processDeletionQueue(); // Delete unused media files
      await trackSync.processDeletionQueue(_adapter); // Delete old user photos

      // Delete temp database and reset adaptor
      await DB.instance.resetTempAdapter();
      await File(Env.tempDbPath).delete();

      // ** END CLEANUP PHASE **
      // ================================================================

      // Check for new notices
      NoticeboardSync.retrieveNotices(context);

      // DATA SYNC COMPLETE!
      _updateProgress(SyncState.done, 100);
    } on Exception catch (ex, stacktrace) {
      debugPrint(ex.toString());
      debugPrint(stacktrace.toString());
      _failUpdate(ex);
    }
  }

  /// Returns intranet if intranet CMS is available, else returns internet if
  /// internet CMS is available, else throws [ServerUnreachableException].
  Future<CmsServerLocation> _getServerLocation() async {
    if (await NetworkUtil.canAccessCMSLocal()) {
      if (Env.debugMessages) debugPrint('Connectivity established with intranet server.');
      return CmsServerLocation.intranet;
    } else if (await NetworkUtil.canAccessCMSRemote()) {
      if (Env.debugMessages) debugPrint('Connectivity established with internet server.');
      return CmsServerLocation.internet;
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
    NoticeBean(adapter).createTable(ifNotExists: true);
  }
}
