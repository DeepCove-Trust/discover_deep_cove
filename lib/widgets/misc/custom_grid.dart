import 'package:flutter/material.dart';

import '../../util/screen.dart';

class CustomGrid extends StatelessWidget {
  final List<Widget> children;
  final bool showAsColumn;

  CustomGrid({this.children, this.showAsColumn = false});

  @override
  Widget build(BuildContext context) {
    return showAsColumn ? buildColumn(context) : buildGrid();
  }

  Widget buildGrid() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [children[0], if (children.length > 1) children[1]],
        ),
        SizedBox(
          height: 12,
        ),
        if (children.length > 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [children[2], if (children.length > 3) children[3]],
          )
      ],
    );
  }

  Widget buildColumn(BuildContext context) {
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
              if (children.length > 2)
                SizedBox(
                  height: Screen.height(context, percentage: 5),
                ),
              if (children.length > 3) children[3],
              if (children.length > 3)
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
