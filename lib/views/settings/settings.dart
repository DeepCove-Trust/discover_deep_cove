import 'package:discover_deep_cove/util/data_sync.dart';
import 'package:discover_deep_cove/widgets/misc/body_text.dart';
import 'package:discover_deep_cove/widgets/settings/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _syncInProgress = false;
  String _progressMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: _buildPage(),
      ),
    );
  }

  List<Widget> _buildPage() {
    List<Widget> widgets = List<Widget>();

    Column content = Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Divider(
          color: Color(0xFF777777),
        ),
        SettingsButton(
          icon: FontAwesomeIcons.undo,
          text: "Reset Progress",
          onTap: null,
        ),
        Divider(
          color: Color(0xFF777777),
        ),
        SettingsButton(
          icon: FontAwesomeIcons.sync,
          text: "Check for updates",
          onTap: syncResources,
        ),
        Divider(
          color: Color(0xFF777777),
        ),
        SettingsButton(
          icon: FontAwesomeIcons.infoCircle,
          text: "About this app",
          onTap: () {
            Navigator.of(context).pushNamed('/about');
          },
        ),
        Divider(
          color: Color(0xFF777777),
        ),
      ],
    );

    widgets.add(content);

    if (_syncInProgress) {
      Stack modal = Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.9,
            child: const ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 50),
                BodyText(
                  text: _progressMessage,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
      widgets.add(modal);
    }

    return widgets;
  }

  void syncResources() async {

    setState(() {
      _syncInProgress = true;
      _progressMessage = 'Checking for updates.\nPlease wait...';
    });

    var updates = await SyncProvider.updatedDataAvailable();

    if(updates['data'] == true || updates['files'] == true){
      setState(() {
        _progressMessage = "Downloading updates.\nPlease wait...";
      });
    }

    await SyncProvider.syncResources(updates);

    setState((){
      _progressMessage = "Application up to date!";
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _syncInProgress = false;
    });
  }
}
