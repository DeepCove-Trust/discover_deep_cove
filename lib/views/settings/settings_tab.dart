import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hci_v2/data/sample_data_activities.dart';
import 'package:hci_v2/data/sample_data_quiz.dart';
import 'package:hci_v2/util/body1_text.dart';
import 'package:hci_v2/util/heading_text.dart';
import 'package:hci_v2/widgets/settings/settings_button.dart';
import 'package:toast/toast.dart';

class SettingsTab extends StatefulWidget {
  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SettingsButton(
          icon: FontAwesomeIcons.undo,
          text: "Reset Progress",
          onTap: () => handleTap(),
        ),
        Divider(color: Color(0xFF777777)),
        SettingsButton(
          icon: FontAwesomeIcons.sync,
          text: "Check for updates",
          onTap: () {},
        ),
        Divider(color: Color(0xFF777777)),
        SettingsButton(
          icon: FontAwesomeIcons.image,
          text: "Save images to device",
          onTap: () {},
        ),
        Divider(color: Color(0xFF777777)),
      ],
    );
  }

  handleTap() {
    confirmReset(context).then((bool result) {
      if (result) {
        ///Sets all [quizzes] to locked and sets [highscore] and [attempts] to 0
        for (Quiz quiz in quizzes) {
          quiz.unlocked = false;
          quiz.attempts = 0;
          quiz.highScore = 0;
        }

        ///Deactivates all [activities] checks [isCompleted]
        ///and sets user input to null where appropriate
        for (Track track in tracks) {
          for (dynamic activity in track.activities) {
            activity.activated = false;
            if (activity.isCompleted()) {
              switch (activity.toString()) {
                case "PictureSelect":
                  activity.selectedPicture = null;
                  break;
                case "PictureTap":
                  activity.userPoint = null;
                  break;
                case "Count":
                  activity.userCount = null;
                  break;
                case "TextAnswer":
                  activity.userText = null;
                  break;
                case "Photograph":
                  activity.userPhoto = null;
                  break;
              }
            }
          }
        }

        Toast.show(
          "Progress reset complete!",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.black,
        );
      }
    });
  }
}

Future<bool> confirmReset(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: HeadingText(
          text: "Are you sure...",
        ),
        content: SingleChildScrollView(
          child: Body1Text(
            text: "All tracks and quizzes will be locked and "
                "all information will be deleted!",
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('YES'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: const Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
        backgroundColor: Theme.of(context).primaryColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),
        ),
      );
    },
  );
}
