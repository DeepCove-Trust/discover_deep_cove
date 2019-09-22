import 'dart:io' show File, Directory;
import 'package:http/http.dart' as Http;

import 'package:archive/archive.dart' show ZipDecoder, Archive, ArchiveFile;
import 'package:dart_ping/dart_ping.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;
import 'package:meta/meta.dart' show required;
import 'package:path/path.dart' show join;
import 'package:toast/toast.dart';

/// Container class for general helper functions.
class Util {
  /// Stores the body of the [http.Response] as a file, using the specified
  /// [absPath] and [fileName].
  ///
  /// Will create directories that do not exist.
  static Future<File> httpResponseToFile(
      {@required Response response,
      @required String absPath,
      @required String fileName}) async {
    // TODO: Check for write permission here?

    File file = File(join(absPath, fileName));
    await file.create(recursive: true);
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

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
  static String getAntiCollisionName(String name, MediaFileType type) {
    String suffix = DateTime.now().millisecondsSinceEpoch.toString();
    return name.replaceAll(' ', '_') + '_' + suffix + '.' + type.toString();
  }

  /// Returns true if the application receives an HTTP response from the
  /// remote CMS server after making a GET request.
  static Future<bool> canAccessCMSRemote() async {
    return await _returnsResponse('http://lan.deepcove.xyz/api/app/config'); // Todo: replace with env value
  }

  /// Returns true if the application receives an HTTP response from the
  /// intranet server address, after making a GET request.
  static Future<bool> canAccessCMSLocal() async {
    return await _returnsResponse(Env.intranetURL);
  }

  /// Returns true if the device receives an HTTP response after making
  /// a GET request to the supplied address.
  static Future<bool> _returnsResponse(String address) async {
    try {
      Http.Response response = await Http.get(address);
      return response.statusCode != null;
    }
    catch(ex){ // no DNS resolution, invalid url, etc
      return false;
    }
  }

  /// Returns true if the device is able to ping the given
  /// address string (IP address or URL)
  /// CURRENTLY NOT IMPLEMENTED (due to broken dart_ping package)
  static Future<bool> _canPing(String address) async {

    // Todo: Figure out how to get the ping library to work
    // dart_ping library looks like it may be dead

    int responses = 0;
    bool success = false;

    // Get stream for ping data to be sent to
    var pingStream = await ping(address);

    // Do this every time a response is received
    pingStream.listen((p) {
      if(p.time.inMilliseconds < 2500) success = true;
      responses++;
    });

    // Wait for first success, or 4 fails
    while (responses < 4 && !success) {
      await Future.delayed(Duration(seconds: 1));
    }

    return success;
  }
}
