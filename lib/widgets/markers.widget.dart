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
    required this.jouneyId,
  }) : super(key: key);

  final String jouneyId;
  final Function(CameraPosition cameraPosition) moveMapCameraTo;

  @override
  _MarkerListState createState() => _MarkerListState();
}

class _MarkerListState extends State<MarkerList> {
  @override
  void initState() {
    context
        .read<MarkerCubit>()
        .fetchMarkers(FetchMarkerDto(jouneyId: widget.jouneyId));

    super.initState();
  }

  Widget _generateJouneyListWidget(
    List<CustomMarker> markers,
    Function(CameraPosition cameraPosition) moveMapCameraTo,
  ) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final CustomMarker marker = markers[index];

        return MarkerItem(
          key: Key(marker.uuid.toString()),
          marker: marker,
          moveMapCameraTo: moveMapCameraTo,
        );
      },
      itemCount: markers.length,
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
          return _generateJouneyListWidget(
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
