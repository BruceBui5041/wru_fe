import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/create_marker.dto.dart';
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

    final List<CustomMarker> markers = markersJson
        .map((groupJson) =>
            CustomMarker.fromJson(groupJson as Map<String, dynamic>))
        .toList();

    emit(FetchMarkersSuccessed(
      markers: markers,
      jouneyId: fetchMarkerDto.jouneyId,
    ));
  }

  Future<void> createMarker(CreateMarkerDto createMarkerDto) async {
    emit(const CreateMarker());

    final ResponseDto res =
        await markerRepository.createMarker(createMarkerDto);

    if (res.errorCode != null) {
      emit(CreateMarkerFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        emit(const Unauthorized());
      }

      return;
    }

    // final List<dynamic> markersJson = res.result['markers'] as List<dynamic>;

    // final CustomMarker marker =
    //     CustomMarker.fromJson(markersJson as Map<String, dynamic>);

    emit(const CreateMarkerSuccessed());
  }
}
