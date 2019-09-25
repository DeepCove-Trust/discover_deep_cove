import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:discover_deep_cove/util/network_util.dart';
import 'package:path/path.dart';
import 'package:discover_deep_cove/data/db.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/activity_image.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/user_photo.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:flutter/cupertino.dart';

class ActivityData {
  int id;
  DateTime updatedAt;

  ActivityData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    updatedAt = DateTime.parse(map['updated_at']);
  }
}

class TrackSync {
  final CmsServerLocation server;
  final TrackBean trackBean;
  final ActivityBean activityBean;
  final ActivityImageBean activityImageBean;
  final UserPhotoBean userPhotoBean;

  List<int> _deletionQueue = List<int>();

  TrackSync(SqfliteAdapter adapter, {@required this.server})
      : trackBean = TrackBean(adapter),
        activityBean = ActivityBean(adapter),
        activityImageBean = ActivityImageBean(adapter),
        userPhotoBean = UserPhotoBean(adapter);

  Future<void> sync() async {
    // Sync tracks
    await _syncTracks();

    // Sync all activities
    await _syncActivities();
  }

  Future<void> _syncTracks() async {
    // Get local tracks
    List<Track> localTracks = await trackBean.getAll();

    // Get tracks active on the server
    String jsonString =
        await NetworkUtil.requestDataString(Env.tracksListUrl(server));
    List<dynamic> decodedJson = json.decode(jsonString);
    List<Track> serverTracks =
        decodedJson.map((map) => trackBean.fromMap(map)).toList();

    Set<int> idSet = localTracks
        .map((t) => t.id)
        .toSet()
        .union(serverTracks.map((t) => t.id).toSet());

    for (int id in idSet) {
      if (!localTracks.any((t) => t.id == id)) {
        // Add track if not on local
        trackBean.insert(serverTracks.firstWhere((t) => t.id == id));
        print('Track $id added');
      } else if (!serverTracks.any((t) => t.id == id)) {
        // Delete the track (and all activities) if not on server
        await _deleteTrack(id);
      } else {
        // Update the existing, just in case name has change
        await trackBean.update(serverTracks.firstWhere((t) => t.id == id));
        print('Track $id updated/unchanged');
      }
    }
  }

  Future<void> _deleteActivitiesFor(int trackId) async {
    List<Activity> activities = await activityBean.findByTrack(trackId);

    for (Activity activity in activities) {
      await _deleteActivity(activity.id);
    }
  }

  Future<void> _deleteActivity(int id) async {
    Activity activity = await activityBean.find(id);

    // Delete the activity image records for the activity
    await _deleteActivityImagesFor(id);

    // Delete the activity
    await activityBean.remove(id);

    // Add the user photo to the deletion queue (we don't want to delete now,
    // in case the update process fails and we need to revert.
    _deletionQueue.add(activity.userPhotoId);

    print('Deleted activity {$id} (${activity.title})');
  }

  /// Iterates through each user photo ID in the deletion queue, deleting the
  /// file and removing the associated record from the user_photos table.
  Future<void> processDeletionQueue(SqfliteAdapter mainAdapter) async {
    for (int id in _deletionQueue) {
      UserPhoto photo = await userPhotoBean.find(id);
      // Delete the file itself
      await File(Env.getResourcePath(join('user_photos', photo.path)))
          .delete()
          .catchError((e) => print(
              'Error attempting to delete user photo: \n ${e.toString()}'));
      // Then delete the database record in the main database
      await UserPhotoBean(mainAdapter).remove(id);
    }
  }

  Future<void> _syncActivities() async {
    // Get local activities
    List<Activity> localActivities = await activityBean.getAll();

    // Get server activities
    List<ActivityData> serverActivities = await _getActivitiesSummary();

    Set<int> idSet = localActivities
        .map((t) => t.id)
        .toSet()
        .union(serverActivities.map((t) => t.id).toSet());

    for (int id in idSet) {
      if (!localActivities.any((t) => t.id == id)) {
        // Download activity if not on local
        await _downloadActivity(id);
        print('Activity $id downloaded');
      } else if (!serverActivities.any((t) => t.id == id)) {
        // Delete the track (and all activities) if not on server
        await _deleteActivity(id);
        print('Activity $id deleted');
      } else if (localActivities
          .firstWhere((a) => a.id == id)
          .updatedAt
          .isAfter(serverActivities.firstWhere((a) => a.id == id).updatedAt)) {
        // Update the existing, just in case name has change
        await _updateActivity(id);
        print('Activity $id updated');
      }
    }
  }

  Future<void> _updateActivity(int id) async {
    await _deleteActivity(id);
    await _downloadActivity(id);
  }

  Future<List<ActivityData>> _getActivitiesSummary() async {
    // Get json string from server
    String jsonString =
        await NetworkUtil.requestDataString(Env.activitiesListUrl(server));
    List<dynamic> data = json.decode(jsonString);
    return data.map((map) => ActivityData.fromMap(map)).toList();
  }

  Future<void> _downloadActivity(int id) async {
    // Get the json string from the server
    String jsonString =
        await NetworkUtil.requestDataString(Env.activityDetailsUrl(server, id));
    Map<String, dynamic> data = json.decode(jsonString);

    // Deserialize the activity
    Activity activity = activityBean.fromMap(data);
    activity.informationActivityUnlocked = false;

    // Deserialize the images list
    List<dynamic> imagesData = data['activity_images'];
    List<int> imageIds = imagesData.cast<int>().toList();

    // Save activity to database
    await activityBean.insert(activity);

    // Save activity image records
    _createActivityImagesFor(id, imageIds);
  }

  Future<void> _createActivityImagesFor(
      int activityId, List<int> imageIds) async {
    if (imageIds.length == 0) return;

    List<ActivityImage> activityImages = imageIds
        .map((i) => ActivityImage.make(imageId: i, activityId: activityId))
        .toList();

    await activityImageBean.insertMany(activityImages);
  }

  Future<void> _deleteTrack(int id) async {
    // Delete all activities for track
    await _deleteActivitiesFor(id);

    // Delete the track itself
    await trackBean.remove(id);

    print('Track {$id} deleted');
  }

  Future<void> _deleteActivityImagesFor(int activityId) async {
    await activityImageBean.removeByActivity(activityId);
  }
}
