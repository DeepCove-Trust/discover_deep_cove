import 'dart:io';

import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/sub_heading.dart';
import 'package:flutter/material.dart';

class FactFileOverlay extends StatelessWidget {
  final FactFileEntry entry;

  FactFileOverlay({@required this.entry}) : assert(entry != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(10, 90, 10, 10),
        color: Color.fromRGBO(0, 0, 0, 0.75),
        child: buildHero(),
      ),
    );
  }

  Hero buildHero() {
    return Hero(
      flightShuttleBuilder: (f, a, d, fc, tc) =>
          ScaleTransition(scale: a, child: fc.widget),
      tag: entry.primaryName,
      child: getContent(),
    );
  }

  Widget getContent() {
    return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(File(entry.mainImage.path)),
            fit: BoxFit.cover,
          ),
        ),
        child: Container());
  }

  Widget getButtonRow() {
    if (entry.listenAudio != null || entry.pronounceAudio != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (entry.listenAudio != null)
            OutlineButton(
              child: BodyText(text: 'Listen'),
              onPressed: () => print('Pressed "Listen"'),
              borderSide: BorderSide(color: Colors.white),
            ),
          if (entry.pronounceAudio != null)
            OutlineButton(
              child: BodyText(text: 'Pronounce'),
              onPressed: () => print('Pressed "Pronounce"'),
              borderSide: BorderSide(color: Colors.white),
            ),
        ],
      );
    }
    return Container();
  }
}
