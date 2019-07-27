import 'package:flutter/services.dart';

handleOrientation(List<DeviceOrientation> orientations) {
  SystemChrome.setPreferredOrientations(orientations);
}
