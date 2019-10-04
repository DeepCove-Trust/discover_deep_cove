import 'dart:io';

import 'package:discover_deep_cove/data/models/factfile/fact_file_category.dart';
import 'package:discover_deep_cove/data/models/factfile/fact_file_entry.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/body_text.dart';
import 'package:discover_deep_cove/widgets/fact_file/fact_file_tab.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
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
  List<FactFileCategory> categories;

  @override
  void initState() {
    super.initState();
    factFileCategoryBean = FactFileCategoryBean.of(context);

    categories =
        PageStorage.of(context).readState(context, identifier: 'FactFiles');
    if (categories == null) refreshData();

    controller = TabController(
        vsync: this,
        length: categories?.length != null
            ? categories.length == 0 ? 1 : categories.length
            : 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    List<FactFileCategory> data =
        await factFileCategoryBean.getAllWithPreloadedEntries();

    PageStorage.of(context).writeState(context, data, identifier: 'FactFiles');

    if (mounted) {
      setState(() {
        categories = data;
        controller = TabController(
            vsync: this, length: data.length == 0 ? 1 : data.length);
      });
    }

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
    return categories == null || categories?.length == 0
        ? [
            Container(
              width: Screen.width(context),
              child:
                  BodyText(categories == null ? 'Loading Fact Files...' : ''),
            )
          ]
        : categories.map((c) {
            return Container(
              width: Screen.width(context) /
                  (categories.length > 2 ? 3 : categories.length),
              // Todo: better way?
              child: BodyText(c.name),
            );
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
    return Scaffold(
      appBar: getTabBar(),
      body: categories == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: controller,
              children: categories.length == 0
                  ? [Center(child: SubHeading('No content...'))]
                  : getTabs()),
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
