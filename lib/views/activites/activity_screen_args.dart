import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:flutter/material.dart';

class ActivityScreenArgs{
  final Activity activity;
  final bool isReview;
  ActivityScreenArgs({@required this.activity, this.isReview = false});
}