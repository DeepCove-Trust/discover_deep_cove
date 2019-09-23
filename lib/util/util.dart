import 'dart:io' show File, Directory;

import 'package:archive/archive.dart' show ZipDecoder, Archive, ArchiveFile;
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Response;
import 'package:meta/meta.dart' show required;
import 'package:path/path.dart' show join;
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:toast/toast.dart';

/// Container class for general helper functions.
class Util {

  /// Extract the supplied file [zip] to the supplied directory [dir]
  ///
  /// Returns true if successful.
  static Future<bool> extractZip(
      {@required File zip, @required Directory dir}) async {
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
          Directory(join(dir.path, file.name))..create(recursive: true);
        }
      }
      return true;
    } catch (ex) {
      print('Could not extract file:');
      print(ex.toString());
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
    return name.replaceAll(' ', '_') + '_' + suffix + '.' + extension;
  }

  /// Returns the amount of free storage space available to the app, in bytes.
  /// Returns -1 if unable to calculate.
  static Future<int> getAvailableStorageSpace() async {
    List<StorageInfo> _storageInfo;
    try {
      _storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException { return -1; }

    print('Device has ${_storageInfo[0].availableBytes} bytes available');

    return _storageInfo[0].availableBytes;

  }
}
