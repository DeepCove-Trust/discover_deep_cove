import 'dart:io';

import 'package:discover_deep_cove/data/database_adapter.dart';
import 'package:discover_deep_cove/data/models/media_file.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/widgets/misc/tile.dart';
import 'package:flutter/material.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';


class QuizIndex extends StatefulWidget {
  @override
  State createState() => _QuizIndexState();
}

class _QuizIndexState extends State<QuizIndex> {
  @override
  Widget build(BuildContext context) {
    QuizBean quizBean = QuizBean(DatabaseAdapter.of(context));
    MediaFileBean mediaFileBean = MediaFileBean(DatabaseAdapter.of(context));

    return FutureBuilder(
        future: mediaFileBean.find(1),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            MediaFile image = snapshot.data;
            return Center(
              child: image != null
                  ? Image(image: FileImage(File(Env.getResource(image.path))))
                  : Text("No image found"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });

//    return FutureBuilder(
//        future: quizBean.findWhereAndPreload(eq('unlocked', true)),
//        builder: (BuildContext context, AsyncSnapshot snapshot) {
//          if (snapshot.hasData) {
//            List<Quiz> quizzes = snapshot.data;
//            return Container(
//              child: quizzes.length > 0
//                  ? ListView.builder(
//                      itemCount: quizzes.length,
//                      itemBuilder: (context, index) {
//                        Quiz quiz = quizzes[index];
//                        return Tile(
//                            onTap: () {
//                              quiz.attempts++;
//                              Navigator.pushNamed(
//                                context,
//                                '/quizQuestions',
//                                arguments: quiz,
//                              );
//                            },
//                            quiz: quiz,
//                            hero: quiz.id.toString(),
//                            height:
//                                (MediaQuery.of(context).size.width / 10) * 2);
//                      })
//                  : Center(
//                      child: Text(
//                      'No quizzes found...',
//                      style: TextStyle(color: Colors.black),
//                    )),
//            );
//          }
//          return Container(
//            child: Center(
//              child: Text(
//                'Loading',
//                style: TextStyle(color: Colors.black),
//              ),
//            ),
//          );
//        });
  }

  List<Tile> buildCards(BuildContext context, List<Quiz> quizzes) {
    return quizzes.map((quiz) {
      return Tile(
          onTap: () {
            quiz.attempts++;
            Navigator.pushNamed(
              context,
              '/quizQuestions',
              arguments: quiz,
            );
          },
          quiz: quiz,
          hero: quiz.id.toString(),
          height: (MediaQuery.of(context).size.width / 10) * 2);
    });
  }
}
