import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/views/activites/count_activity_view.dart';
import 'package:discover_deep_cove/views/activites/photograph_activity_view.dart';
import 'package:discover_deep_cove/views/activites/picture_select_activity_view.dart';
import 'package:discover_deep_cove/views/activites/picture_tap_activity_view.dart';
import 'package:discover_deep_cove/views/activites/text_answer_activity_view.dart';
import 'package:discover_deep_cove/views/fact_file/fact_file_index.dart';
import 'package:discover_deep_cove/views/quiz/quiz_index.dart';
import 'package:discover_deep_cove/views/settings/settings.dart';
import 'package:discover_deep_cove/widgets/misc/custom_fab.dart';
import 'package:discover_deep_cove/widgets/misc/heading.dart';
import 'package:discover_deep_cove/widgets/misc/loading_modal_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
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

  List<Track> tracks = List<Track>();
  int currentTrackNum;

  MapController mapController;

  @override
  void initState() {
    super.initState();

    // Initialize the list of page widgets.
    pages.add(FactFileIndex());
    pages.add(Container()); // placeholder
    pages.add(Container()); // placeholder
    pages.add(QuizIndex());
    pages.add(Settings(
      onProgressUpdate: setLoadingModal,
    ));
    currentPage = pages[Page.Map.index];

    //The track the user starts at
    currentTrackNum = 0;
    mapController = MapController();
  }

  Future<List<Track>> loadTracks() async {
    return await TrackBean.of(context).getAllAndPreload();
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
            point: LatLng(activity.xCoord, activity.yCoord),
            builder: (ctx) => Container(
              child: GestureDetector(
                onTap: () {
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
                },
                child: Icon(
                  activity.isCompleted()
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
  FlutterMap getMap() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: LatLng(-45.463983, 167.155695),
        // Todo: remember location state
        minZoom: 14.0,
        maxZoom: 18.0,
        zoom: 16.0,
        swPanBoundary: LatLng(-45.486373, 167.134838),
        nePanBoundary: LatLng(-45.441585, 167.176552),
        plugins: [MarkerClusterPlugin()],
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
  void changeTrack({bool increase}) {
    setState(() {
      currentTrackNum = increase
          ? (currentTrackNum + 1) % tracks.length
          : (currentTrackNum + tracks.length - 1) % tracks.length;
    });

    // Animate to first activity of track
    _animatedMapMove(tracks[currentTrackNum].activities[0].latLng, 16.0);
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
    switch (activity.toString()) {
      case "PictureSelect":
        Navigator.pushNamed(
          context,
          '/pictureSelectView',
          arguments: PictureSelectActivityView(
            activity: activity,
            isReview: fromMap,
          ),
        );
        break;
      case "PictureTap":
        Navigator.pushNamed(
          context,
          '/pictureTapView',
          arguments: PictureTapActivityView(
            activity: activity,
            isReview: fromMap,
          ),
        );
        break;
      case "Count":
        Navigator.pushNamed(
          context,
          '/countView',
          arguments: CountActivityView(
            activity: activity,
            isReview: fromMap,
          ),
        );
        break;
      case "TextAnswer":
        Navigator.pushNamed(
          context,
          '/textAnswerView',
          arguments: TextAnswerActivityView(
            activity: activity,
            isReview: fromMap,
          ),
        );
        break;
      case "Photograph":
        Navigator.pushNamed(
          context,
          '/photographView',
          arguments: PhotographActivityView(
            activity: activity,
            isReview: fromMap,
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
    if (pageIs(Page.Map)) {
      return AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => changeTrack(increase: false),
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.arrowRight),
            onPressed: () => changeTrack(increase: true),
            color: Colors.white,
          ),
        ],
        title: Heading(
          text: tracks[currentTrackNum].name,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
      );
    } else if (pageIs(Page.Quiz)) {
      return AppBar(
        title: Heading(
          text: "Deep Cove Trivia",
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
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _buildPage());
  }

  List<Widget> _buildPage() {
    List<Widget> contents = List<Widget>();

    contents.add(Scaffold(
      appBar: setAppBar(currentPage),
      body: pageIs(Page.Map) ? getMap() : currentPage,
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