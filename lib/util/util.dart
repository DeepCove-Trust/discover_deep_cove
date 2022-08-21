import 'dart:io' show File, Directory;

import 'package:archive/archive.dart' show ZipDecoder, Archive, ArchiveFile;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show required;
import 'package:path/path.dart' show join;
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:toast/toast.dart';

import '../data/models/config.dart';
import '../env.dart';

/// Container class for general helper functions.
class Util {
  /// Extract the supplied file [zip] to the supplied directory [dir]
  ///
  /// Returns true if successful.
  static Future<bool> extractZip({@required File zip, @required Directory dir}) async {
    try {
      Archive archive = ZipDecoder().decodeBytes(await zip.readAsBytes());
      // note that [file] may be file OR directory
      // TODO: Look into whether this should be async
      for (ArchiveFile file in archive) {
        if (file.isFile) {
          File(join(dir.path, file.name))
            ..createSync(recursive: true)
            ..writeAsBytesSync(file.content);
        } else {
          // is a directory
          Directory(join(dir.path, file.name)).create(recursive: true);
        }
      }
      return true;
    } catch (ex) {
      debugPrint('Could not extract file:');
      debugPrint(ex.toString());
      return false;
    }
  }

  static void showToast(BuildContext context, String text) {
    Toast.show(
      text,
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
      backgroundColor: Theme.of(context).primaryColor,
      textColor: Colors.black,
    );
  }

  /// Generates a file name by adding a time-based string to the end,
  /// and adding the correct file extension based on supplied type.
  static String getAntiCollisionName(String name, String extension) {
    String suffix = DateTime.now().millisecondsSinceEpoch.toString();
    return name.replaceAll(' ', '_') + '_' + suffix + extension;
  }

  /// Returns the amount of free storage space available to the app, in bytes.
  /// Returns -1 if unable to calculate.
  static Future<int> getAvailableStorageSpace() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {
      if (Env.debugMessages) debugPrint('Warning: Unable to determine bytes available!');
      return -1;
    }

    if (Env.debugMessages) debugPrint('Device has ${storageInfo[0].availableBytes} bytes available');

    return storageInfo[0].availableBytes;
  }

  static String bytesToMBString(int bytes) {
    return '${(bytes / 1000000).toStringAsFixed(1)}MB';
  }

  static Future<bool> savePhotosToGallery(BuildContext context) async {
    Config config = await ConfigBean.of(context).find(1);
    return config.savePhotosToGallery;
  }
}
