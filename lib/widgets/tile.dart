import 'package:flutter/material.dart';
import 'package:hci_v2/data/sample_data_fact_file.dart';
import 'package:hci_v2/data/sample_data_quiz.dart';

class Tile extends StatelessWidget {
  final FactFileEntry entry;
  final Quiz quiz;
  final VoidCallback onTap;
  final String hero;
  final double height;

  Tile({this.onTap, this.entry, this.quiz, this.hero, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(2.5, 2.5),
                    blurRadius: 5.0),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: hero,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(quiz == null
                            ? entry.mainImage.path
                            : quiz.image.path),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      color: Color.fromARGB(190, 0, 0, 0),
                      height: height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: quiz == null
                              ? Text(
                                  entry.title,
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
                                      style: Theme.of(context).textTheme.headline,
                                      softWrap: false,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "High Score: ${quiz.highScore}/${quiz.questions.length} | Attempts: ${quiz.attempts}",
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
