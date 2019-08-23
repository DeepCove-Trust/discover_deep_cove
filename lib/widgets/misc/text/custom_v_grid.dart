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
            children: [children[0], children[1],if (children.length > 2 )children[2], if (children.length > 3) children[3]],
          ),
          // SizedBox(
          //   height: 12,
          // ),
          // children.length > 2
          //     ? Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [if (children.length > 2 )children[2], if (children.length > 3) children[3]],
          //       )
          //     : Container(),
        ],
      ),
    );
  }
}
