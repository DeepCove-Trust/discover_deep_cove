import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/data_sync.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/settings/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  final void Function({bool isLoading, String loadingMessage, Icon icon})
      onProgressUpdate;
  final void Function(String code) onCodeEntry;

  Settings({
    @required this.onProgressUpdate,
    @required this.onCodeEntry,
  });

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: [
          Column(
            children: [
              SettingsButton(
                iconData: FontAwesomeIcons.image,
                text: Util.saveToDevice ? "Stop saving photos to gallery" : "Save photos to gallery",
                onTap: () => setState(() => Util.saveToDevice = !Util.saveToDevice),
              ),
              Divider(color: Color(0xFF777777), height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.undo,
                text: "Reset Progress",
                onTap: _confirmResetDialog,
              ),
              Divider(color: Color(0xFF777777), height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.sync,
                text: "Check for updates",
                onTap: syncResources,
              ),
              Divider(color: Color(0xFF777777), height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.infoCircle,
                text: "About this app",
                onTap: () {
                  Navigator.of(context).pushNamed('/about');
                },
              ),
              Divider(color: Color(0xFF777777), height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.qrcode,
                text: "Manually Enter Code",
                onTap: () => Navigator.pushNamed(
                  context,
                  '/activityUnlock',
                  arguments: widget.onCodeEntry,
                ),
              ),
              Divider(color: Color(0xFF777777), height: 1),
            ],
          )
        ],
      ),
    );
  }

  void syncResources() async {
    bool wasSuccess = false;

    widget.onProgressUpdate(
        isLoading: true,
        loadingMessage: 'Checking for updates.\n\nPlease wait...');

    Map<String, bool> updates;

    try {
      updates = await SyncProvider.updatedDataAvailable();

      if (updates['data'] == true || updates['files'] == true) {
        widget.onProgressUpdate(
            isLoading: true,
            loadingMessage: 'Downloading updates.\n\nPlease wait...');
      }

      wasSuccess = await SyncProvider.syncResources();
    } catch (ex) {
      print(ex.toString());
      await displayError();
    }

    if (wasSuccess) {
      widget.onProgressUpdate(
        isLoading: true,
        loadingMessage: 'Application up to date!',
        icon: Icon(Icons.check, color: Colors.green, size: 60),
      );
      await Future.delayed(Duration(seconds: 2));
    } else {
      await displayError();
    }

    widget.onProgressUpdate(isLoading: false);
  }

  Future<void> displayError() async {
    widget.onProgressUpdate(
      isLoading: true,
      loadingMessage: 'Oops! An error occured.\n\nPlease try again later.',
      icon: Icon(Icons.error_outline, color: Colors.red, size: 60),
    );
    await Future.delayed(Duration(seconds: 2));
  }

  _confirmResetDialog() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Progress Reset?'),
            content: Text('This will reset all quiz and activity progress, and '
                'cannot be undone. Are you sure?'),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Reset'),
                onPressed: () => _resetProgress(),
              ),
            ],
          );
        });
  }

  _resetProgress() async {
    ActivityBean activityBean = ActivityBean.of(context);
    List<Activity> activities = await activityBean.getAll();
    activities.forEach((a) {
      a.clearProgress();
      activityBean.update(a);
    });

    QuizBean quizBean = QuizBean.of(context);
    List<Quiz> quizzes = await quizBean.getAll();
    quizzes.forEach((q) {
      quizBean.clearProgress(q.id);
      quizBean.update(q);
    });

    Navigator.of(context).pop();
    Util.showToast(context, 'Progress Reset!');
  }
}
