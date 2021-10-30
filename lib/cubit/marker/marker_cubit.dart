import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/create_marker.dto.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/repositories/makers.repository.dart';

part 'marker_state.dart';

class MarkerCubit extends Cubit<MarkerState> {
  MarkerCubit(this._markerRepository) : super(const MarkerInitial());

  final MarkerRepository _markerRepository;

  Future<void> fetchMarkers(FetchMarkerDto fetchMarkerDto) async {
    emit(const FetchMarker());

    final ResponseDto res = await _markerRepository.fetchMarker(fetchMarkerDto);

    if (res.errorCode != null) {
      emit(FetchMarkersFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        getIt<SignInCubit>().emit(const Unauthorized());
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
      journeyId: fetchMarkerDto.journeyId,
    ));
  }

  Future<void> createMarker(CreateMarkerDto createMarkerDto) async {
    emit(const CreateMarker());

    final ResponseDto res =
        await _markerRepository.createMarker(createMarkerDto);

    if (res.errorCode != null) {
      emit(CreateMarkerFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        getIt<SignInCubit>().emit(const Unauthorized());
      }

      return;
    }

    final dynamic markerJson = res.result['createMarker'] as dynamic;
    final CustomMarker marker =
        CustomMarker.fromJson(markerJson as Map<String, dynamic>);

    emit(CreateMarkerSuccessed(journeyId: marker.journey!.uuid));
  }
}
