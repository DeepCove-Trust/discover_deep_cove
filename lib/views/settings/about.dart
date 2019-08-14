import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
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
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Heading(
                    "About the trust",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BodyText(
                    "The Deep Cove Outdoor Education Trust is a non-profit "
                    "organisation that was established in 1971. The Deep Cove Hostel "
                    "is a 50 bed building, and was established for the purpose of "
                    "enabling school aged children a unique opportunity to experience "
                    "life in a remote part of Fiordland National Park.",
                    align: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Heading(
                    "Special thanks",
                    align: TextAlign.left,
                  ),
                ),
                // Todo: Sort out the special thanks section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BodyText(
                    "The trust and developers would like to give a special thank you to "
                    "the Department of Conservation and the Te Reo Department of SIT for "
                    "providing information and recordings used within this app.",
                    align: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: BodyText(
                    "https://www.doc.govt.nz",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Heading(
                    "Developers",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BodyText(
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
}
