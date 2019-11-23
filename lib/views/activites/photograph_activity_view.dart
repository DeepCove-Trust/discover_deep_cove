import 'dart:async';
import 'dart:io';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/data/models/user_photo.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/image_handler.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/activities/activity_app_bar.dart';
import 'package:discover_deep_cove/widgets/activities/activity_pass_save_bar.dart';
import 'package:discover_deep_cove/widgets/activities/editAnswer.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/custom_fab.dart';
import 'package:discover_deep_cove/widgets/misc/custom_vertical_divider.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';

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
      height: Screen.width(context,
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

  Widget _buildImageSection() {
    return FutureBuilder(
        future: widget.isReview ? _getSavedPhoto() : _getPreview(),
        builder: (context, snapshot) {
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
    return Scaffold(
      appBar: ActivityAppBar(
        text: widget.activity.title,
        onTap: widget.activity.factFileId != null
            ? () => displayFactFile(widget.activity.factFileId)
            : null,
      ),
      body: buildContent(),
      bottomNavigationBar: widget.isReview
          ? BottomBackButton()
          : ActivityPassSaveBar(
              onTapSave: _image != null ? () => saveAnswer() : null,
              onTapPass: () => cancelAnswer(),
            ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: widget.isReview
          ? Container()
          : Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 6,
                ),
                child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(context);
              },
              child: const Icon( FontAwesomeIcons.camera),
            ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  

  buildGraphic() {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: Screen.isTablet(context) ? 20 : 10),
      child: widget.activity.image == null
          ? null
          : Container(
              width: Screen.width(context,
                  percentage: Screen.isLandscape(context) ? 35 : 85),
              height: Screen.width(context,
                  percentage: Screen.isLandscape(context) ? 35 : 85),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(
                    File(
                      Env.getResourcePath(widget.activity.image.path),
                    ),
                  ),
                ),
              ),
              child: Container()),
    );
  }

  buildContent() {
    return (Screen.isTablet(context) && Screen.isLandscape(context))
        ? Row(
            children: [
              Expanded(child: getTopHalf()),
              CustomVerticalDivider(),
              Expanded(child: getBottomHalfLandscape())
            ],
          )
        : Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [getTopHalf(), getBottomHalfPortrait()],
              ),
            ),
          );
  }

  getTopHalf() {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildGraphic(),
            Padding(
              padding: EdgeInsets.all(20),
              child: BodyText(
                widget.activity.description,
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 30 : null,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SubHeading(
                widget.activity.task,
                align: TextAlign.left,
                size: Screen.isTablet(context) ? 30 : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getBottomHalfLandscape() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 24, 8, 8),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: _buildImageSection(),
                    ),
                    widget.isReview ? EditAnswer() : Container()
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getBottomHalfPortrait() {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 24, 8, 8),
        child: Column(
          children: <Widget>[
            BodyText('Your answer:'),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: _buildImageSection(),
            ),
            widget.isReview ? EditAnswer() : Container()
          ],
        ),
      ),
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
      String filename = Util.getAntiCollisionName(
        widget.activity.title,
        ".jpg",
      );

      if (await Util.savePhotosToGallery(context))
        await GallerySaver.saveImage(_image.path);

      // Save the image to the users photos directory, and delete temp image
      ImageHandler.saveImage(
          tempImage: _image, directory: directory, name: filename);

      // Add a database record for the new image
      UserPhoto image = UserPhoto.create(
        path: 'user_photos/$filename',
      );
      var id = await UserPhotoBean.of(context).insert(image);

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

  displayFactFile(int factFileId) async {
    Navigator.of(context).pushNamed(
      '/factFileDetails',
      arguments: factFileId,
    );
  }
}
