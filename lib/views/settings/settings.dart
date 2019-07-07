import 'package:flutter/material.dart';
import 'package:hci_v2/util/body1_text.dart';
import 'package:hci_v2/views/settings/about_tab.dart';
import 'package:hci_v2/views/settings/settings_tab.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

///Displays the tab view for the settings section
class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          color: Theme.of(context).primaryColorDark,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(child: Container()),
                TabBar(
                  labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  controller: controller,
                  tabs: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Body1Text(
                        text: "Settings",
                        align: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Body1Text(
                        text: "About",
                        align: TextAlign.center,
                      ),
                    ),
                  ],
                  indicatorColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TabBarView(
            controller: controller,
            children: <Widget>[
              SettingsTab(),
              AboutTab(),
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
