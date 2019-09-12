import 'dart:async';
import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/image_handler.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PhotographActivityView extends StatefulWidget {
  final Activity activity;
  final bool isReview;

  ///Takes in a [PhotographActivity] and a [bool] and displays the view based
  ///on the value of the [bool], you can complete the activity if the [bool] is false
  ///and review it if the [bool] is true.
  PhotographActivityView({this.activity, this.isReview});

  @override
  _PhotographActivityViewState createState() => _PhotographActivityViewState();
}

class _PhotographActivityViewState extends State<PhotographActivityView> {
  File _image;

  void _onImageButtonPressed(BuildContext context) async {
    try {
      File _pickedImage = await ImageHandler.captureImage(context: context);

      setState(() => _image = _pickedImage);
    } catch (ex, stacktrace) {
      print("Exception thrown: " + ex.toString());
      print(stacktrace.toString());
    }
  }

  Future<Widget> _getSavedPhoto() async {
    String filepath = widget.activity.userPhoto?.path;
    if (filepath == null) {
      print('Error loading stored image.');
      return BodyText(
        'There was an error loading your image...',
        size: Screen.isTablet(context) ? 30 : null,
      );
    }
    await precacheImage(
        FileImage(File(Env.getResourcePath(filepath))), context);

    return Image.file(File(Env.getResourcePath(filepath)));
  }

  Future<Widget> _getPreview() async {
    if (_image != null) {
      await precacheImage(FileImage(_image), context);
      return Image.file(_image);
    } else {
      return _getNoPhotoWidget();
    }
  }

  Widget _getNoPhotoWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(border: Border.all(color: Colors.white30)),
      width: Screen.width(context,
          percentage: Screen.isPortrait(context) ? 90 : 45),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt,
              size: Screen.isSmall(context) ? 100 : 150, color: Colors.white30),
          SizedBox(
            height: 10,
          ),
          BodyText(
            'Take a photo to begin...',
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ],
      ),
    );
  }

  Widget _getCenterChild() {
    print('getCenterChild');
    return FutureBuilder(
        future: widget.isReview ? _getSavedPhoto() : _getPreview(),
        builder: (context, snapshot) {
          print(snapshot.connectionState.toString());
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 12),
                BodyText(
                  'Loading image...',
                  size: Screen.isTablet(context) ? 30 : null,
                ),
              ],
            );
          } else if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = Env.getResourcePath(widget.activity.userPhoto?.path);

    print("Image path:");
    print(imagePath);
    print("Picture " +
        (File(imagePath).existsSync() ? "exists" : "does not exist"));

    return Scaffold(
      appBar: ActivityAppBar(
          widget.activity.title,
          widget.activity.factFileId != null
              ? () => displayFactFile(widget.activity.factFileId)
              : null,
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: BodyText(widget.activity.description),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: BodyText(widget.activity.task),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Divider(color: Color(0xFF777777)),
          ),
          Expanded(
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: _getCenterChild(),
            )),
          )
        ],
      ),
      bottomNavigationBar: widget.isReview
          ? BottomBackButton()
          : ActivityPassSaveBar(
              onTapSave: _image != null ? () => saveAnswer() : null,
              onTapPass: () => cancelAnswer(),
            ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: widget.isReview
          ? Container()
          : Align(alignment: Alignment.bottomCenter, child:Padding(
              padding: EdgeInsets.only(
                bottom: 8,
              ),
              child: CustomFab(
                icon: FontAwesomeIcons.camera,
                text: "I see it!",
                onPressed: () {
                  _onImageButtonPressed(context);
                },
              ),
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  buildContent() {
    return Center(
      child: (Screen.isTablet(context) && Screen.isLandscape(context))
          ? GridView.count(
              crossAxisCount: 2,
              children: [
                getTopHalf(),
                getBottomHalf(),
              ],
            )
          : Column(
              children: [
                getTopHalf(),
                Flexible(
                  child: getBottomHalf(),
                ),
              ],
            ),
    );
  }

  getTopHalf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            Screen.width(context, percentage: 5),
            Screen.height(context, percentage: 2.5),
            Screen.width(context, percentage: 5),
            Screen.height(context, percentage: 2.5),
          ),
          child: BodyText(
            widget.activity.description,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            Screen.width(context, percentage: 5),
            0,
            Screen.width(context, percentage: 5),
            Screen.height(context, percentage: 2.5),
          ),
          child: BodyText(
            widget.activity.task,
            size: Screen.isTablet(context) ? 30 : null,
          ),
        ),
      ],
    );
  }

  getBottomHalf() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: _getCenterChild(),
            ),
          ),
        ),
      ],
    );
  }

  void cancelAnswer() async {
    // We need to delete the temp picture if one was taken
    if (_image != null && await _image.exists()) {
      await _image.delete();
    }
    Navigator.pop(context);
  }

  void saveAnswer() async {
    // Generate path to store photo at - use activity title in the file name
    // along with a collision resistant suffix.
    try {
      // Determine directory and filename to store new image
      Directory directory = Directory(Env.getResourcePath('user_photos'));
      String filename =
          Util.getAntiCollisionName(widget.activity.title, MediaFileType.jpg);

      // Save the image to the users photos directory, and delete temp image
      ImageHandler.saveImage(
          tempImage: _image, directory: directory, name: filename);

      // Add a database record for the new image
      MediaFile image = MediaFile.create(
        name: filename,
        path: 'user_photos/$filename',
        fileType: MediaFileType.jpg.index,
      );
      var id = await MediaFileBean.of(context).insert(image);

      // Update the activity with the new user image
      widget.activity.userPhotoId = id;
      widget.activity.userPhoto = image;
      await ActivityBean.of(context).update(widget.activity);

      // Return to the map
      Navigator.of(context).pop();
    } catch (ex, stacktrace) {
      print("Error saving photo: " + ex.toString());
      print(stacktrace.toString());
    }
  }

  displayFactFile(int factFileId) {

    Navigator.of(context).pushNamed(
      '/factFileDetails',
      arguments: factFileId,
    );
  }
}
