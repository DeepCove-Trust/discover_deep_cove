import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';

import '../../data/models/media_file.dart';
import '../../env.dart';
import '../exeptions.dart';
import '../network_util.dart';
import '../permissions.dart';
import '../util.dart';
import 'sync_manager.dart';

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
  final CmsServerLocation server;
  final SqfliteAdapter tempAdapter, adapter;
  final BuildContext context;
  void Function(SyncState, int, {int upTo, int outOf, int totalSize}) onProgress;

  MediaSync(
      {@required this.adapter,
      @required this.tempAdapter,
      @required this.server,
      @required this.context,
      @required this.onProgress})
      : mediaFileBeanMain = MediaFileBean(adapter),
        mediaFileBeanTemp = MediaFileBean(tempAdapter);

  MediaFileBean mediaFileBeanMain, mediaFileBeanTemp;

  int upTo, outOf, totalSize;

  Queue<MediaData> _downloadQueue;
  Queue<MediaFile> _deletionQueue, _updateQueue;

  /// Populate the download and deletion queues for later use
  Future<void> buildQueues() async {
    // Retrieve list of locally existing media files
    List<MediaFile> localMediaFiles = await mediaFileBeanTemp.getAll();

    // Retrieve list of required media files from server, as MediaData objects
    String jsonString = await NetworkUtil.requestDataString(Env.mediaListUrl(server, context));
    List<dynamic> jsonData = json.decode(jsonString);
    List<MediaData> remoteMedia = jsonData.map((i) => MediaData.fromJson(i)).toList();

    // CALCULATE DOWNLOAD QUEUE
    // All remote media that do not exist locally
    _downloadQueue = Queue.from(remoteMedia.where((e) => !localMediaFiles.any((f) => f.id == e.id)));

    // CALCULATE UPDATE QUEUE
    // Any local media that exist remotely, and the remote timestamp is after
    // the local timestamp
    _updateQueue = Queue.from(
        localMediaFiles.where((e) => remoteMedia.any((f) => f.id == e.id && f.updatedAt.isAfter(e.updatedAt))));

    // CALCULATE DELETION QUEUE
    // Any local media that don't exist in the remote media list
    _deletionQueue = Queue.from(localMediaFiles.where((e) => !remoteMedia.any((f) => f.id == e.id)));
  }

  /// Iterates through the download queue and downloads each file asynchronously,
  /// adding database records and saving to disk as files are received.
  /// Performs a free-storage check prior to downloading.
  Future<void> processDownloadQueue() async {
    upTo = 0; // file that we are up to downloading
    outOf = _downloadQueue.length; // out of how many
    totalSize = _downloadQueue.fold<int>(0, (v, n) => v + n.size);

    if (!(await sufficientStorageAvailable(totalSize))) {
      throw InsufficientStorageException(message: 'Insufficient storage on device.');
    }

    // Update progress for user
    onProgress(SyncState.mediaDownload, getPercentage(), upTo: upTo, outOf: outOf, totalSize: totalSize);

    await Permissions.ensurePermission(PermissionGroup.storage);

    // This list will contain all of our download jobs if downloading
    // asynchronously.
    List<Future<void>> futures = <Future<void>>[];

    while (_downloadQueue.isNotEmpty) {
      MediaData mediaData = _downloadQueue.removeFirst();

      if (Env.asyncDownload) {
        futures.add(downloadMediaFile(mediaData).catchError((ex, stacktrace) {
          debugPrint(ex);
          debugPrint(stacktrace);
          throw FailedDownloadException(message: 'One or more file downloads failed.');
        }));
      } else {
        await downloadMediaFile(mediaData);
      }
    }

    // Wait for all download jobs to complete
    await Future.wait(futures, cleanUp: (_) => debugPrint('error'));

    if (Env.debugMessages) debugPrint('Download queue has been successfully processed.');
  }

  /// Downloads a file, and creates database records for it. An exception
  /// thrown from this method indicates that the download failed.
  Future<void> downloadMediaFile(MediaData mediaData) async {
    // Retrieve mediaFile object from server, and deserialize
    String jsonString = await NetworkUtil.requestDataString(Env.mediaDetailsUrl(server, mediaData.id, context));
    MediaFile mediaFile = mediaFileBeanMain.fromMap(json.decode(jsonString));

    // Download file from server, to memory. Download larger images if device
    // is a tablet.
    String absPath = Env.getResourcePath(mediaFile.category);
    String filename = mediaData.filename;
    Http.Response response = await Http.get(Env.mediaDownloadUrl(server, filename, context));

    // Assign path to mediaFile object
    mediaFile.path = join(mediaFile.category, mediaData.filename);

    // Add database records
    await insertMediaRecord(mediaFile);

    // Save file to directory
    try {
      // Todo: Monitor whether this try-catch works in async
      await NetworkUtil.httpResponseToFile(response: response, absPath: absPath, filename: filename);
    } catch (ex, stacktrace) {
      // Exception while saving file, remove database records
      debugPrint(ex);
      debugPrint(stacktrace.toString());
      await removeMediaRecord(mediaFile);
      throw FailedDownloadException(message: 'Download failed for file ID {${mediaFile.id}');
    }

    // Increment the 'upTo' counter and report progress.
    upTo++;
    onProgress(SyncState.mediaDownload, getPercentage(), upTo: upTo, outOf: outOf, totalSize: totalSize);

    if (Env.debugMessages) debugPrint('Downloaded media file ${mediaFile.id} (${mediaFile.name})');
  }

  /// Adds supplied MediaFile record to both temp and main databases
  Future<void> insertMediaRecord(MediaFile mediaFile) async {
    await mediaFileBeanMain.insert(mediaFile);
    await mediaFileBeanTemp.insert(mediaFile);
  }

  /// Removes supplied MediaFile record from both temp and main databases
  Future<void> removeMediaRecord(MediaFile mediaFile) async {
    await mediaFileBeanMain.remove(mediaFile.id);
    await mediaFileBeanTemp.remove(mediaFile.id);
  }

  /// Returns true if the device has enough available space to download
  /// required media files (with > 10MB spare)
  Future<bool> sufficientStorageAvailable(int requiredSize) async {
    if (Env.debugMessages) debugPrint('Calculating storage availablity...');

    if (Env.debugMessages) debugPrint('Download requires $requiredSize bytes');

    // Calculate available storage space
    int availableSize = await Util.getAvailableStorageSpace();

    // If unable to determine available space, proceed anyway // todo: improve
    if (availableSize == -1) {
      return true;
    }

    if (Env.debugMessages) debugPrint('Device has $availableSize bytes available');

    if (requiredSize > availableSize - 10000000) {
      if (Env.debugMessages) debugPrint('Device has insufficient storage');
      return false;
    }

    if (Env.debugMessages) debugPrint('Device has sufficient storage');
    return true;
  }

  /// Iterates through the update queue and updates each media file that
  /// has been updated on the CMS.
  Future<void> processUpdateQueue() async {
    for (MediaFile mediaFile in _updateQueue) {
      // Request the meta data for the media file
      String jsonString = await NetworkUtil.requestDataString(Env.mediaDetailsUrl(server, mediaFile.id, context));

      // Update the database using the deserialized, updated, media file
      await mediaFileBeanTemp.update(mediaFileBeanTemp.fromMap(json.decode(jsonString)), onlyNonNull: true);

      if (Env.debugMessages) debugPrint('Media file ${mediaFile.id} (${mediaFile.name}) - updated');
    }
  }

  /// Iterates through the deletion queue and deletes both the file and
  /// the database record that points to the file.
  Future<void> processDeletionQueue() async {
    if (Env.debugMessages) debugPrint('Deleting unneeded media files...');
    for (MediaFile mediaFile in _deletionQueue) {
      await File(Env.getResourcePath(mediaFile.path)).delete().catchError((_) {
        if (Env.debugMessages) debugPrint('Error deleting ${mediaFile.name}');
      });
      await mediaFileBeanMain.remove(mediaFile.id);
      if (Env.debugMessages) debugPrint('Deleted media file ${mediaFile.id} (${mediaFile.name})');
    }
  }

  /// Gets the correct completion percentage for the download process.
  /// (the media download queue begins at 20 and ends at 80)
  int getPercentage() {
    return outOf > 0 ? 60 * upTo ~/ outOf + 20 : 0; // avoid divide by zero
  }
}
