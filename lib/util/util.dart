import 'dart:io' show File, Directory;

import 'package:archive/archive.dart' show ZipDecoder, Archive, ArchiveFile;
import 'package:http/http.dart' show Response;
import 'package:meta/meta.dart' show required;
import 'package:path/path.dart' show join;

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
}
