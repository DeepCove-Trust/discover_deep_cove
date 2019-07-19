import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:discover_deep_cove/data/sample_data_activities.dart';
import 'package:discover_deep_cove/views/activites/count_view.dart';
import 'package:discover_deep_cove/views/activites/photograph_view.dart';
import 'package:discover_deep_cove/views/activites/picture_select_view.dart';
import 'package:discover_deep_cove/views/activites/picture_tap_view.dart';
import 'package:discover_deep_cove/views/activites/text_answer_view.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_index.dart';
import 'package:discover_deep_cove/views/quiz/quiz_index.dart';
import 'package:discover_deep_cove/views/settings/settings.dart';
import 'package:discover_deep_cove/widgets/misc/custom_fab.dart';
import 'package:discover_deep_cove/widgets/misc/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:toast/toast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int currentTab = 2;
  FactFileIndex one;

  //Two is scanner
  Widget three;
  QuizIndex four;
  Settings five;
  String trackTitle;
  int trackNum;
  MapController mapController;
  LatLng track;

  Color mapColor; // Todo: Is this needed?

  List<dynamic> pages;
  Widget currentPage;

  @override
  void initState() {
    super.initState();

    //Sets up the pages state
    one = FactFileIndex();
    //Two is scanner
    four = QuizIndex();
    five = Settings();
    pages = [one, null, three, four, five];
    currentPage = three;

    //The track the user starts at
    trackNum = 0;
    trackTitle = tracks[trackNum].name;

    mapController = MapController();
  }

  //Map Section
  ///Generates the markers that get placed on the map
  List<Marker> getMarkers() {
    List<Marker> markers = List<Marker>();

    for (Track track in tracks) {
      for (Activity activity in track.activities) {
        markers.add(
          Marker(
            width: 45.0,
            height: 45.0,
            point: LatLng(activity.location.x, activity.location.y),
            builder: (ctx) => Container(
              child: GestureDetector(
                onTap: () {
                  if (activity.activated) {
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
                },
                child: Icon(
                  activity.activated
                      ? FontAwesomeIcons.lockOpen
                      : FontAwesomeIcons.lock,
                  size: 45,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  ///returns the map
  FlutterMap map() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: LatLng(-45.463983, 167.155695),
        minZoom: 14.0,
        maxZoom: 18.0,
        zoom: 16.0,
        swPanBoundary: LatLng(-45.486373, 167.134838),
        nePanBoundary: LatLng(-45.441585, 167.176552),
        plugins: [
          MarkerClusterPlugin(),
        ],
      ),
      layers: [
        TileLayerOptions(
          tileProvider: MBTilesImageProvider.fromAsset("assets/map.mbtiles"),
          maxZoom: 18.0,
          backgroundColor: Color(0xFF262626),
          tms: true,
        ),
        MarkerClusterLayerOptions(
          maxClusterRadius: 100,
          height: 45,
          width: 45,
          anchorPos: AnchorPos.align(AnchorAlign.center),
          fitBoundsOptions: FitBoundsOptions(
            maxZoom: 18,
          ),
          markers: getMarkers(),
          showPolygon: false,
          builder: (context, markers) {
            return FloatingActionButton(
              child: Text(markers.length.toString()),
              onPressed: null,
              heroTag: null,
            );
          },
        ),
      ],
    );
  }

  ///animates the map to a new location and zoom level
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final _latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  ///Changes the trackTitle which is displayed on the AppBar
  ///and pans the map to the first marker within that set
  /// TODO: Code this concisely using Ken's % function
  void changeTrack(String dir) {
    int newTrackNum = trackNum;

    switch (dir) {
      case "-":
        if (newTrackNum == 0) {
          newTrackNum = tracks.length - 1;
        } else {
          newTrackNum--;
        }
        break;

      case "+":
        if (newTrackNum == tracks.length - 1) {
          newTrackNum = 0;
        } else {
          newTrackNum++;
        }
    }

    setState(() {
      trackNum = newTrackNum;
      trackTitle = tracks[trackNum].name;

      track = LatLng(tracks[trackNum].activities[0].location.x,
          tracks[trackNum].activities[0].location.y);
    });

    print(tracks[trackNum].activities[0].location.x);
    print(tracks[trackNum].activities[0].location.y);

    _animatedMapMove(track, 16.0);
  }

  //End Map section

  //Qr reader section
  ///Uses the camera to scan a qr code
  Future scan() async {
    try {
      String qrString = await BarcodeScanner.scan();

      handleMessage(qrString);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
      } else {}
    } on FormatException {} catch (e) {}
  }

  // TODO: Give fromMap a better name
  navigateToActivity(Activity activity, bool fromMap) {
    switch (activity.toString()) { // TODO: This will break if we override toString()
      case "PictureSelect":
        Navigator.pushNamed(
          context,
          '/pictureSelectView',
          arguments: PictureSelectView(
            activity: activity,
            fromMap: fromMap,
          ),
        );
        break;
      case "PictureTap":
        Navigator.pushNamed(
          context,
          '/pictureTapView',
          arguments: PictureTapView(
            activity: activity,
            fromMap: fromMap,
          ),
        );
        break;
      case "Count":
        Navigator.pushNamed(
          context,
          '/countView',
          arguments: CountView(
            activity: activity,
            fromMap: fromMap,
          ),
        );
        break;
      case "TextAnswer":
        Navigator.pushNamed(
          context,
          '/textAnswerView',
          arguments: TextAnswerView(
            activity: activity,
            fromMap: fromMap,
          ),
        );
        break;
      case "Photograph":
        Navigator.pushNamed(
          context,
          '/photographView',
          arguments: PhotographView(
            activity: activity,
            fromMap: fromMap,
          ),
        );
        break;
      default:
        Toast.show(
          "QR code not recognized!",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.black,
        );
    }
  }

  ///Recieves the result of the scan and determines what action to take
  void handleMessage(qrString) {
    Activity selectedActivity;

    for (Track track in tracks) {
      for (Activity activity in track.activities) {
        if (activity.qrCode == qrString) {
          selectedActivity = activity;
          break;
        }
      }
    }

    navigateToActivity(selectedActivity, false);
  }

  //End qr reader section

  ///provides the [AppBar] for a specific pages
  AppBar setAppBar(Widget pageNum) {
    if (currentPage == three) {
      return AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => changeTrack("-"),
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.arrowRight),
            onPressed: () => changeTrack("+"),
            color: Colors.white,
          ),
        ],
        title: HeadingText(
          text: trackTitle,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
      );
    } else if (currentPage == four) {
      return AppBar(
        title: HeadingText(
          text: "Deep Cove Trivia",
        ),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, '/quizUnlock');
            },
            color: Colors.transparent,
            padding: EdgeInsets.only(top: 8.0),
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
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: setAppBar(currentPage),
      body: currentPage == three ? map() : currentPage,
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
                    currentTab = index;
                    currentPage = pages[index];
                  });
          },
          currentIndex: currentTab,
          items: [
            _buildNavItem(title: 'Learn', icon: FontAwesomeIcons.book),
            _buildNavItem(title: 'Scan', icon: FontAwesomeIcons.qrcode),
            _buildNavItem(title: 'Map', icon: FontAwesomeIcons.map),
            _buildNavItem(title: 'Quiz', icon: FontAwesomeIcons.question),
            _buildNavItem(title: 'More', icon: FontAwesomeIcons.ellipsisV),
          ],
        ),
      ),
      floatingActionButton: currentPage == three
          ? CustomFAB(
              icon: FontAwesomeIcons.qrcode,
              text: "Scan",
              onPressed: scan,
            )
          : Container(), // Todo: Why a container?
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  BottomNavigationBarItem _buildNavItem({String title, IconData icon}){

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
}
