import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class CustomMarker extends Marker {
  CustomMarker(
      {this.track,
      LatLng point,
      WidgetBuilder builder,
      double width = 30,
      double height = 30,
      AnchorPos anchorPos})
      : super(
            point: point,
            builder: builder,
            width: width,
            height: height,
            anchorPos: anchorPos);

  final Track track;
}
