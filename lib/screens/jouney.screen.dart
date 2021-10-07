import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/enums.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/create_marker_drawer.widget.dart';
import 'package:wru_fe/widgets/jouney_appbar.widget.dart';
import 'package:wru_fe/widgets/jouneys_drawer.widget.dart';
import 'package:wru_fe/widgets/jouneys.widget.dart';
import 'package:wru_fe/widgets/markers.widget.dart';

class JouneyScreen extends StatefulWidget {
  JouneyScreen({Key? key, this.lastKnowUserLocation}) : super(key: key);
  static const routeName = "/jouney-screen";
  Position? lastKnowUserLocation;

  @override
  _JouneyScreenState createState() => _JouneyScreenState();
}

class _JouneyScreenState extends State<JouneyScreen> {
  Completer<GoogleMapController> _controller = Completer();

  double initialZoom = 14.4746;
  Set<Marker> checkinMarkers = {};
  Set<Marker> allMarker = {};
  Marker userMarker = Marker(
    markerId: MarkerId("userLocationId"),
    visible: false,
  );
  Circle selectedCircle = Circle(circleId: CircleId("selectCircle"));
  String selectedJouneyId = "";
  String appBarTitle = "";
  EndDrawerComponentName endDrawerComponentName =
      EndDrawerComponentName.markers;

  StreamSubscription<BoxEvent>? watchLastSeenJouney;

  @override
  void initState() {
    _loadLastSeenJouney();
    _loadUserLocation();

    var hiveConfig = getIt<HiveConfig>();
    watchLastSeenJouney =
        hiveConfig.storeBox!.watch(key: LAST_SEEN_JOUNEY).listen((event) {
      _loadLastSeenJouney();
    });

    super.initState();
  }

  @override
  void dispose() {
    if (watchLastSeenJouney != null) {
      watchLastSeenJouney!.cancel();
    }
    super.dispose();
  }

  void _loadLastSeenJouney() async {
    dynamic lastSeenJouneyId = getValueFromStore(LAST_SEEN_JOUNEY);
    bool isSameJouney = lastSeenJouneyId == selectedJouneyId;

    if (lastSeenJouneyId != null) {
      var jouney = await context
          .read<FetchJouneyByIdCubit>()
          .fetchJouneyById(lastSeenJouneyId.toString());

      if (jouney != null) {
        var markers = _generateGGCheckinMakers(jouney.markers);
        setState(() {
          selectedJouneyId = jouney.uuid.toString();
          checkinMarkers = markers;
          appBarTitle = jouney.name.toString();
          if (!isSameJouney) {
            selectedCircle = Circle(circleId: CircleId("selectCircle"));
          }
        });
      }
    }
  }

  void _loadUserLocation() async {
    Position userLocation = await getUserLocation();
    double lat = userLocation.latitude;
    double lng = userLocation.longitude;

    var userPinIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(48, 48),
      ),
      'assets/images/user_location_pin.png',
    );

    var marker = Marker(
      markerId: userMarker.mapsId,
      position: LatLng(lat, lng),
      flat: false,
      icon: userPinIcon,
      visible: true,
    );

    setState(() {
      userMarker = marker;
    });

    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: initialZoom,
    );

    _moveCameraTo(cameraPosition);
  }

  Set<Marker> _generateGGCheckinMakers(List<CustomMarker> markers) {
    Set<Marker> newMarkers = {};
    for (CustomMarker appMarker in markers) {
      double latitude = appMarker.lat as double;
      double longitude = appMarker.lng as double;

      Marker marker = Marker(
        markerId: MarkerId(appMarker.uuid.toString()),
        position: LatLng(latitude, longitude),
      );

      newMarkers.add(marker);
    }
    return newMarkers;
  }

  Circle _getSelectedMarkerCircle(double lat, double lng) {
    var seletedCircle = Circle(
      circleId: CircleId("selectCircle"),
      center: LatLng(lat, lng),
      fillColor: Colors.blue[200] ?? Colors.blue,
      strokeWidth: 1,
      strokeColor: Colors.blue[500] ?? Colors.blue,
      radius: 35,
    );

    return seletedCircle;
  }

  Widget _screenContent(
    MarkerState state,
    Set<Marker> allMarker,
    Circle selectedCircle,
  ) {
    var lastPosition = widget.lastKnowUserLocation;

    double lat = lastPosition != null ? lastPosition.latitude : 0;
    double lng = lastPosition != null ? lastPosition.longitude : 0;
    List<Circle> circles = [selectedCircle];

    var initCameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 11,
    );

    return GoogleMap(
      mapType: MapType.normal,
      markers: allMarker,
      circles: Set.from(circles),
      initialCameraPosition: initCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> _moveCameraTo(CameraPosition cameraPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      selectedCircle = _getSelectedMarkerCircle(
        cameraPosition.target.latitude,
        cameraPosition.target.longitude,
      );
    });
  }

  Widget _endDrawerComponent() {
    Widget component = endDrawerComponentName == EndDrawerComponentName.markers
        ? MarkerList(
            moveMapCameraTo: _moveCameraTo,
            jouneyId: selectedJouneyId,
          )
        : CreateMarkerBottomSheet(
            jouneyId: selectedJouneyId,
            loadLastSeenJouney: _loadLastSeenJouney,
          );

    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 2),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(10),
          ),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: component,
          ),
        ),
      ),
    );
  }

  Set<Marker> _getAllMarker() {
    Set<Marker> markers = {};
    markers.addAll(checkinMarkers);
    markers.add(userMarker);
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingBtnTheme = theme.floatingActionButtonTheme;
    final textTheme = theme.textTheme;
    var allMarker = _getAllMarker();

    return BlocConsumer<MarkerCubit, MarkerState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                extendBodyBehindAppBar: true,
                appBar: JouneyAppBar(
                  appBarTitle: appBarTitle,
                  markerCount: checkinMarkers.length,
                ),
                drawerScrimColor: Colors.transparent,
                body: _screenContent(
                  state,
                  allMarker,
                  selectedCircle,
                ),
                drawer: Theme(
                  data: theme.copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: JouneyDrawer(),
                ),
                endDrawer: Theme(
                  data: theme.copyWith(
                    canvasColor: Colors.transparent,
                  ),
                  child: _endDrawerComponent(),
                ),
                onEndDrawerChanged: (isOpen) {
                  if (!isOpen) {
                    Future.delayed(
                      const Duration(milliseconds: 500),
                      () => {
                        setState(() {
                          endDrawerComponentName =
                              EndDrawerComponentName.markers;
                        })
                      },
                    );
                  }
                },
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Builder(builder: (context) {
                  if (selectedJouneyId == "") return Container();
                  return FloatingActionButton(
                    heroTag: "endDrawer",
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();

                      setState(() {
                        endDrawerComponentName =
                            EndDrawerComponentName.addMarker;
                      });
                    },
                    elevation: 4.0,
                    child: Icon(
                      Icons.add_location_alt_outlined,
                      size: textTheme.headline6!.fontSize,
                    ),
                    backgroundColor: floatingBtnTheme.backgroundColor,
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
