import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/widgets/jouney_list.widget.dart';

class JouneyScreen extends StatefulWidget {
  const JouneyScreen({Key? key}) : super(key: key);
  static const routeName = "/jouney-screen";

  @override
  _JouneyScreenState createState() => _JouneyScreenState();
}

class _JouneyScreenState extends State<JouneyScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MarkerCubit>().fetchMarkers(
          FetchMarkerDto(jouneyId: "2673a2f7-aaf2-444b-a8f5-cec3d52e9b9e"),
        );
  }

  Widget _generateGroupListWidget(List<Marker> markers) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final Marker marker = markers[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(marker.lat.toString()),
            Text(marker.lng.toString()),
            Text(marker.name ?? ""),
            Text(marker.createdAt ?? ""),
          ],
        );
      },
      itemCount: markers.length,
    );
  }

  Widget _screenContent(MarkerState state) {
    if (state is FetchMarkersFailed) {
      return Text(state.message.toString());
    } else if (state is FetchMarkersSuccessed) {
      return _generateGroupListWidget(state.markers);
    } else {
      return const Text("Loading ...");
    }
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
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            child: _screenContent(state),
          ),
          drawer: const Drawer(
            child: JouneyList(),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Text(
              'Marker',
              style: TextStyle(fontSize: textTheme.headline4!.fontSize),
            ),
            icon: Icon(
              Icons.add,
              size: textTheme.headline4!.fontSize,
            ),
            backgroundColor: floatingBtnTheme.backgroundColor,
          ),
        );
      },
    );
  }
}
