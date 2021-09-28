import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/repositories/jouney.repository.dart';

part 'jouney_state.dart';

class JouneyCubit extends Cubit<JouneyState> {
  JouneyCubit(this.jouneyRepository) : super(const JouneyInitial());

  final JouneyRepository jouneyRepository;

  Future<void> fetchJouneys(FetchJouneyDto fetchJouneyDto) async {
    emit(const FetchingJouney());

    final ResponseDto res = await jouneyRepository.fetchJouney(fetchJouneyDto);

    if (res.errorCode != null) {
      emit(FetchJouneysFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        emit(const Unauthorized());
      }

      return;
    }

    final List<dynamic> jouneysJson = res.result['jouneys'] as List<dynamic>;

    final List<Jouney> jouneys = jouneysJson
        .map((groupJson) => Jouney.fromJson(groupJson as Map<String, dynamic>))
        .toList();

    emit(FetchJouneysSuccessed(jouneys: jouneys));
  }
}
