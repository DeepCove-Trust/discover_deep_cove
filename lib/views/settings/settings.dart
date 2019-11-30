import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/data/models/quiz/quiz.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/widgets/settings/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  final void Function(String code) onCodeEntry;

  Settings({
    @required this.onCodeEntry,
  });

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool savePhotosToGallery;
  bool resetInProgress;

  @override
  void initState() {
    _loadConfig();
    resetInProgress = false;
    super.initState();
  }

  Future<void> _loadConfig() async {
    Config config = await ConfigBean.of(context).find(1);
    setState(() {
      savePhotosToGallery = config.savePhotosToGallery;
    });
  }

  void _toggleSaveToGallery() async {
    Config newConfig = Config();
    newConfig.id = 1;
    newConfig.savePhotosToGallery = !savePhotosToGallery;
    await ConfigBean.of(context).update(newConfig, onlyNonNull: true);

    setState(() => savePhotosToGallery = !savePhotosToGallery);
  }

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
                  text: savePhotosToGallery == null
                      ? '...'
                      : savePhotosToGallery
                          ? "Stop saving photos to gallery"
                          : "Save photos to gallery",
                  onTap: savePhotosToGallery != null
                      ? () => _toggleSaveToGallery()
                      : null),
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
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/activityUnlock',
                    arguments: widget.onCodeEntry,
                  );
                },
              ),
              Divider(color: Color(0xFF777777), height: 1),
            ],
          )
        ],
      ),
    );
  }

  void syncResources() async {
    PageStorage.of(context).writeState(context, null, identifier: 'Quizzes');
    PageStorage.of(context).writeState(context, null, identifier: 'FactFiles');
    PageStorage.of(context).writeState(context, null, identifier: 'Tracks');
    Navigator.pushNamed(context, '/update', arguments: false);
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
                onPressed: resetInProgress ? null : () => _resetProgress(),
              ),
            ],
          );
        });
  }

  _resetProgress() async {
    if (resetInProgress) return;
    resetInProgress = true;

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

    PageStorage.of(context).writeState(context, null, identifier: 'Quizzes');
    PageStorage.of(context).writeState(context, null, identifier: 'FactFiles');
    PageStorage.of(context).writeState(context, null, identifier: 'Tracks');

    Navigator.of(context).pop();
    resetInProgress = false;
    Util.showToast(context, 'Progress Reset!');
  }
}
