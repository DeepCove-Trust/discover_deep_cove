import 'dart:async';

import 'package:discover_deep_cove/data/models/activity/activity.dart';
import 'package:discover_deep_cove/data/models/activity/track.dart';
import 'package:discover_deep_cove/data/models/config.dart';
import 'package:discover_deep_cove/env.dart';
import 'package:discover_deep_cove/util/screen.dart';
import 'package:discover_deep_cove/widgets/misc/text/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sqflite/sqflite.dart';

import 'custom_marker.dart';

class MapMaker extends StatefulWidget {
  MapMaker({
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

class _MapMakerState extends State<MapMaker> with TickerProviderStateMixin {
  List<Track> tracks;
  int currentTrackNum;
  StreamController<String> trackStreamController;
  Stream<String> trackStream;

  MapState mapState;

  Track get currentTrack => tracks.length > 0 ? tracks[currentTrackNum] : null;

  bool get tracksLoaded => tracks != null;

  bool get hasTracks => tracks.length > 0;

  @override
  void initState() {
    print('map init');
    super.initState();
    trackStreamController = StreamController();
    trackStream = trackStreamController.stream;
    widget.animationStream.listen((activityId) {
      animateToActivity(activityId);
    });
    currentTrackNum = 0;

    // Determine whether previous map state has been saved, otherwise use
    // default values from the env file
    mapState =
        PageStorage.of(context).readState(context, identifier: 'MapState') ??
            MapState(center: Env.mapDefaultCenter, zoom: Env.mapDefaultZoom);

    tracks = PageStorage.of(context).readState(context, identifier: 'Tracks');

    // Load track data if not in storage
    if (tracks == null) loadTracks();
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
      if(config.length == 0){
        await Future.delayed(Duration(seconds: 5));
        Navigator.pushReplacementNamed(context, '/update', arguments: true);
      }

      tracks = await TrackBean.of(context).getAllAndPreload();
//      PageStorage.of(context).writeState(context, tracks, identifier: 'Tracks'); // Todo: Reenable when we have a way of refreshing activities after completion
      setState(() => tracks);
    } on DatabaseException catch (ex) {
      await Future.delayed(Duration(seconds: 5));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: tracksLoaded && hasTracks
            ? IconButton(
                icon: Icon(FontAwesomeIcons.arrowLeft),
                onPressed: () => changeTrack(increase: false),
                color: Colors.white,
              )
            : null,
        actions: tracksLoaded && hasTracks
            ? [
                IconButton(
                  icon: Icon(FontAwesomeIcons.arrowRight),
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
                        : Screen.isSmall(context) ? 16 : null,
                  );
                },
              )
            : SubHeading(
                'Loading tracks...',
                size: Screen.isTablet(context)
                    ? 30
                    : Screen.isSmall(context) ? 16 : null,
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
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  _onAfterBuild(context, mapPosition.center, mapPosition.zoom));
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
      tileProvider: MBTilesImageProvider.fromAsset("assets/map.mbtiles"),
      maxZoom: Env.mapMaxZoom,
      backgroundColor: Color(0xFF262626),
      tms: true,
    );
  }

  MarkerClusterLayerOptions _buildMarkerClusterOptions() {
    return MarkerClusterLayerOptions(
      maxClusterRadius: 30,
      height: 30,
      width: 30,
      anchorPos: AnchorPos.align(AnchorAlign.center),
      fitBoundsOptions: FitBoundsOptions(
        maxZoom: 18,
      ),
      markers: _getMarkers(),
      showPolygon: false,
      builder: (context, markers) {
        // Cluster will only show red if every marker belongs to current track.
        bool isForCurrent = markers
            .every((marker) => (marker as CustomMarker).track == currentTrack);

        return FloatingActionButton(
          child: Text(markers.length.toString()),
          backgroundColor:
              isForCurrent ? Theme.of(context).accentColor : Colors.grey,
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
    final _latTween = Tween<double>(
        begin: widget.mapController.center.latitude, end: latLng.latitude);
    final _lngTween = Tween<double>(
        begin: widget.mapController.center.longitude, end: latLng.longitude);
    final _zoomTween =
        Tween<double>(begin: widget.mapController.zoom, end: zoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      widget.mapController.move(
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

  _buildMarker(BuildContext context, Activity activity) {
    bool isCurrentTrack = activity.trackId == currentTrack.id;
    return Container(
        child: GestureDetector(
      onTap: () => widget.onMarkerTap(activity),
      child: Icon(
        activity.isCompleted()
            ? FontAwesomeIcons.lockOpen
            : FontAwesomeIcons.lock,
        size: isCurrentTrack ? 20 : 15,
        color: isCurrentTrack ? Theme.of(context).accentColor : Colors.grey,
      ),
    ));
  }

  ///Changes the trackTitle which is displayed on the AppBar
  ///and pans the map to the first marker within that set
  void changeTrack({bool increase}) async {
    await Future.delayed(
      Duration(milliseconds: 100),
    );

    currentTrackNum = increase
        ? (currentTrackNum + 1) % tracks.length
        : (currentTrackNum + tracks.length - 1) % tracks.length;

    trackStreamController.sink.add(currentTrack.name);
    animatedMove(latLng: currentTrack.activities[0].latLng, zoom: 16.0);
  }

  void animateToActivity(int activityId) async {
    Activity activity = await ActivityBean.of(context).find(activityId);

    if (activity.trackId != currentTrack.id)
      currentTrackNum =
          tracks.indexWhere((track) => track.id == activity.trackId);

    trackStreamController.sink.add(currentTrack.name);

    animatedMove(latLng: activity.latLng, zoom: 18.0);
  }
}

class MapState {
  LatLng center;
  double zoom;

  MapState({this.center, this.zoom});
}
