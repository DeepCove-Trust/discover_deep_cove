import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/views/activites/activity_screen_args.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_index.dart';
import 'package:discover_deep_cove/views/quiz/quiz_index.dart';
import 'package:discover_deep_cove/views/settings/settings.dart';
import 'package:discover_deep_cove/widgets/map/map_maker.dart';
import 'package:discover_deep_cove/widgets/misc/custom_fab.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:discover_deep_cove/widgets/misc/loading_modal_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:toast/toast.dart';

enum Page { FactFile, Scan, Map, Quiz, Settings }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _isLoading = false;
  String _loadingMessage;
  Icon _loadingIcon;

  // State of map position / zoom level
  LatLng mapPosition;
  int zoomLevel;

  Widget currentPage;
  List<Widget> pages = List<Widget>();

  MapController mapController;

  @override
  void initState() {
    super.initState();

    mapController = MapController();
    // Initialize the list of page widgets.
    pages.add(FactFileIndex());
    pages.add(Container()); // placeholder
    pages.add(MapMaker(
      mapController: mapController,
      context: context,
      onMarkerTap: handleMarkerTap,
    )); // placeholder
    pages.add(QuizIndex());
    pages.add(Settings(
      onProgressUpdate: setLoadingModal,
    ));
    currentPage = pages[Page.Map.index];
  }

  void handleMarkerTap(Activity activity) {
    if (activity.isCompleted()) {
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
    try {
      String qrString = await BarcodeScanner.scan();

      handleMessage(qrString);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
      } else {}
    } on FormatException {} catch (e) {}
  }

  void navigateToActivity(Activity activity, bool isReview) {
    Navigator.pushNamed(context, '/activity',
        arguments: ActivityScreenArgs(
          activity: activity,
          isReview: isReview,
        ));
  }

  ///Receives the result of the scan and determines what action to take
  void handleMessage(qrString) {
//    Activity selectedActivity;
//
//    for (Track track in tracks) {
//      for (Activity activity in track.activities) {
//        if (activity.qrCode == qrString) {
//          selectedActivity = activity;
//          break;
//        }
//      }
//    }
//
//    navigateToActivity(selectedActivity, false);
  }

//End qr reader section

  ///provides the [AppBar] for a specific pages
  AppBar setAppBar(Widget pageNum) {
    if (pageIs(Page.Map)) {
      return null;
//      return AppBar(
//        leading: IconButton(
//          icon: Icon(FontAwesomeIcons.arrowLeft),
//          onPressed: () => changeTrack(increase: false),
//          color: Colors.white,
//        ),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(FontAwesomeIcons.arrowRight),
//            onPressed: () => changeTrack(increase: true),
//            color: Colors.white,
//          ),
//        ],
//        title: Heading(
//          text: tracks.length > 0 ? currentTrack.name : '',
//        ),
//        centerTitle: true,
//        backgroundColor: Theme.of(context).primaryColorDark,
//      );
    } else if (pageIs(Page.Quiz)) {
      return AppBar(
        title: Heading(
           "Deep Cove Trivia",
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quizUnlock');
            },
            color: Colors.transparent,
            padding: EdgeInsets.only(top: 7.0),
            child: Column(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.lockOpen,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Unlock",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        brightness: Brightness.dark,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Screen.setOrientations(context);
    
    return Stack(children: _buildPage());
  }

  List<Widget> _buildPage() {
    List<Widget> contents = List<Widget>();

    contents.add(Scaffold(
      appBar: setAppBar(currentPage),
      body: currentPage,
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
              onPressed: scan,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));

    if (_isLoading) {
      contents.add(LoadingModalOverlay(
        loadingMessage: _loadingMessage,
        icon: _loadingIcon,
      ));
    }

    return contents;
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

  /// This method is passed to the settings widget, so that it can use
  /// a loading modal that will block out the entire screen.
  void setLoadingModal({bool isLoading, String loadingMessage, Icon icon}) {
    setState(() {
      _isLoading = isLoading;
      _loadingMessage = loadingMessage;
      _loadingIcon = icon;
    });
  }
}
