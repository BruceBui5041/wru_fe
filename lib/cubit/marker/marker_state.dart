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
  const FetchMarkersSuccessed({this.markers = const [], this.journeyId});

  final String? journeyId;
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
  const CreateMarkerSuccessed({this.journeyId});
  final String? journeyId;
}

class CreateMarkerFailed extends MarkerState {
  const CreateMarkerFailed({this.error, this.message});
  final String? error;
  final String? message;
}
