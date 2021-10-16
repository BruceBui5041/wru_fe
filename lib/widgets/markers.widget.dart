import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/widgets/marker.widget.dart';

class MarkerList extends StatefulWidget {
  const MarkerList({
    Key? key,
    required this.moveMapCameraTo,
    required this.journeyId,
  }) : super(key: key);

  final String journeyId;
  final Function(CameraPosition cameraPosition) moveMapCameraTo;

  @override
  _MarkerListState createState() => _MarkerListState();
}

class _MarkerListState extends State<MarkerList> {
  @override
  void initState() {
    context
        .read<MarkerCubit>()
        .fetchMarkers(FetchMarkerDto(journeyId: widget.journeyId));

    super.initState();
  }

  Widget _generateJourneyListWidget(
    List<CustomMarker> markers,
    Function(CameraPosition cameraPosition) moveMapCameraTo,
  ) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final CustomMarker marker = markers[index];

        return Stack(
          children: [
            MarkerItem(
              key: Key(marker.uuid.toString()),
              marker: marker,
              moveMapCameraTo: moveMapCameraTo,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _chip(
                  const Icon(
                    Icons.edit_location_alt_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                  () {
                    print(marker.uuid);
                  },
                ),
              ],
            )
          ],
        );
      },
      itemCount: markers.length,
    );
  }

  Widget _chip(Icon icon, Function() onClick) {
    return InkWell(
      onTap: onClick,
      splashColor: Colors.brown.withOpacity(0.5),
      child: Badge(
        toAnimate: false,
        shape: BadgeShape.square,
        borderRadius: BorderRadius.circular(8),
        badgeColor: Colors.purple,
        badgeContent: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarkerCubit, MarkerState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        if (state is FetchMarkersSuccessed) {
          return _generateJourneyListWidget(
            state.markers,
            widget.moveMapCameraTo,
          );
        } else {
          return const Text("Loading ...");
        }
      },
    );
  }
}
