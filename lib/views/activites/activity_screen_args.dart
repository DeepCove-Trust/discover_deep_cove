import 'package:flutter/material.dart';

import '../../data/models/activity/activity.dart';

class ActivityScreenArgs {
  final Activity activity;
  final bool isReview;
  ActivityScreenArgs({@required this.activity, this.isReview = false});
}
