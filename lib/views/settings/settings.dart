import 'package:discover_deep_cove/util/data_sync.dart';
import 'package:discover_deep_cove/util/hex_color.dart';
import 'package:discover_deep_cove/views/activites/activity_unlock.dart';
import 'package:discover_deep_cove/widgets/settings/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  final void Function({bool isLoading, String loadingMessage, Icon icon})
      onProgressUpdate;

  Settings({@required this.onProgressUpdate});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SettingsButton(
                iconData: FontAwesomeIcons.lockOpen,
                text: "Unlock activity",
                onTap: () => Navigator.pushNamed(context, '/activityUnlock',)
              ),
              Divider(color: HexColor("FF777777"), height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.undo,
                text: "Reset Progress",
                onTap: null,
              ),
              Divider(color: HexColor("FF777777"), height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.sync,
                text: "Check for updates",
                onTap: syncResources,
              ),
              Divider(color: HexColor("FF777777"), height: 1),
              SettingsButton(
                iconData: FontAwesomeIcons.infoCircle,
                text: "About this app",
                onTap: () {
                  Navigator.of(context).pushNamed('/about');
                },
              ),
              Divider(color: HexColor("FF777777"), height: 1),
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
}
