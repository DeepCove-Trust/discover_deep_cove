import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/data_sync/sync_manager.dart';
import 'package:discover_deep_cove/util/network_util.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

class MediaData {
  final int id;
  final int size;
  final DateTime updatedAt;

  MediaData({this.id, this.size, this.updatedAt});

  MediaData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        size = json['size'],
        updatedAt = DateTime.parse(json['updatedAt']);
}

class MediaSync {
  CmsServerLocation server;
  SqfliteAdapter tempAdapter, adapter;
  void Function(SyncError) onFail;

  MediaSync(
      {@required this.adapter,
      @required this.tempAdapter,
      @required this.server,
      @required this.onFail});

  Queue<MediaData> _downloadQueue;
  Queue<MediaFile> _deletionQueue;
  Queue<MediaFile> _updateQueue;

  /// Populate the download and deletion queues for later use
  Future<void> buildQueues() async {
    // Retrieve list of locally existing media files
    List<MediaFile> localMediaFiles = await MediaFileBean(tempAdapter).getAll();

    // Retrieve list of required media files from server, as MediaData objects
    String jsonString = await NetworkUtil.requestData(Env.mediaListUrl(server));
    List<dynamic> jsonData = json.decode(jsonString);
    List<MediaData> remoteMedia =
        jsonData.map((i) => MediaData.fromJson(i)).toList();

    // CALCULATE DOWNLOAD QUEUE
    // All remote media that do not exist locally
    _downloadQueue = Queue.from(
        remoteMedia.where((e) => !localMediaFiles.any((f) => f.id == e.id)));

    // CALCULATE UPDATE QUEUE
    // Any local media that exist remotely, and the remote timestamp is after
    // the local timestamp
    _updateQueue = Queue.from(localMediaFiles.where((e) => remoteMedia
        .any((f) => f.id == e.id && f.updatedAt.isAfter(e.updatedAt))));

    // CALCULATE DELETION QUEUE
    // Any local media that don't exist in the remote media list
    _deletionQueue = Queue.from(
        localMediaFiles.where((e) => !remoteMedia.any((f) => f.id == e.id)));
  }

  /// Iterates through the download queue and downloads each file, adding
  /// a record to both databases to point to this file.
  /// Performs a free-storage check prior to downloading.
  Future<void> processDownloadQueue() async {
    MediaFileBean mediaFileBeanMain = MediaFileBean(adapter);
    MediaFileBean mediaFileBeanTemp = MediaFileBean(adapter);

    if (!(await sufficientStorageAvailable())) {
      onFail(SyncError.Insufficient_Storage);
      return;
    }

    while(_downloadQueue.isNotEmpty){
      MediaData mediaData = _downloadQueue.removeFirst();

      // Todo: Asynchonously download all files

      // Request file meta data from server

      // Download file from server

      // Add database records

      // Save file to directory
    }
  }

  /// Returns true if the device has enough available space to download
  /// required media files
  Future<bool> sufficientStorageAvailable() async {
    // Calculate sum of all file sizes, in bytes
    int requiredSize = _downloadQueue.fold<int>(0, (v, n) => v + n.size);

    // Calculate available storage space
    int availableSize = await Util.getAvailableStorageSpace();

    if (requiredSize > availableSize - 10000000) {
      return false;
    }

    return true;
  }

  /// Iterates through the update queue and updates each media file that
  /// has been updated on the CMS.
  Future<void> processUpdateQueue() async {
    MediaFileBean mediaFileBean = MediaFileBean(adapter);
    for (MediaFile mediaFile in _updateQueue) {
      // Todo: Complete this
    }
  }

  /// Iterates through the deletion queue and deletes both the file and
  /// the database record that points to the file.
  Future<void> processDeletionQueue() async {
    MediaFileBean mediaFileBean = MediaFileBean(adapter);
    for (MediaFile mediaFile in _deletionQueue) {
      await File(mediaFile.path).delete();
      await mediaFileBean.remove(mediaFile.id);
    }
  }
}
