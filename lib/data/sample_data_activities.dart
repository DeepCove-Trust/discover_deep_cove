import 'dart:math';

import 'package:discover_deep_cove/data/sample_data_fact_file.dart';

/// represents a [track] and all the [activities] that belong to it
class Track {
  Track({
    this.id,
    this.name,
    this.activities,
  });

  ///the [id] of the track
  final int id;

  ///The name of the [track]
  final String name;

  ///The [activities] associated with the track
  final List<Activity> activities;
}

///represents the data for a single activity
abstract class Activity {
  Activity({
    this.id,
    this.trackId,
    this.activated,
    this.qrCode,
    this.location,
    this.title,
    this.image,
    this.description,
    this.task,
  });

  ///The [id] of the activity
  final int id;

  ///The [id] of the track the activity belongs to
  final int trackId;

  ///Is the [activity] unlocked? This allows the user to unlock a track
  ///a skip the activity if they want
  bool activated;

  ///The [String] that generates the qr code to unock thte [activity]
  final String qrCode;

  ///The location of the activity, the [Point] is converted to a [LatLng]
  ///and a marker is placed on the map
  final Point location;

  ///The title of the [activity]
  final String title;

  ///A [MediaFile] object the contains an image
  final MediaFile image;

  ///The description of the [activity]
  final String description;

  ///The task the user needs to complete
  final String task;

  bool isCompleted();

  @override
  String toString() => 'Activity($id : $title)';
}

///represents a picture select activity
class PictureSelectActivity extends Activity {
  PictureSelectActivity({
    int id,
    int trackId,
    bool activated,
    String qrCode,
    Point location,
    String title,
    MediaFile image,
    String description,
    String task,
    this.pictureOptions,
    this.selectedPicture,
  }) : super(
          id: id,
          trackId: trackId,
          activated: activated,
          qrCode: qrCode,
          location: location,
          title: title,
          image: image,
          description: description,
          task: task,
        );

  ///A [List] of images for the user to choose from
  List<MediaFile> pictureOptions;

  ///The [MediaFile] the user selected
  MediaFile selectedPicture;

  @override
  String toString() => 'PictureSelect';

  @override
  bool isCompleted() => selectedPicture != null;
}

///represents a picture tap activity
class PictureTapActivity extends Activity {
  PictureTapActivity({
    int id,
    int trackId,
    bool activated,
    String qrCode,
    Point location,
    String title,
    MediaFile image,
    String description,
    String task,
    this.userPoint,
  }) : super(
          id: id,
          trackId: trackId,
          activated: activated,
          qrCode: qrCode,
          location: location,
          title: title,
          image: image,
          description: description,
          task: task,
        );

  ///The [Point] of the image the user touched
  Point userPoint;

  @override
  String toString() => 'PictureTap';

  @override
  bool isCompleted() => userPoint != null;
}

///represents a count activity
class CountActivity extends Activity {
  CountActivity({
    int id,
    int trackId,
    bool activated,
    String qrCode,
    Point location,
    String title,
    MediaFile image,
    String description,
    String task,
    this.userCount,
  }) : super(
          id: id,
          trackId: trackId,
          activated: activated,
          qrCode: qrCode,
          location: location,
          title: title,
          image: image,
          description: description,
          task: task,
        );

  ///The [int] the user inputed
  int userCount;

  @override
  String toString() => 'Count';

  @override
  bool isCompleted() => userCount != null;
}

///represents a text answer activity
class TextAnswerActivity extends Activity {
  TextAnswerActivity({
    int id,
    int trackId,
    bool activated,
    String qrCode,
    Point location,
    String title,
    MediaFile image,
    String description,
    String task,
    this.userText,
  }) : super(
          id: id,
          trackId: trackId,
          activated: activated,
          qrCode: qrCode,
          location: location,
          title: title,
          image: image,
          description: description,
          task: task,
        );

  ///The [String] the user wrote
  String userText;

  @override
  String toString() => 'TextAnswer';

  @override
  bool isCompleted() => userText != null;
}

///represents a photography activity
class PhotographActivity extends Activity {
  PhotographActivity({
    int id,
    int trackId,
    bool activated,
    String qrCode,
    Point location,
    String title,
    MediaFile image,
    String description,
    String task,
    this.userPhoto,
  }) : super(
          id: id,
          trackId: trackId,
          activated: activated,
          qrCode: qrCode,
          location: location,
          title: title,
          image: image,
          description: description,
          task: task,
        );

  ///The [MediaFile] the user took
  MediaFile userPhoto;

  @override
  String toString() => 'Photograph';

  @override
  bool isCompleted() => userPhoto != null;
}

