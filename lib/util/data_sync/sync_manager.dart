import 'package:flutter/cupertino.dart';

enum SyncState {
  None, // not started
  Initialization, // creating temp db, connecting to db
  Discovery, // learning local and remote resources
  MediaDownload, // downloading media files
  DataDownload, // downloading data
  Cleanup, // replacing db, deleting unused files
  Done  // completed
}

class SyncManager {
  SyncState syncState;
  VoidCallback onProgressChange;

  SyncManager({this.onProgressChange});

  /// Initiates the sync process for the app
  void sync(){

  }

}
