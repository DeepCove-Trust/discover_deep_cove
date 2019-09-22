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
import 'package:discover_deep_cove/util/data_sync/media_sync.dart';
import 'package:discover_deep_cove/util/network_util.dart';

enum SyncState {
  /// The sync process has not yet begun
  None,
  /// In the process of checking connectivity, creating and connecting to
  /// databases.
  Initialization,
  /// Learning about local and remote resources
  Discovery,
  /// Downloading media files
  MediaDownload,
  /// Downloading other data/content
  DataDownload,
  /// Overwriting original db with new one, deleting unneeded media files
  Cleanup,
  /// The sync process has completed successfully.
  Done,
  /// The sync process has terminated due to an error
  Error
}

enum SyncError {
  /// Neither the internet nor the intranet CMS server was reachable, either
  /// due to the device not having internet access, or the CMS servers being
  /// unavailable.
  Server_Unreachable,
  /// The CMS API has returned an unexpected status code, and the sync process
  /// was unable to complete.
  Api_Error,
  /// The device has insufficient storage space to download all required media
  /// files, so the sync has been aborted.
  Insufficient_Storage,
  /// The sync process has been terminated due to an error.
  Other_Error
}

class SyncManager {
  SyncState syncState;
  CmsServerLocation serverLocation;
  SqfliteAdapter tempAdapter, adapter;

  void Function(SyncState, int) onProgressChange;

  SyncManager({this.onProgressChange}) : syncState = SyncState.None;

  /// Returns progress information to the widget that called the sync
  /// method.
  void _updateProgress(SyncState syncState, int percent) {
    this.syncState = syncState;
    onProgressChange(syncState, percent);
  }

  void _failUpdate({SyncError error = SyncError.Other_Error}) {
    _updateProgress(SyncState.Error, 0);

    // Todo: Do something here to clean up / revert
  }

  /// Initiates the sync process for the application
  Future<void> sync({bool firstLoad}) async {
    _updateProgress(SyncState.Initialization, 5);

    // -----------------------------------------------
    // ** Determine which server to use for update **

    // First, check whether the intranet is available
    serverLocation = await _getServerLocation();

    // If no server reachable, terminate
    if (serverLocation == null) {
      _failUpdate(error: SyncError.Server_Unreachable);
      return;
    } else {
      _updateProgress(SyncState.Initialization, 10);
    }

    // -----------------------------------------------
    // ** Establish database connections **

    // Check if database file already exists, copy as temp db if so.
    // Then open the connection to the database.
    File dbFile = File(Env.dbPath);
    if (await dbFile.exists()) dbFile.copy(Env.tempDbPath);

    tempAdapter = await DB.instance.tempAdapter;
    adapter = await DB.instance.adapter;
    adapter.close();
    // Ensure temp database has all tables created
    if (firstLoad) _initializeDatatables(tempAdapter);

    // ----------------------------------------------
    // ** Media files sync **

    _updateProgress(SyncState.Discovery, 15);

    MediaSync mediaSync = MediaSync(
        adapter: adapter,
        tempAdapter: tempAdapter,
        server: serverLocation,
        onFail: () => print('failed to update'));

    await mediaSync.buildQueues();
  }

  /// Returns intranet if intranet is available, else returns internet if
  /// internet is available, else null.
  Future<CmsServerLocation> _getServerLocation() async {
    if (await NetworkUtil.canAccessCMSLocal()) {
      return CmsServerLocation.Intranet;
    } else if (await NetworkUtil.canAccessCMSRemote()) {
      return CmsServerLocation.Internet;
    } else
      return null;
  }

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