List<Track> tracks = [
  Track(id: 1, name: 'Brasells Point', activities: brasellsPointActivities),
  Track(id: 2, name: 'Helena Falls', activities: helenaFallsActivities),
  Track(id: 3, name: 'Hanging Valley', activities: hangingValleyActivities),
];

List<Activity> brasellsPointActivities = [
  PictureSelectActivity(
    id: 1,
    trackId: 1,
    activated: false,
    qrCode: "ceqGf60RaTPc",
    location: Point(-45.463604, 167.154470),
    title: "Fallen Leaves",
    image: null,
    description: "Take a look at the leave that have fallen in this area."
        " You will probably see many different varieties",
    task: "Which kind do you see the most of?",
    pictureOptions: [
      MediaFile(
        1,
        MediaFileType.jpg,
        "Mountain Beech",
        "assets/images/activities/pictureSelect/mountainBeech.jpg",
      ),
      MediaFile(
        1,
        MediaFileType.jpg,
        "Rimu",
        "assets/images/activities/pictureSelect/rimu.jpg",
      ),
      MediaFile(
        1,
        MediaFileType.jpg,
        "Totara",
        "assets/images/activities/pictureSelect/totara.jpg",
      ),
    ],
    selectedPicture: null,
  ),
  PictureTapActivity(
    id: 2,
    trackId: 1,
    activated: false,
    qrCode: "APVEBqGjpAqt",
    location: Point(-45.463431, 167.154813),
    title: "Electric Touch",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "powerStation",
      "assets/images/activities/pictureTap/powerStation.jpg",
    ),
    description:
        "The Manapōuri power station uses water to spin turbines this generates electricity",
    task: "Tap the part of the power station that transports electricity to "
        "wherever it is needed",
    userPoint: null,
  ),
  CountActivity(
    id: 3,
    trackId: 1,
    activated: false,
    qrCode: "MK33dkgesZAD",
    location: Point(-45.463619, 167.155961),
    title: "The Lancewood",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "powerStation",
      "assets/images/activities/count/lancewood.jpg",
    ),
    description:
        "The lancewood grows very narrow, spiky leaves when it is young."
        " When it grows older, the leaves look very different!",
    task: "How many lancewood trees can you see from this post?",
    userCount: null,
  ),
  TextAnswerActivity(
    id: 4,
    trackId: 1,
    activated: false,
    qrCode: "6FwwEniq6dwI",
    location: Point(-45.462799, 167.156884),
    title: "Stumped",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "powerStation",
      "assets/images/activities/textAnswer/stump.jpg",
    ),
    description:
        "There used to be a large Rimu tree just ahead and to the left."
        " A few years ago it had to be cut down.",
    task: "See if you can estimate the age of the tree, how can you tell?\n\n"
        " Bonus task: can you think on any reason this tree may have been cut down?",
    userText: null,
  ),
  PhotographActivity(
    id: 5,
    trackId: 1,
    activated: false,
    qrCode: "bDn7OkP26Slu",
    location: Point(-45.462791, 167.157560),
    title: "Tallest Tree",
    image: null,
    description: "There is a large Rimu tree just to the right of the of this sign. "
    "It is one of the tallest trees in Deep Cove!",
    task: "Can you see it?",
    userPhoto: null,
  ),
  CountActivity(
    id: 6,
    trackId: 1,
    activated: false,
    qrCode: "tmw8piSB3rBg",
    location: Point(-45.463905, 167.157861),
    title: "How many boats",
    image: null,
    description: "There are several boats on the harbour.",
    task: "How many can you see?",
    userCount: null,
  ),
];

