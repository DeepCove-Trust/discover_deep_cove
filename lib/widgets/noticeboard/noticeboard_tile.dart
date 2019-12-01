import 'package:discover_deep_cove/util/date_util.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final String desc;
  final bool isUrgent;
  final bool hasMore;
  final bool hasDivider;
  final VoidCallback onTap;

  NoticeTile({
    this.title,
    this.date,
    this.desc,
    this.isUrgent,
    this.hasMore,
    this.hasDivider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: isUrgent
            ? BoxDecoration(
          border: Border(
            left: BorderSide(color: Theme.of(context).indicatorColor, width: 5),
          ),
        )
            : null,
        child: Padding(
          padding: EdgeInsets.all(Screen.isTablet(context) ? 24 : 8),
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Divider(color: Colors.transparent, height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: Screen.width(context,
                                  percentage:
                                  Screen.isSmall(context) ? 75 : 80),
                              child: SubHeading(
                                title,
                                size: Screen.isTablet(context)
                                    ? 25
                                    : Screen.isSmall(context) ? 20 : 22,
                                align: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateUtil.formatDate(date),
                              style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: Screen.isTablet(context)
                                    ? 20
                                    : Screen.isSmall(context) ? 14 : 16,
                              ),
                            ),
                          ],
                        ),
                        hasMore
                            ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BodyText(
                            "MORE",
                            size: Screen.isTablet(context)
                                ? 20
                                : Screen.isSmall(context) ? 14 : 16,
                          ),
                        )
                            : Container(),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    desc,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: Screen.isTablet(context)
                          ? 20
                          : Screen.isSmall(context) ? 18 : 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                hasDivider
                    ? Divider(color: Theme.of(context).primaryColorLight, height: 1)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}