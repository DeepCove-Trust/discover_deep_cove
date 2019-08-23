import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class CustomVGrid extends StatelessWidget {
  final List<Widget> children;

  CustomVGrid({this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              children[0],
              SizedBox(
                height: Screen.height(context, percentage: 5),
              ),
              children[1],
              SizedBox(
                height: Screen.height(context, percentage: 5),
              ),
              if (children.length > 2) children[2],
              SizedBox(
                height: Screen.height(context, percentage: 5),
              ),
              if (children.length > 3) children[3],
              SizedBox(
                height: Screen.height(context, percentage: 5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