List<Activity> helenaFallsActivities = [
  PictureSelectActivity(
    id: 1,
    trackId: 2,
    activated: false,
    qrCode: "U2N2CZ2ZYNV9",
    location: Point(-45.470442, 167.165120),
    title: "Fallen Leaves",
    image: null,
    description: "Take a look at the leave that have fallen in this area."
        " You will probably see many different varieties",
    task: "Which kind do you see the most of?",
    pictureOptions: [
      MediaFile(
        1,
        MediaFileType.jpg,
        "MountainBeech",
        "assets/images/activities/pictureSelect/mountainBeech.jpg",
      ),
      MediaFile(
        1,
        MediaFileType.jpg,
        "Rimu",
        "assets/images/activities/pictureSelect/rimu.jpg",
      ),
      MediaFile(
        1,
        MediaFileType.jpg,
        "Totara",
        "assets/images/activities/pictureSelect/totara.jpg",
      ),
    ],
    selectedPicture: null,
  ),
  PictureTapActivity(
    id: 2,
    trackId: 2,
    activated: false,
    qrCode: "VIWEnqGxO0N0",
    location: Point(-45.468087, 167.166161),
    title: "Electric Touch",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "powerStation",
      "assets/images/activities/pictureTap/powerStation.jpg",
    ),
    description:
        "The Manapōuri power station uses water to spin turbines this generates electricity",
    task: "Tap the part of the power station that transports electricity to "
        "wherever it is needed",
    userPoint: null,
  ),
  CountActivity(
    id: 3,
    trackId: 2,
    activated: false,
    qrCode: "f6GV3ob0YI6m",
    location: Point(-45.465164, 167.168961),
    title: "The Lancewood",
    image: null,
    description:
        "The lancewood grows very narrow, spiky leaves when it is young."
        " When it grows older, the leaves look very different!",
    task: "How many lancewood trees can you see from this post?",
    userCount: null,
  ),
  TextAnswerActivity(
    id: 4,
    trackId: 2,
    activated: false,
    qrCode: "mFWxdP5BC6Q4",
    location: Point(-45.463990, 167.166708),
    title: "Stumped",
    image: null,
    description:
        "There used to be a large Rimu tree just ahead and to the left."
        " A few years ago it had to be cut down.",
    task: "See if you can estimate the age of the tree, how can you tell?"
        " Bonus task can you think on any reason this tree may have been cut down?",
    userText: null,
  ),
  PhotographActivity(
    id: 5,
    trackId: 2,
    activated: false,
    qrCode: "hOlTAtKyjypj",
    location: Point(-45.471183, 167.163318),
    title: "Tallest Tree",
    image: null,
    description: "Can you spot the tallest tree at Deep Cove.",
    task: "Snap a photo of your guess.",
    userPhoto: null,
  ),
];

List<Activity> hangingValleyActivities = [
  PictureSelectActivity(
    id: 1,
    trackId: 3,
    activated: false,
    qrCode: "cXcPLTR9oChz",
    location: Point(-45.463966, 167.153308),
    title: "Fallen Leaves",
    image: null,
    description: "Take a look at the leave that have fallen in this area."
        " You will probably see many different varieties",
    task: "Which kind do you see the most of?",
    pictureOptions: [
      MediaFile(
        1,
        MediaFileType.jpg,
        "MountainBeech",
        "assets/images/activities/pictureSelect/mountainBeech.jpg",
      ),
      MediaFile(
        1,
        MediaFileType.jpg,
        "Rimu",
        "assets/images/activities/pictureSelect/rimu.jpg",
      ),
      MediaFile(
        1,
        MediaFileType.jpg,
        "Totara",
        "assets/images/activities/pictureSelect/totara.jpg",
      ),
    ],
    selectedPicture: null,
  ),
  PictureTapActivity(
    id: 2,
    trackId: 3,
    activated: false,
    qrCode: "ftJ1qx8sujy8",
    location: Point(-45.465150, 167.150989),
    title: "Electric Touch",
    image: MediaFile(
      1,
      MediaFileType.jpg,
      "powerStation",
      "assets/images/activities/pictureTap/powerStation.jpg",
    ),
    description:
        "The Manapōuri power station uses water to spin turbines this generates electricity",
    task: "Tap the part of the power station that transports electricity to "
        "wherever it is needed",
    userPoint: null,
  ),
  CountActivity(
    id: 3,
    trackId: 3,
    activated: false,
    qrCode: "pfI34ih8xqrR",
    location: Point(-45.464563, 167.152951),
    title: "The Lancewood",
    image: null,
    description:
        "The lancewood grows very narrow, spiky leaves when it is young."
        " When it grows older, the leaves look very different!",
    task: "How many lancewood trees can you see from this post?",
    userCount: null,
  ),
  TextAnswerActivity(
    id: 4,
    trackId: 3,
    activated: false,
    qrCode: "42DkYyc5ERjW",
    location: Point(-45.474337, 167.146290),
    title: "Stumped",
    image: null,
    description:
        "There used to be a large Rimu tree just ahead and to the left."
        " A few years ago it had to be cut down.",
    task: "See if you can estimate the age of the tree, how can you tell?"
        " Bonus task can you think on any reason this tree may have been cut down?",
    userText: null,
  ),
  PhotographActivity(
    id: 5,
    trackId: 3,
    activated: false,
    qrCode: "j7FtiUOBuita",
    location: Point(-45.476354, 167.134145),
    title: "Tallest Tree",
    image: null,
    description: "Can you spot the tallest tree at Deep Cove.",
    task: "Snap a photo of your guess.",
    userPhoto: null,
  ),
];
