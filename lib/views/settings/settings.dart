import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/activity/activity.dart';
import '../../data/models/config.dart';
import '../../data/models/quiz/quiz.dart';
import '../../util/screen.dart';
import '../../util/util.dart';
import '../../widgets/settings/settings_button.dart';

class Settings extends StatefulWidget {
  final void Function(String code) onCodeEntry;

  const Settings({
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
              Tooltip(
                height: Screen.height(context, percentage: 5),
                message:
                    'Turning this feature on will make the photos you save visible in your photo gallery. (Off by Default)',
                child: SettingsButton(
                  iconData: FontAwesomeIcons.image,
                  text: savePhotosToGallery == null ? '...' : 'Save photos to gallery',
                  hasOnOff: savePhotosToGallery == null ? false : true,
                  initalValue: savePhotosToGallery,
                  onOffCallback: (newVal) => setState(() {
                    _toggleSaveToGallery();
                  }),
                  onTap: _toggleSaveToGallery,
                ),
              ),
              Divider(color: Theme.of(context).primaryColorLight, height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.undo,
                text: 'Reset Progress',
                onTap: _confirmResetDialog,
              ),
              Divider(color: Theme.of(context).primaryColorLight, height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.sync,
                text: 'Check for updates',
                onTap: syncResources,
              ),
              Divider(color: Theme.of(context).primaryColorLight, height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.newspaper,
                text: 'View Notices',
                onTap: () => Navigator.of(context).pushNamed('/noticeboard'),
              ),
              Divider(color: Theme.of(context).primaryColorLight, height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.infoCircle,
                text: 'About this app',
                onTap: () {
                  Navigator.of(context).pushNamed('/about');
                },
              ),
              Divider(color: Theme.of(context).primaryColorLight, height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.qrcode,
                text: 'Manually Enter Code',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/activityUnlock',
                    arguments: widget.onCodeEntry,
                  );
                },
              ),
              Divider(color: Theme.of(context).primaryColorLight, height: 1),
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
            title: const Text(
              'Confirm Progress Reset?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: const Text(
              'This will reset all quiz and activity progress, and '
              'cannot be undone. Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: [
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                onPressed: resetInProgress ? null : () => _resetProgress(),
                child: const Text('Reset'),
              ),
            ],
            backgroundColor: Theme.of(context).primaryColorDark,
            shape: Border.all(
              color: Theme.of(context).primaryColor,
              width: 0.5,
            ),
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
    PageStorage.of(context).writeState(context, null, identifier: 'Tracks');

    Navigator.of(context).pop();
    resetInProgress = false;
    Util.showToast(context, 'Progress Reset!');
  }
}
