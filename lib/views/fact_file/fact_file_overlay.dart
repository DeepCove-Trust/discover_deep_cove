import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:discover_deep_cove/widgets/misc/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Todo: I have serious doubts about the responsive of this page...

class FactFileOverlay extends StatefulWidget {
  final FactFileEntry entry;

  FactFileOverlay({@required this.entry}) : assert(entry != null);

  @override
  _FactFileOverlayState createState() => _FactFileOverlayState();
}

class _FactFileOverlayState extends State<FactFileOverlay> {
  AudioPlayer player = AudioPlayer();
  bool _visible = false;
  int _duration = 300;

  @override
  void initState() {
    setVisible();
    super.initState();
  }

  Future<void> setVisible() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() => _visible = true);
  }

  @override
  Widget build(BuildContext context) {
    Screen.setOrientations(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _visible = false; // stops the overlay content from showing
          _duration = 100; // after the hero flies away...
        });
        Navigator.pop(context);
      },
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(10, 90, 10, 10),
        color: Color.fromRGBO(0, 0, 0, 0.75),
        child: getContent(context),
      ),
    );
  }

  Widget getContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          buildHero(context),
          AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: Duration(milliseconds: _duration),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.width - 20,
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                        image: FileImage(File(
//                            Env.getResourcePath(widget.entry.mainImage.path))),
//                        fit: BoxFit.cover,
//                      ),
//                    ),
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  child: Container(
                    height: MediaQuery.of(context).size.width - 20,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Heading( widget.entry.primaryName),
                                SizedBox(height: 5),
                                SubHeading( widget.entry.altName),
                              ],
                            ),
                            buildInfoButton(context),
                          ],
                        ),
                        BodyText( widget.entry.cardText),
                        getButtonRow(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Hero buildHero(BuildContext context) {
    return Hero(
      flightShuttleBuilder: (f, a, d, fc, tc) {
        return ScaleTransition(
          scale: a,
          child: fc.widget,
        );
      },
      tag: widget.entry.id,
      child: Container(
        child: Image(
          image:
              FileImage(File(Env.getResourcePath(widget.entry.mainImage.path))),
        ),
      ),
    );
  }

  Widget getButtonRow() {
    if (widget.entry.listenAudio != null ||
        widget.entry.pronounceAudio != null) {
      return Column(
        children: [
          Divider(color: Colors.white, height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.entry.pronounceAudio != null)
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 90) / 2,
                  child: OutlineButton(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.music, color: Colors.white),
                        SizedBox(height: 10),
                        BodyText( 'Pronounce'),
                      ],
                    ),
                    onPressed: () => player.play(
                        Env.getResourcePath(widget.entry.pronounceAudio.path),
                        isLocal: true),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              if (widget.entry.listenAudio != null)
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 90) / 2,
                  child: OutlineButton(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(FontAwesomeIcons.volumeUp, color: Colors.white),
                        SizedBox(height: 10),
                        BodyText( 'Listen'),
                      ],
                    ),
                    onPressed: () => player.play(
                        Env.getResourcePath(widget.entry.listenAudio.path),
                        isLocal: true),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                )
            ],
          ),
        ],
      );
    }
    return Container();
  }

  buildInfoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          '/factFileDetails',
          arguments: widget.entry,
        );
      },
      child: Column(
        children: [
          Icon(FontAwesomeIcons.infoCircle, color: Colors.white, size: 30),
          SizedBox(height: 10),
          BodyText( 'More Info'),
        ],
      ),
    );
  }
}
