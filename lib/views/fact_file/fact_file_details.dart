import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/bottom_back_button.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:discover_deep_cove/widgets/misc/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FactFileDetails extends StatefulWidget {
  final FactFileEntry entry;

  FactFileDetails({@required this.entry}) : assert(entry != null);

  @override
  State<StatefulWidget> createState() => _FactFileDetailsState();
}

class _FactFileDetailsState extends State<FactFileDetails> {
  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: buildContent(),
      bottomNavigationBar: BottomBackButton(),
    );
  }

  buildContent() {
    return ListView(
      children: [
        getCarousel(),
        getContent(),
      ],
    );
  }

  getCarousel() {
    return FutureBuilder(
      future: loadImages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Hero(
              tag: widget.entry.id,
              child: Carousel(
                autoplay: true,
                images: snapshot.data,
                autoplayDuration: Duration(seconds: 5),
                dotBgColor: Color.fromRGBO(0, 0, 0, 0.5),
                animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 1000),
              ),
            ),
          );
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  // This future won't return until all images have been pre-cached.
  Future<List<Image>> loadImages() async {
    List<Image> images = List<Image>();
    for (MediaFile media in widget.entry.galleryImages) {
      ImageProvider provider = FileImage(File(Env.getResourcePath(media.path)));
      await precacheImage(provider, context);
      images.add(Image(image: provider));
    }
    return images;
  }

  getContent() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Heading(text: widget.entry.primaryName),
          SizedBox(height: 20),
          SubHeading(text: widget.entry.altName),
          Divider(color: Colors.white, height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        BodyText(text: 'Pronounce'),
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
                        BodyText(text: 'Listen'),
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
          Divider(color: Colors.white, height: 50),
          BodyText(
            text: widget.entry.bodyText,
            align: TextAlign.justify,
          ),
          // Todo: Incorporate nuggets
        ],
      ),
    );
  }
}
