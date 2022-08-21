import 'package:flutter/material.dart';

import '../../util/screen.dart';

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;
  final BuildContext context;

  const SelectedPhoto({this.numberOfDots, this.photoIndex, this.context});

  Widget _inactivePhoto() {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: Container(
        height: Screen.height(context, percentage: 1.5),
        width: Screen.height(context, percentage: 1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(color: Colors.grey, width: 1.0, style: BorderStyle.solid),
        ),
      ),
    );
  }

  Widget _activePhoto() {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: Container(
        height: Screen.height(context, percentage: 2),
        width: Screen.height(context, percentage: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int i = 0; i < numberOfDots; ++i) dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildDots(),
      ),
    );
  }
}
