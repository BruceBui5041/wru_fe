import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/repositories/makers.repository.dart';

part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  MarkerCubit(this.markerRepository) : super(const MarkerInitial());

  final MarkerRepository markerRepository;

  Future<void> fetchMarkers(FetchMarkerDto fetchMarkerDto) async {
    emit(const FetchMarker());

    final ResponseDto res = await markerRepository.fetchMarker(fetchMarkerDto);

    if (res.errorCode != null) {
      emit(FetchMarkersFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        emit(const Unauthorized());
      }

      return;
    }

    final List<dynamic> markersJson = res.result['markers'] as List<dynamic>;

    final List<Marker> markers = markersJson
        .map((groupJson) => Marker.fromJson(groupJson as Map<String, dynamic>))
        .toList();

    emit(FetchMarkersSuccessed(markers: markers));
  }
}
