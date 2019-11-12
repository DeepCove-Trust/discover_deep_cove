import 'dart:async';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/util/util.dart';
import 'package:discover_deep_cove/views/activites/activity_screen_args.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_index.dart';
import 'package:discover_deep_cove/views/quiz/quiz_index.dart';
import 'package:discover_deep_cove/views/settings/settings.dart';
import 'package:discover_deep_cove/widgets/map/map_maker.dart';
import 'package:discover_deep_cove/widgets/misc/custom_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:majascan/majascan.dart';
import 'package:toast/toast.dart';

enum Page { FactFile, Scan, Map, Quiz, Settings }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // Stream controller to tell map when to animate
  StreamController<int> mapAnimateController;

  Widget currentPage;
  List<Widget> pages = List<Widget>();

  final PageStorageBucket bucket = PageStorageBucket();

  MapController mapController;

  @override
  void initState() {
    super.initState();

    mapAnimateController = StreamController();
    mapController = MapController();
    // Initialize the list of page widgets.
    pages.add(FactFileIndex());
    pages.add(Container()); // placeholder
    pages.add(MapMaker(
      mapController: mapController,
      context: context,
      animationStream: mapAnimateController.stream.asBroadcastStream(),
      onMarkerTap: handleMarkerTap,
      key: PageStorageKey('Map Maker'),
    )); // placeholder
    pages.add(QuizIndex());
    pages.add(Settings(
      onCodeEntry: (code) => handleScanResult(code),
    ));
    currentPage = pages[Page.Map.index];
  }

  @override
  void dispose() {
    super.dispose();
    mapAnimateController.close();
  }

  void handleMarkerTap(Activity activity) async {
    if (activity.isCompleted()) {
      activity = await ActivityBean.of(context).preloadRelationships(activity);
      navigateToActivity(activity, true);
    } else {
      Toast.show(
        "Activity is locked, please scan qr-code",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.black,
      );
    }
  }

//End Map section

//Qr reader section
  ///Uses the camera to scan a qr code
  Future<void> scan() async {
    String qrString = await MajaScan.startScan(
      title: "Scan QR Code",
      qRCornerColor: Theme.of(context).accentColor,
      qRScannerColor: Theme.of(context).accentColor,
    );
    handleScanResult(qrString);
  }

  void navigateToActivity(Activity activity, bool isReview) {
    Navigator.pushNamed(
      context,
      '/activity',
      arguments: ActivityScreenArgs(
        activity: activity,
        isReview: isReview,
      ),
    );
  }

  ///Receives the result of the scan and determines what action to take
  void handleScanResult(String qrString) async {
    List<Activity> activities = await ActivityBean.of(context).getAll();
    Activity activity;

    try {
      activity = activities.firstWhere((a) => a.qrCode == qrString);
    } catch (ex) {
      Util.showToast(context, 'Unrecognized QR Code...');
      return;
    }

    activity = await ActivityBean.of(context).preloadRelationships(activity);

    if (activity.activityType == ActivityType.informational &&
        !activity.isCompleted()) activity.informationActivityUnlocked = true;

    if (pageIs(Page.Map)) {
      mapAnimateController.sink.add(activity.id);
    }

    // allow time to animate
    await Future.delayed(Duration(milliseconds: 1100));

    Navigator.pushNamed(context, '/activity',
        arguments: ActivityScreenArgs(activity: activity));
  }

//End qr reader section

  @override
  Widget build(BuildContext context) {
    Screen.setOrientations(context);

    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Color(0xFF262626),
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: Color(0xFFFF5026),
          textTheme: Theme.of(context).textTheme.copyWith(
                caption: TextStyle(color: Colors.white),
              ),
        ), // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            index == 1
                ? scan()
                : setState(() {
                    currentPage = pages[index];
                  });
          },
          currentIndex: pageIndex(currentPage),
          items: [
            _buildNavItem(title: 'Learn', icon: FontAwesomeIcons.book),
            _buildNavItem(title: 'Scan', icon: FontAwesomeIcons.qrcode),
            _buildNavItem(title: 'Map', icon: FontAwesomeIcons.map),
            _buildNavItem(title: 'Quiz', icon: FontAwesomeIcons.question),
            _buildNavItem(title: 'More', icon: FontAwesomeIcons.ellipsisV),
          ],
        ),
      ),
      floatingActionButton: pageIs(Page.Map)
          ? CustomFab(
              icon: FontAwesomeIcons.qrcode,
              text: "Scan",
              onPressed: () => scan(),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  BottomNavigationBarItem _buildNavItem({String title, IconData icon}) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Icon(icon),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(title),
      ),
    );
  }

  /// Pass this method a [Page] enum, and method will return true if it is
  /// the current page.
  bool pageIs(Page page) {
    return pageIndex(currentPage) == page.index;
  }

  /// Returns the index value of the given page
  int pageIndex(Widget page) {
    return pages.indexOf(page);
  }
}
