part of 'marker_cubit.dart';

@immutable
abstract class MarkerState {
  const MarkerState();
}

class MarkerInitial extends MarkerState {
  const MarkerInitial();
}

class FetchMarker extends MarkerState {
  const FetchMarker();
}

class FetchMarkersSuccessed extends MarkerState {
  const FetchMarkersSuccessed({this.markers = const []});
  final List<Marker> markers;
}

class FetchMarkersFailed extends MarkerState {
  const FetchMarkersFailed({this.error, this.message});
  final String? error;
  final String? message;
}

class Unauthorized extends MarkerState {
  const Unauthorized();
}
