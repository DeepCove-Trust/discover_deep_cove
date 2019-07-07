import 'package:flutter/material.dart';
import 'package:hci_v2/util/body1_text.dart';
import 'package:hci_v2/util/heading_text.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: HeadingText(
                  text: "About the trust",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Body1Text(
                  text: "The Deep Cove Outdoor Education Trust is a non profit "
                      "organisation that was established in 1971. The Deep Cove Hostel"
                      " is a 50 bed building and was established for the purpose of "
                      "enabling school aged children a unique opportunity to experience"
                      " life in a remote part of the Fiordland National Park.",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: HeadingText(
                  text: "Special thanks",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Body1Text(
                  text:
                      "The trust and developers would like to give a special thank you to"
                      " serveral people who helped make this app a reality"
                      "The Southern Insitute Te Reo department provide maori pronuciations "
                      "audio for the native bird calls was sourced from the Department of"
                      " Conservation",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Body1Text(
                  text: "https://www.doc.govt.nz",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: HeadingText(
                  text: "Developers",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Body1Text(
                  text: "This app was developed by Mitchell Quarrie,"
                      " Samuel Jackson and Samuel Grant",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
