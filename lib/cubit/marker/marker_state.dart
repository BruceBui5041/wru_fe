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
  const FetchMarkersSuccessed({this.markers = const [], this.jouneyId});

  final String? jouneyId;
  final List<CustomMarker> markers;
}

class FetchMarkersFailed extends MarkerState {
  const FetchMarkersFailed({this.error, this.message});
  final String? error;
  final String? message;
}

class CreateMarker extends MarkerState {
  const CreateMarker();
}

class CreateMarkerSuccessed extends MarkerState {
  const CreateMarkerSuccessed();
}

class CreateMarkerFailed extends MarkerState {
  const CreateMarkerFailed({this.error, this.message});
  final String? error;
  final String? message;
}
