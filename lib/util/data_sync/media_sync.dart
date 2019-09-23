import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'package:path/path.dart';
import 'dart:io';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/data_sync/sync_manager.dart';
import 'package:discover_deep_cove/util/network_util.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

/// Class to which the media list API data will deserialize into.
class MediaData {
  final int id;
  final int size;
  final String filename;
  final DateTime updatedAt;

  MediaData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        size = json['size'],
        filename = json['filename'],
        updatedAt = DateTime.parse(json['updatedAt']);
}

class MediaSync {
  CmsServerLocation server;
  SqfliteAdapter tempAdapter, adapter;
  void Function(SyncError) onFail;
  void Function(int, int, int) onProgress;

  MediaSync({@required this.adapter,
    @required this.tempAdapter,
    @required this.server,
    @required this.onProgress,
    @required this.onFail});

  Queue<MediaData> _downloadQueue;
  Queue<MediaFile> _deletionQueue;
  Queue<MediaFile> _updateQueue;

  /// Populate the download and deletion queues for later use
  Future<void> buildQueues() async {
    // Retrieve list of locally existing media files
    List<MediaFile> localMediaFiles = await MediaFileBean(tempAdapter).getAll();

    // Retrieve list of required media files from server, as MediaData objects
    String jsonString = await NetworkUtil.requestDataString(
        Env.mediaListUrl(server));
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
    _updateQueue = Queue.from(localMediaFiles.where((e) =>
        remoteMedia
            .any((f) => f.id == e.id && f.updatedAt.isAfter(e.updatedAt))));

    // CALCULATE DELETION QUEUE
    // Any local media that don't exist in the remote media list
    _deletionQueue = Queue.from(
        localMediaFiles.where((e) => !remoteMedia.any((f) => f.id == e.id)));
  }

  /// Iterates through the download queue and downloads each file asynchronously,
  /// adding database records and saving to disk as files are received.
  /// Performs a free-storage check prior to downloading.
  Future<void> processDownloadQueue() async {
    MediaFileBean mediaFileBeanMain = MediaFileBean(adapter);
    MediaFileBean mediaFileBeanTemp = MediaFileBean(tempAdapter);

    if (!(await sufficientStorageAvailable())) {
      onFail(SyncError.Insufficient_Storage);
      return;
    }

    while (_downloadQueue.isNotEmpty) {
      MediaData mediaData = _downloadQueue.removeFirst();

      // Todo: Asynchonously download all files

      // Request file meta data from server

      // Download file from server

      // Add database records

      // Save file to directory
    }
  }

  /// Iterates through the download queue one file at a time. Downloads the
  /// file, saves database records, then saves to disk.
  /// Performs a storage check before downloading.
  /// NOTE: This method is not itself synchronous.
  Future<void> processDownloadQueueSync() async {
    MediaFileBean mediaFileBeanMain = MediaFileBean(adapter);
    MediaFileBean mediaFileBeanTemp = MediaFileBean(tempAdapter);

    if (!(await sufficientStorageAvailable())) {
      onFail(SyncError.Insufficient_Storage);
      return;
    }

    while (_downloadQueue.isNotEmpty) {
      MediaData mediaData = _downloadQueue.removeFirst();

      // Todo: Synchronously download all files

      // Request file meta data from server
      String jsonString = await NetworkUtil.requestDataString(
          Env.mediaDetailsUrl(server, mediaData.id));
      MediaFile mediaFile = mediaFileBeanMain.fromMap(json.decode(jsonString));

      // Download file from server
      String absPath = Env.getResourcePath(mediaFile.category);
      String filename = mediaData.filename;
      Http.Response response = await Http.get(Env.mediaDownloadUrl(server, filename));

      // Assign path to mediaFile object
      mediaFile.path = join(mediaFile.category, mediaData.filename);

      // Add database records
      await mediaFileBeanTemp.insert(mediaFile);
      await mediaFileBeanMain.insert(mediaFile);

      // Save file to directory
      try {
        await NetworkUtil.httpResponseToFile(
            response: response, absPath: absPath, filename: filename);
      }
      catch(ex){
        // Exception while saving file, remove database records
        await mediaFileBeanTemp.remove(mediaFile.id);
        await mediaFileBeanMain.remove(mediaFile.id);
        onFail(SyncError.Other_Error);
        return;
      }
    }
  }

  /// Adds supplied MediaFile record to both temp and main databases
  Future<void> insertMediaRecord(MediaFile mediaFile) async {
    MediaFileBean mediaFileBeanMain = MediaFileBean(adapter);
    MediaFileBean mediaFileBeanTemp = MediaFileBean(tempAdapter);
    await mediaFileBeanMain.insert(mediaFile);
    await mediaFileBeanTemp.insert(mediaFile);
  }

  /// Returns true if the device has enough available space to download
  /// required media files (with > 10MB spare)
  Future<bool> sufficientStorageAvailable() async {
    print('Calculating storage requirements...');

    // Calculate sum of all file sizes, in bytes
    int requiredSize = _downloadQueue.fold<int>(0, (v, n) => v + n.size);
    print('Download requires $requiredSize bytes');

    // Calculate available storage space
    int availableSize = await Util.getAvailableStorageSpace();
    print('Device has $availableSize bytes available');

    if (requiredSize > availableSize - 10000000) {
      print('Device has insufficient storage');
      return false;
    }

    print('Device has sufficient storage');
    return true;
  }

  /// Iterates through the update queue and updates each media file that
  /// has been updated on the CMS.
  Future<void> processUpdateQueue() async {
    MediaFileBean mediaFileBeanTemp = MediaFileBean(tempAdapter);

    for (MediaFile mediaFile in _updateQueue) {
      // Request the meta data for the media file
      String jsonString = await NetworkUtil.requestDataString(
          Env.mediaDetailsUrl(server, mediaFile.id));

      // Update the database using the deserialized, updated, media file
      await mediaFileBeanTemp
          .update(mediaFileBeanTemp.fromMap(json.decode(jsonString)));

      print('Media file ${mediaFile.id} - updated in temp database');
    }
  }

  /// Iterates through the deletion queue and deletes both the file and
  /// the database record that points to the file.
  Future<void> processDeletionQueue() async {
    print('Deleting unneeded media files...');

    MediaFileBean mediaFileBean = MediaFileBean(adapter);

    for (MediaFile mediaFile in _deletionQueue) {
      await File(mediaFile.path).delete();
      await mediaFileBean.remove(mediaFile.id);
      print('Deleted media file ${mediaFile.id}');
    }
  }
}
