import 'package:discover_deep_cove/views/home.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
/* temp commented until these views are implemented
    //Fact file routes
      case '/factFileDetails':
        if (args is FactFilesDetails) {
          final FactFilesDetails args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => FactFilesDetails(
              entry: args.entry,
              heroTag: args.heroTag,
            ),
          );
        }

        return _errorRoute();

    //Quiz routes
      case '/quizUnlock':
        return MaterialPageRoute(
          builder: (_) => QuizUnlock(),
        );

      case '/quizQuestions':
        if (args is Quiz) {
          return MaterialPageRoute(
            builder: (_) => QuizQuestions(
              quiz: args,
            ),
          );
        }

        return _errorRoute();

    //Activity routes
      case '/countView':
        if (args is CountView) {
          final CountView args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => CountView(
              activity: args.activity,
              fromMap: args.fromMap,
            ),
          );
        }

        return _errorRoute();

      case '/photographView':
        if (args is PhotographView) {
          final PhotographView args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => PhotographView(
              activity: args.activity,
              fromMap: args.fromMap,
            ),
          );
        }

        return _errorRoute();

      case '/pictureSelectView':
        if (args is PictureSelectView) {
          final PictureSelectView args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => PictureSelectView(
              activity: args.activity,
              fromMap: args.fromMap,
            ),
          );
        }

        return _errorRoute();

      case '/pictureTapView':
        if (args is PictureTapView) {
          final PictureTapView args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => PictureTapView(
              activity: args.activity,
              fromMap: args.fromMap,
            ),
          );
        }

        return _errorRoute();

      case '/textAnswerView':
        if (args is TextAnswerView) {
          final TextAnswerView args = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => TextAnswerView(
              activity: args.activity,
              fromMap: args.fromMap,
            ),
          );
        }

        return _errorRoute();

*/
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(
            'ERROR',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    });
  }
}
