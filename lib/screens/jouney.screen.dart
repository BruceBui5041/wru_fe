import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/enums.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/widgets/create_marker_drawer.widget.dart';
import 'package:wru_fe/widgets/jouneys.widget.dart';
import 'package:wru_fe/widgets/markers.widget.dart';

class JouneyScreen extends StatefulWidget {
  const JouneyScreen({Key? key}) : super(key: key);
  static const routeName = "/jouney-screen";

  @override
  _JouneyScreenState createState() => _JouneyScreenState();
}

class _JouneyScreenState extends State<JouneyScreen> {
  Completer<GoogleMapController> _controller = Completer();

  double initialZoom = 14.4746;
  Set<Marker> mapMarkers = {};
  String selectedJouneyId = "";
  EndDrawerComponentName endDrawerComponentName =
      EndDrawerComponentName.markers;
  // TODO Use user location for this
  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
  }

  Set<Marker> _generateGGMaker(List<CustomMarker> markers) {
    Set<Marker> newMarkers = {};
    for (CustomMarker appMarker in markers) {
      double latitude = appMarker.lat as double;
      double longitude = appMarker.lng as double;
      MarkerId markerId = MarkerId(appMarker.uuid.toString());
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(latitude, longitude),
      );
      newMarkers.add(marker);
    }
    return newMarkers;
  }

  Widget _screenContent(MarkerState state) {
    if (state is FetchMarkersFailed) {
      return Text(state.message.toString());
    } else if (state is FetchMarkersSuccessed) {
      return GoogleMap(
        mapType: MapType.normal,
        markers: mapMarkers,
        initialCameraPosition: kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      );
    } else {
      return const Text("Loading ...");
    }
  }

  Future<void> _moveCameraTo(CustomMarker marker) async {
    double latitude = marker.lat as double;
    double longitude = marker.lng as double;

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: initialZoom,
    )));
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

  void _updateMapData(List<CustomMarker> markers) {
    if (markers.length > 0) {
      final lastMarker = markers[0];
      _moveCameraTo(lastMarker);
    }

    setState(() {
      mapMarkers = _generateGGMaker(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingBtnTheme = theme.floatingActionButtonTheme;
    final textTheme = theme.textTheme;
    return BlocConsumer<MarkerCubit, MarkerState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        } else if (state is FetchMarkersSuccessed) {
          _updateMapData(state.markers);
          setState(() {
            selectedJouneyId = state.jouneyId as String;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: GoogleMap(
            mapType: MapType.normal,
            markers: mapMarkers,
            initialCameraPosition: kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          drawer: const Drawer(
            child: JouneyList(),
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
