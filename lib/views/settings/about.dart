import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/text/heading.dart';
import 'package:flutter/material.dart';

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
                  padding: EdgeInsets.symmetric(
                    vertical: setYPadding(context),
                  ),
                  child: Heading(
                    "About the trust",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setXPadding(context),
                  ),
                  child: Body(
                    "The Deep Cove Outdoor Education Trust is a non-profit "
                    "organisation that was established in 1971. The Deep Cove Hostel "
                    "is a 50 bed building, and was established for the purpose of "
                    "enabling school aged children a unique opportunity to experience "
                    "life in a remote part of Fiordland National Park.",
                    align: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: setYPadding(context),
                  ),
                  child: Heading("Special thanks"),
                ),
                // Todo: Sort out the special thanks section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: setXPadding(context),
                  ),
                  child: Body(
                    "The trust and developers would like to give a special thank you to "
                    "the Department of Conservation and the Te Reo Department of SIT for "
                    "providing information and recordings used within this app.",
                    align: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),                  
                  child: Body("https://www.doc.govt.nz"),
                ),
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
                  child: Body(
                    "This app was developed by Mitchell Quarrie,"
                    " Samuel Jackson and Samuel Grant",
                    align: TextAlign.left,
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
        ? Screen.width(context, percentage: 10)
        : Screen.height(context) >= 600 && Screen.isLandscape(context)
            ? Screen.width(context, percentage: 20)
            : Screen.width(context, percentage: 5);
  }

  setYPadding(BuildContext context) {
    return Screen.height(context) >= 600 && Screen.isPortrait(context)
        ? Screen.width(context, percentage: 8)
        : Screen.height(context) >= 600 && Screen.isLandscape(context)
            ? Screen.height(context, percentage: 10)
            : Screen.width(context, percentage: 5);
  }
}
