import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
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
    return (Screen.width(context) >= 600 && !Screen.isPortrait(context))
        ? GridView.count(
            crossAxisCount: 2,
            children: [
              getCarousel(),
              ListView(
                children: [
                  getContent(),
                ],
              ),
            ],
          )
        : ListView(
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
            width: Screen.width(context),
            height: Screen.width(context),
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
            width: Screen.width(context),
            height: Screen.width(context),
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
          Heading( Screen.width(context).toString()),
          SizedBox(height: Screen.height(context, percentage: 1.56)),
          SubHeading( widget.entry.altName),
          Divider(color: Colors.white, height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.entry.pronounceAudio != null)
                SizedBox(
                  width: Screen.width(
                        context,
                        percentage: Screen.width(context) <= 350
                            ? 80
                            : Screen.width(context) >= 600 &&
                                    !Screen.isPortrait(context)
                                ? 45
                                : 88.75,
                      ) /
                      2,
                  child: OutlineButton(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.music,
                          color: Colors.white,
                          size: Screen.width(context) <= 350 ? 16 : 24,
                        ),
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
                  width: Screen.width(
                        context,
                        percentage: Screen.width(context) <= 350
                            ? 80
                            : Screen.width(context) >= 600 &&
                                    !Screen.isPortrait(context)
                                ? 45
                                : 88.75,
                      ) /
                      2,
                  child: OutlineButton(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.volumeUp,
                          color: Colors.white,
                          size: Screen.width(context) <= 350 ? 16 : 24,
                        ),
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
          Divider(color: Colors.white, height: 50),
          BodyText(
            
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam consectetur justo eu libero fermentum, vel bibendum eros dapibus. Nam a orci ac mauris malesuada tincidunt id non tortor. Duis nisi eros, blandit in leo nec, varius pretium magna. Sed quis nibh varius, lacinia ante id, maximus lectus. Donec vitae congue felis, eget ullamcorper turpis. Nunc non ligula pharetra, lacinia tellus hendrerit, volutpat tortor. Sed at sapien ac turpis fringilla ullamcorper ac eu nulla. Duis id congue felis. Aenean laoreet accumsan mauris. Pellentesque sapien eros, porttitor venenatis iaculis sit amet, accumsan in risus. Aliquam ornare nec lectus sit amet feugiat."
                "Sed non sem ac nulla convallis sollicitudin consectetur eu ex. Suspendisse fermentum vel sapien a aliquet. Aliquam sodales sit amet libero eu ullamcorper. Duis facilisis quis dui vitae consectetur. Suspendisse porta commodo dolor sed accumsan. Nam quam tellus, semper in neque ac, eleifend interdum nunc. Aliquam erat volutpat. Aenean quis auctor ligula, ut vestibulum felis. Morbi laoreet nibh quis arcu interdum tempor. Vivamus mattis orci est, id sollicitudin purus tincidunt a. Phasellus sit amet sapien ut metus rutrum placerat."
                "Praesent velit nibh, condimentum sed porta gravida, efficitur at nibh. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Quisque suscipit, nisl nec sollicitudin cursus, lectus purus sollicitudin lacus, ac pretium sapien leo id libero. Vestibulum accumsan porttitor eros. Aenean libero ante, sagittis sed aliquam ac, tincidunt suscipit ligula. Integer dui nisi, pulvinar a sem sit amet, commodo imperdiet urna. Sed congue dignissim sodales. Duis pulvinar faucibus lacinia."
                "Morbi et ullamcorper eros. Donec in efficitur elit, vel convallis nulla. Proin augue nunc, dapibus non lacus sit amet, mattis mattis lectus. Nulla et est suscipit eros aliquam dictum. Pellentesque eu gravida risus, vel faucibus lorem. Sed interdum ullamcorper mi, ut finibus dui rhoncus a. Etiam tempor laoreet lobortis. Nullam varius nisl at varius semper. Aliquam pharetra felis sapien, quis malesuada urna gravida non."
                "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec nec elit eget metus finibus bibendum nec vel tellus. Donec lobortis id elit quis ultrices. Ut urna enim, molestie eu posuere eget, porta et nunc. Nullam non elit vitae massa ultricies dictum. Duis rutrum hendrerit est id lobortis. Suspendisse est turpis, fringilla sed enim ac, dictum maximus ipsum. Suspendisse porttitor, ipsum id porta maximus, tortor eros viverra orci, eget finibus tortor magna id justo. Etiam elementum bibendum mauris vel tempus. Donec pharetra lorem sed mauris molestie, nec lobortis orci vestibulum.",
            align: TextAlign.justify,
          ),
          // Todo: Incorporate nuggets
        ],
      ),
    );
  }
}
