import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/util/data_sync.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

// Todo: This screen should replicate the splash screen.
class _SplashState extends State<Splash> {
  String text = 'Opening application...';

  @override
  void initState() {
    super.initState();
    checkContent();
  }

  // Check whether the database exists
  Future<void> checkContent() async {
    // Check whether database file exists and push the home screen if so
    try {
      await ConfigBean.of(context).find(1);
      Navigator.of(context).popAndPushNamed('/');
    } catch (ex) {
      if (ex is DatabaseException) {
        // Database hasn't been built
        setState(() {
          text = 'Downloading application content.\n\n'
              'This may take several minutes.';
        });

        bool wasSuccessful = await SyncProvider.syncResources();

        if (wasSuccessful) {
          Navigator.of(context).popAndPushNamed('/');
        } else {
          text = 'Unable to download application content.'; // todo: finish this
        }
      }
      throw ex; // otherwise, throw the exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Center(child: Image.asset('assets/splash_logo.png')),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 30),
            BodyText(text),
            SizedBox(height: Screen.width(context, percentage: 20)),
          ],
        )
      ],
    );
  }
}
