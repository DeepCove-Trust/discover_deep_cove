import 'dart:io';

import 'package:path/path.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageHandler {
  /// Picks an image from specified source, then returns the file pointing
  /// to the image.
  static Future<File> captureImage(
      {@required BuildContext context,
      ImageSource source = ImageSource.camera,
      double maxWidth = 2048,
      double maxHeight,
      int imageQuality}) async {
    try {
      return await ImagePicker.pickImage(
          source: ImageSource.camera,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality);
    } catch (ex, stacktrace) {
      print("Error capturing image: ${ex.toString()}");
      print(stacktrace.toString());
      Util.showToast(context, 'Something went wrong. Please try again later.');
      return null;
    }
  }

  /// Saves the given image to the given directory, using the given name.
  static Future<bool> saveImage({
    @required File tempImage,
    @required Directory directory,
    @required String name,
  }) async {

    try {
      // Ensure the user photos directory exists
      await directory.create(recursive: true);

      // Get absolute path to save image as
      String filepath = join(directory.path, name);

      // Copy the temporary image to the new location
      await File(filepath).writeAsBytes(await tempImage.readAsBytes());
      print('Image saved to $filepath');

      await tempImage.delete();
      print('Temporary image deleted');

      return true;
    }
    catch(ex, stacktrace){
      print('Error saving image: ${ex.toString()}');
      print(stacktrace.toString());
      return false;
    }
  }
}
