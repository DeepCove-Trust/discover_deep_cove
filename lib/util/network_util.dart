import 'package:http/http.dart' as Http;

import '../env.dart';

class NetworkUtil {
  /// Returns true if the application receives an HTTP response from the
  /// remote CMS server after making a GET request.
  static Future<bool> canAccessCMSRemote() async {
    return await _returnsResponse(
        'http://lan.deepcove.xyz/api/app/config'); // Todo: replace with env value
  }

  /// Returns true if the application receives an HTTP response from the
  /// intranet server address, after making a GET request.
  static Future<bool> canAccessCMSLocal() async {
    return await _returnsResponse(Env.intranetCmsUrl);
  }

  /// Returns true if the device receives an OK HTTP response after making
  /// a GET request to the supplied address.
  static Future<bool> _returnsResponse(String address) async {
    try {
      Http.Response response = await Http.get(address);
      return response.statusCode == 200;
    } catch (ex) {
      // no DNS resolution, invalid url, etc
      return false;
    }
  }

  /// Returns the body of the response that is returned in response to
  /// a GET request to the supplied URL.
  static Future<String> requestData(String url) async {
    Http.Response response = await Http.get(url);
    if (response.statusCode != 200)
      throw Exception('API responded with code ${response.statusCode}');
    return response.body;
  }
}
