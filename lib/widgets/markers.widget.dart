import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/widgets/marker.widget.dart';

class MarkerList extends StatefulWidget {
  const MarkerList({
    Key? key,
    required this.moveMapCameraTo,
  }) : super(key: key);

  final Function(CustomMarker marker) moveMapCameraTo;

  @override
  _MarkerListState createState() => _MarkerListState();
}

class _MarkerListState extends State<MarkerList> {
  Widget _generateJouneyListWidget(
    List<CustomMarker> markers,
    Function(CustomMarker marker) moveMapCameraTo,
  ) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final CustomMarker marker = markers[index];
        if (index == 0) {
          return Column(
            children: [
              Container(
                height: 50,
                child: const Text("Drawer header"),
              ),
              MarkerItem(
                marker: marker,
                moveMapCameraTo: moveMapCameraTo,
              ),
            ],
          );
        }
        return MarkerItem(
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
