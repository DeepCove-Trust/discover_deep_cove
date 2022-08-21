import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/models/activity/activity.dart';
import '../../data/models/activity/track.dart';
import '../../data/models/config.dart';
import '../../env.dart';
import '../../util/screen.dart';
import '../../util/verbose_state.dart';
import '../misc/text/sub_heading.dart';
import 'custom_marker.dart';

class MapMaker extends StatefulWidget {
  const MapMaker({
    @required this.mapController,
    @required this.context,
    @required this.onMarkerTap,
    @required this.animationStream,
    Key key,
  }) : super(key: key);

  final Function(Activity) onMarkerTap;
  final MapController mapController;
  final Stream<int> animationStream;
  final BuildContext context;

  @override
  State createState() => _MapMakerState();
}

class _MapMakerState extends VerboseState<MapMaker> with TickerProviderStateMixin {
  List<Track> tracks;
  int currentTrackNum;
  StreamController<String> trackStreamController;
  Stream<String> trackStream;

  ActivityBean activityBean;

  MapState mapState;

  Track get currentTrack => tracks.length > 0 ? tracks[currentTrackNum] : null;

  bool get tracksLoaded => tracks != null;

  bool get hasTracks => tracks.length > 0;

  @override
  void initState() {
    super.initState();
    trackStreamController = StreamController();
    trackStream = trackStreamController.stream;
    widget.animationStream.listen((activityId) {
      animateToActivity(activityId);
    });
    currentTrackNum = 0;

    activityBean = ActivityBean.of(context);

    // Determine whether previous map state has been saved, otherwise use
    // default values from the env file
    mapState = PageStorage.of(context).readState(context, identifier: 'MapState') ??
        MapState(center: Env.mapDefaultCenter, zoom: Env.mapDefaultZoom);

    tracks = PageStorage.of(context).readState(context, identifier: 'Tracks');

    // Load track data if not in storage OR reload has been flagged
    if (tracks == null || (PageStorage.of(context).readState(context, identifier: 'ReloadMap') ?? false)) loadTracks();
  }

  @override
  void dispose() {
    super.dispose();
    trackStreamController.close();
  }

  Future<void> loadTracks() async {
    try {
      // Determine if initial sync has been completed
      List<Config> config = await ConfigBean.of(context).getAll();
      if (config.length == 0) {
        await Future.delayed(const Duration(seconds: 5));
        Navigator.pushReplacementNamed(context, '/update', arguments: true);
      }

      tracks = await TrackBean.of(context).getAllAndPreload();
      PageStorage.of(context).writeState(context, tracks, identifier: 'Tracks');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('reloadMap', false);
      setState(() => tracks);
    } on DatabaseException {
      await Future.delayed(const Duration(seconds: 5));
      // Table doesn't exist yet, load content
      Navigator.pushReplacementNamed(context, '/update', arguments: true);
    }
  }

  void _onAfterBuild(BuildContext context, LatLng center, double zoom) {
    PageStorage.of(context).writeState(
        context,
        MapState(
          center: center,
          zoom: zoom,
        ),
        identifier: 'MapState');
  }

