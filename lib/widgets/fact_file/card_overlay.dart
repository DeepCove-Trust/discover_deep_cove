import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardOverlay extends StatefulWidget {
  final FactFileEntry entry;
  final VoidCallback onTap;
  final VoidCallback onButtonTap;

  CardOverlay({
    this.entry,
    this.onTap,
    this.onButtonTap,
  });

  @override
  _CardOverlayState createState() => _CardOverlayState();
}

class _CardOverlayState extends State<CardOverlay> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: new InkWell(
        onTap: () => widget.onTap(),
        child: new Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.entry.mainImage.path),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            color: Color.fromARGB(190, 0, 0, 0),
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        4) *
                                                    2.5,
                                                child: Text(
                                                  widget.entry.primaryName,
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline,
                                                ),
                                              ),
                                              Container(
                                                child: FlatButton(
                                                  onPressed: widget.onButtonTap,
                                                  color: Colors.transparent,
                                                  padding: EdgeInsets.fromLTRB(
                                                      6.0, 6.0, 6.0, 2.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Icon(
                                                          FontAwesomeIcons
                                                              .infoCircle,
                                                          color: Colors.white),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 8.0),
                                                        child: Text(
                                                          "More Info!",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: (MediaQuery.of(context).size.width / 10) * 2,
                                  ),
                                  BodyText(
                                    text: widget.entry.bodyText,
                                    align: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
