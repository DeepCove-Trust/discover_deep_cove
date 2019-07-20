import 'dart:io';

import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final FactFileEntry entry;
  final Quiz quiz;
  final VoidCallback onTap;
  final String hero;

  Tile({this.onTap, this.entry, this.quiz, this.hero});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(3, 3),
                    blurRadius: 5),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: hero,
                  child: Container(
                    height: MediaQuery.of(context).size.width - 24, // due padding
                    decoration: quiz.image != null ? BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File(quiz == null
                            ? Env.getResourcePath(entry.mainImage.path)
                            : Env.getResourcePath(quiz.image.path))),
                        fit: BoxFit.fill,
                      ),
                    ) : null,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      color: Color.fromARGB(190, 0, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: quiz == null
                              ? Text(
                                  entry.primaryName,
                                  style: Theme.of(context).textTheme.body1,
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      quiz.title,
                                      style:
                                          Theme.of(context).textTheme.headline,
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100,
                                    ),
                                    Text(quiz.attempts > 0 ?
                                      "High Score: ${quiz.highScore}/${quiz.questions.length} | Attempts: ${quiz.attempts}" : "Not yet attempted",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .body1
                                          .copyWith(
                                            color: Color(0xFF777777),
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
