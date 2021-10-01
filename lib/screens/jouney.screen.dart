import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/enums.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/create_marker_drawer.widget.dart';
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
  _JouneyScreenState({this.lastKnowUserLocation});
  Completer<GoogleMapController> _controller = Completer();

  double initialZoom = 14.4746;
  Set<Marker> checkinMarkers = {};
  Set<Marker> allMarker = {};
  Marker userMarker = Marker(
    markerId: MarkerId("userLocationId"),
    visible: false,
  );
  String selectedJouneyId = "";
  String appBarTitle = "";
  EndDrawerComponentName endDrawerComponentName =
      EndDrawerComponentName.markers;

  Position? lastKnowUserLocation;

  @override
  void initState() {
    super.initState();
    loadLastSeenJouney();
    loadUserLocation();
  }

  void loadLastSeenJouney() async {
    dynamic lastSeenJouneyId = getValueFromStore(LAST_SEEN_JOUNEY);
    if (lastSeenJouneyId != null) {
      var jouney = await context
          .read<JouneyCubit>()
          .fetchJouneyById(lastSeenJouneyId.toString());

      if (jouney != null) {
        _setAppBarTitle(jouney.name);

        var markers = _generateGGCheckinMakers(
          jouney.markers as List<CustomMarker>,
        );

        setState(() {
          selectedJouneyId = jouney.uuid.toString();
          checkinMarkers = markers;
        });
      }
    }
  }

  void loadUserLocation() async {
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

  Widget _screenContent(MarkerState state, Set<Marker> allMarker) {
    double lat =
        lastKnowUserLocation != null ? lastKnowUserLocation!.latitude : 0;
    double lng =
        lastKnowUserLocation != null ? lastKnowUserLocation!.longitude : 0;

    var initCameraPosition = CameraPosition(
      target: LatLng(lat, lng),
    );

    return GoogleMap(
      mapType: MapType.normal,
      markers: allMarker,
      initialCameraPosition: initCameraPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> _moveCameraTo(CameraPosition cameraPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Widget _endDrawerComponent() {
    Widget component = endDrawerComponentName == EndDrawerComponentName.markers
        ? MarkerList(
            moveMapCameraTo: _moveCameraTo,
          )
        : CreateMarkerBottomSheet(
            jouneyId: selectedJouneyId,
          );
    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 2),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
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

  void _updateMapMarkers(List<CustomMarker> markers) {
    if (markers.length > 0) {
      final lastMarker = markers[0];
      double lat = lastMarker.lat as double;
      double lng = lastMarker.lng as double;
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: initialZoom,
      );
      _moveCameraTo(cameraPosition);
    }

    setState(() {
      checkinMarkers = _generateGGCheckinMakers(markers);
    });
  }

  void _setAppBarTitle(String? title) {
    setState(() {
      appBarTitle = title ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingBtnTheme = theme.floatingActionButtonTheme;
    final textTheme = theme.textTheme;
    var allMarker = checkinMarkers..add(userMarker);

    return BlocConsumer<MarkerCubit, MarkerState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        } else if (state is FetchMarkersSuccessed) {
          _updateMapMarkers(state.markers);
          setState(() {
            selectedJouneyId = state.jouneyId as String;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                appBarTitle,
                style: TextStyle(
                  fontSize: textTheme.headline5!.fontSize,
                ),
              ),
            ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.room),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
            ],
          ),
          body: _screenContent(state, allMarker),
          drawer: Drawer(
            child: JouneyList(
              setAppbarTitle: _setAppBarTitle,
            ),
          ),
          endDrawer: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors
                  .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: _endDrawerComponent(),
          ),
          onEndDrawerChanged: (isOpen) {
            if (!isOpen) {
              Future.delayed(
                const Duration(milliseconds: 500),
                () => {
                  setState(() {
                    endDrawerComponentName = EndDrawerComponentName.markers;
                  })
                },
              );
            }
          },
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();

                setState(() {
                  endDrawerComponentName = EndDrawerComponentName.addMarker;
                });
              },
              elevation: 4.0,
              child: Icon(
                Icons.add,
                size: textTheme.headline5!.fontSize,
              ),
              backgroundColor: floatingBtnTheme.backgroundColor,
            );
          }),
        );
      },
    );
  }
}