  void checkIfReloadRequired() async {
    if (Env.debugMessages) debugPrint('Checking if reload required');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool reloadMap = prefs.getBool('reloadMap');
    if (reloadMap ?? false) {
      if (Env.debugMessages) debugPrint('Map reload is required...');
      loadTracks();
    } else if (Env.debugMessages) {
      debugPrint('Map reload is not required...');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    checkIfReloadRequired();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: tracksLoaded && hasTracks
            ? IconButton(
                icon: const Icon(FontAwesomeIcons.arrowLeft),
                onPressed: () => changeTrack(increase: false),
                color: Colors.white,
              )
            : null,
        actions: tracksLoaded && hasTracks
            ? [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.arrowRight),
                  onPressed: () => changeTrack(increase: true),
                  color: Colors.white,
                ),
              ]
            : null,
        title: tracksLoaded
            ? StreamBuilder(
                stream: trackStream,
                initialData: hasTracks ? currentTrack.name : 'No tracks...',
                builder: (context, snapshot) {
                  return SubHeading(
                    snapshot.hasData ? snapshot.data : '',
                    size: Screen.isTablet(context)
                        ? 30
                        : Screen.isSmall(context)
                            ? 16
                            : null,
                  );
                },
              )
            : SubHeading(
                'Loading tracks...',
                size: Screen.isTablet(context)
                    ? 30
                    : Screen.isSmall(context)
                        ? 16
                        : null,
              ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          center: mapState.center,
          minZoom: Env.mapMinZoom,
          maxZoom: Env.mapMaxZoom,
          zoom: mapState.zoom,
          swPanBoundary: Env.swPanBoundary,
          nePanBoundary: Env.nePanBoundary,
          plugins: [MarkerClusterPlugin()],
          onPositionChanged: (mapPosition, hasGesture, isGesture) {
            if (mapPosition.center != Env.mapDefaultCenter) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _onAfterBuild(context, mapPosition.center, mapPosition.zoom));
            }
          },
        ),
        layers: [
          _buildTileLayerOptions(),
          _buildMarkerClusterOptions(),
        ],
      ),
    );
  }

  TileLayerOptions _buildTileLayerOptions() {
    return TileLayerOptions(
      tileProvider: MBTilesImageProvider.fromAsset('assets/map.mbtiles'),
      maxZoom: Env.mapMaxZoom,
      backgroundColor: const Color(0xFF262626),
      tms: true,
    );
  }

  MarkerClusterLayerOptions _buildMarkerClusterOptions() {
    return MarkerClusterLayerOptions(
      maxClusterRadius: 30,
      height: 30,
      width: 30,
      anchorPos: AnchorPos.align(AnchorAlign.center),
      fitBoundsOptions: const FitBoundsOptions(
        maxZoom: 18,
      ),
      markers: _getMarkers(),
      showPolygon: false,
      builder: (context, markers) {
        // Cluster will only show red if every marker belongs to current track.
        bool isForCurrent = markers.every((marker) => (marker as CustomMarker).track == currentTrack);

        return FloatingActionButton(
          child: Text(markers.length.toString()),
          backgroundColor: isForCurrent ? Theme.of(context).accentColor : Colors.grey,
          onPressed: null,
          heroTag: null,
        );
      },
    );
  }

  List<CustomMarker> _getMarkers() {
    List<CustomMarker> markers = List<CustomMarker>();
    if (tracksLoaded) {
      for (Track track in tracks) {
        for (Activity activity in track.activities) {
          markers.add(CustomMarker(
            track: track,
            point: activity.latLng,
            builder: (context) => _buildMarker(context, activity),
          ));
        }
      }
    }
    return markers;
  }

  void animatedMove({LatLng latLng, double zoom}) {
    final _latTween = Tween<double>(begin: widget.mapController.center.latitude, end: latLng.latitude);
    final _lngTween = Tween<double>(begin: widget.mapController.center.longitude, end: latLng.longitude);
    final _zoomTween = Tween<double>(begin: widget.mapController.zoom, end: zoom);

    var controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      widget.mapController
          .move(LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)), _zoomTween.evaluate(animation));
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

  _buildMarker(BuildContext context, Activity activity) {
    bool isCurrentTrack = activity.trackId == currentTrack.id;
    return GestureDetector(
      onTap: () => widget.onMarkerTap(activity),
      child: Icon(
        activity.isCompleted() ? FontAwesomeIcons.lockOpen : FontAwesomeIcons.lock,
        size: isCurrentTrack ? 20 : 15,
        color: isCurrentTrack ? Theme.of(context).accentColor : Colors.grey,
      ),
    );
  }

  ///Changes the trackTitle which is displayed on the AppBar
  ///and pans the map to the first marker within that set
  void changeTrack({bool increase}) async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    currentTrackNum =
        increase ? (currentTrackNum + 1) % tracks.length : (currentTrackNum + tracks.length - 1) % tracks.length;

    trackStreamController.sink.add(currentTrack.name);
    animatedMove(latLng: currentTrack.activities[0].latLng, zoom: 16.0);
  }

  void animateToActivity(int activityId) async {
    Activity activity = await activityBean.find(activityId);

    if (activity.trackId != currentTrack.id) {
      currentTrackNum = tracks.indexWhere((track) => track.id == activity.trackId);
    }

    if (!trackStreamController.isClosed) {
      trackStreamController.sink.add(currentTrack.name);
    }

    animatedMove(latLng: activity.latLng, zoom: 18.0);
  }
}

class MapState {
  LatLng center;
  double zoom;

  MapState({this.center, this.zoom});
}
