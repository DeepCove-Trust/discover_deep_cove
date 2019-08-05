import 'dart:io';

import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/fact_file/fact_file_tab.dart';
import 'package:flutter/material.dart';

/// Displays the tabs and a [tile] representing each [FactFileEntry]
class FactFileIndex extends StatefulWidget {
  @override
  _FactFileIndexState createState() => _FactFileIndexState();
}

class _FactFileIndexState extends State<FactFileIndex>
    with TickerProviderStateMixin {
  TabController controller;
  FactFileCategoryBean factFileCategoryBean;
  List<FactFileCategory> categories = List<FactFileCategory>();

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: categories.length);
    factFileCategoryBean = FactFileCategoryBean.of(context);
    refreshData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    List<FactFileCategory> data =
        await factFileCategoryBean.getAllWithPreloadedEntries();

    setState(() {
      categories = data;
      controller = TabController(vsync: this, length: data.length);
    });

    for (FactFileCategory category in categories) {
      for (FactFileEntry entry in category.entries)
        precacheImage(
          FileImage(File(Env.getResourcePath(entry.mainImage.path))),
          context,
        );
    }
  }

  ///Returns a list of [Text] widgets that are the tab labels
  List<Container> getTabHeadings() {
    return categories.map((c) {
      return Container(
          width: Screen.width(context) /
              (categories.length > 2 ? 3 : categories.length),
          // Todo: better way?
          child: BodyText( c.name, align: TextAlign.center));
    }).toList();
  }

  ///Returns a list of [FactFileTab] widgets that are passed the list of category entries
  List<FactFileTab> getTabs() {
    return categories.map((c) {
      return FactFileTab(c.entries);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Screen.setOrientations(context);
    
    // Loading screen
    if (categories.length == 0) {
      return Container(
          color: Theme.of(context).primaryColorDark,
          child: Center(
            child: CircularProgressIndicator(),
          ));
    }

    // If loaded
    return Scaffold(
      appBar: getTabBar(),
      body: TabBarView(controller: controller, children: getTabs()),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget getTabBar() {
    return PreferredSize(
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
                tabs: getTabHeadings(),
                indicatorColor: Theme.of(context).primaryColor,
                isScrollable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
