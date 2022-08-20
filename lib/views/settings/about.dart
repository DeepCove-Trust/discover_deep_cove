import 'package:flutter/material.dart';

import '../../util/screen.dart';
import '../../widgets/misc/bottom_back_button.dart';
import '../../widgets/misc/text/body_text.dart';
import '../../widgets/misc/text/heading.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: setYPadding(context),
                  ),
                  child: Heading("About the trust"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setXPadding(context),
                    vertical: setYPadding(context),
                  ),
                  child: BodyText(
                    "The Deep Cove Outdoor Education Trust is a non-profit "
                    "organisation that was established in 1971. The Deep Cove Hostel "
                    "is a 50 bed building, and was established for the purpose of "
                    "enabling school aged children a unique opportunity to experience "
                    "life in a remote part of Fiordland National Park.",
                    align: TextAlign.left,
                  ),
                ),
                Divider(color: Colors.white30),
                Padding(
                  padding: EdgeInsets.only(
                    top: setYPadding(context),
                  ),
                  child: Heading("Special thanks"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setXPadding(context),
                    vertical: setYPadding(context),
                  ),
                  child: BodyText(
                    "The trust and developers would like to give a special thank you to "
                    "the Department of Conservation (https://www.doc.govt.nz) for information and recordings used within this app.",
                    align: TextAlign.left,
                  ),
                ),
                Divider(color: Colors.white30),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: setYPadding(context),
                  ),
                  child: Heading("Developers"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setXPadding(context),
                  ),
                  child: BodyText(
                    "This app was developed by Mitchell Quarrie,"
                    " Samuel Jackson and Samuel Grant",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setXPadding(context),
                    vertical: setYPadding(context),
                  ),
                  child: BodyText(
                    'App icon designed by Dylan Ross',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomBackButton(),
      ),
    );
  }

  setXPadding(BuildContext context) {
    return Screen.height(context) >= 600 && Screen.isPortrait(context)
        ? Screen.width(context, percentage: 5)
        : Screen.height(context) >= 600 && Screen.isLandscape(context)
            ? Screen.width(context, percentage: 10)
            : Screen.width(context, percentage: 2.5);
  }

  setYPadding(BuildContext context) {
    return Screen.height(context) >= 600 && Screen.isPortrait(context)
        ? Screen.width(context, percentage: 6)
        : Screen.height(context) >= 600 && Screen.isLandscape(context)
            ? Screen.height(context, percentage: 8)
            : Screen.width(context, percentage: 4);
  }
}
