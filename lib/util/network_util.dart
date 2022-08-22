import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../env.dart';
import 'exeptions.dart';
import 'permissions.dart';

class NetworkUtil {
  /// Returns true if the application receives an HTTP response from the
  /// remote CMS server after making a GET request.
  static Future<bool> canAccessCMSRemote() async {
    return await _returnsResponse(Env.configUrl(CmsServerLocation.internet));
  }

  /// Returns true if the application receives an HTTP response from the
  /// intranet server address, after making a GET request.
  static Future<bool> canAccessCMSLocal() async {
    return await _returnsResponse(Env.configUrl(CmsServerLocation.intranet));
  }

  /// Returns true if the device receives an OK HTTP response after making
  /// a GET request to the supplied address.
  static Future<bool> _returnsResponse(String address) async {
    try {
      if (Env.debugMessages) debugPrint('Attempting to contact content server at $address');
      http.Response response = await http.get(address);
      if (Env.debugMessages) debugPrint('Response:');
      if (Env.debugMessages) debugPrint(response.statusCode.toString());
      return response.statusCode == 200;
    } catch (ex) {
      // no DNS resolution, invalid url, etc
      return false;
    }
  }

  /// Returns the decoded JSON list that is received in response to a get
  /// request to the supplied URL.
  // static Future<List<dynamic>> requestJsonList(String url) {
  //   // TODO: Complete this
  // }

  /// Returns the decoded JSON map that is received in response to a get
  /// request to the supplied URL.
  // static Future<Map<String, dynamic>> requestJsonMap(String url) {
  //   // TODO: Complete this
  // }

  /// Returns the body of the response that is returned in response to
  /// a GET request to the supplied URL, as a string.
  static Future<String> requestDataString(String url) async {
    http.Response response = await _requestResponse(url);
    return response.body;
  }

  /// Returns the body of the response that is returned in response to
  /// a GET request to the supplied URL, as an array of ints.
  static Future<List<int>> requestDataBytes(String url) async {
    http.Response response = await _requestResponse(url);
    return response.bodyBytes;
  }

  /// Returns [Response] object for a GET request to the provided URL.
  /// Throws [ApiException] if status code is not 200 (OK).
  static Future<http.Response> _requestResponse(String url) async {
    http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw ApiException(message: 'Request to $url returned non-OK response', statusCode: response.statusCode);
    }
    return response;
  }

  /// Stores the body of the [http.Response] as a file, using the specified
  /// [absPath] and [filename]. Will create directories that do not exist.
  /// Use within try-catch.
  static Future<File> httpResponseToFile({
    @required http.Response response,
    @required String absPath,
    @required String filename,
  }) async {
    return await bytesToFile(bytes: response.bodyBytes, absPath: absPath, filename: filename);
  }

  /// Stores the supplied [List<int>] as a file, using the specified [absPath]
  /// and [filename].
  /// Creates directories if required.
  static Future<File> bytesToFile({
    @required List<int> bytes,
    @required String absPath,
    @required String filename,
  }) async {
    // Check for storage permissions before saving file
    // if (!(await Permissions.ensurePermission(PermissionGroup.storage))) {
    //   throw Exception('Application does not have permission to save file.');
    // }

    // Write the supplied bytes to the file
    File file = File(join(absPath, filename));
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);

    return file;
  }
}
