import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/create_group.dto.dart';
import 'package:wru_fe/dto/create_jouney.dto.dart';
import 'package:wru_fe/dto/fetch_jouney.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/repositories/jouney.repository.dart';

part 'jouney_state.dart';

class JouneyCubit extends Cubit<JouneyState> {
  JouneyCubit(this.jouneyRepository) : super(const JouneyInitial());

  final JouneyRepository jouneyRepository;

  Future<void> fetchJouneys(FetchJouneyDto? fetchJouneyDto) async {
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

class FetchJouneyByIdCubit extends Cubit<FetchJouneyByIdState> {
  FetchJouneyByIdCubit(this.jouneyRepository)
      : super(const FetchJouneyByIdInitial());

  final JouneyRepository jouneyRepository;

  Future<Jouney?> fetchJouneyById(String jouneyId) async {
    emit(const FetchJouneyById());

    final ResponseDto res = await jouneyRepository.fetchJouneyById(jouneyId);

    if (res.errorCode != null) {
      emit(FetchJouneyByIdFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        emit(const Unauthorized());
      }

      return null;
    }

    final dynamic jouneyJson = res.result['jouney'] as dynamic;

    final Jouney jouney = Jouney.fromJson(jouneyJson as Map<String, dynamic>);

    emit(FetchJouneyByIdSuccessed(jouney: jouney));
    return jouney;
  }
}

class CreateJouneyCubit extends Cubit<CreateJouneyState> {
  CreateJouneyCubit(this.jouneyRepository) : super(const CreateJouneyInitial());

  final JouneyRepository jouneyRepository;

  Future<Jouney?> createJouney(CreateJouneyDto createJouneyDto) async {
    emit(const CreateJouney());

    final ResponseDto res =
        await jouneyRepository.createJouney(createJouneyDto);

    if (res.errorCode != null) {
      emit(CreateJouneyFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        emit(const Unauthorized());
      }

      return null;
    }

    final dynamic jouneyJson = res.result['createJouney'] as dynamic;
    final Jouney jouney = Jouney.fromJson(jouneyJson as Map<String, dynamic>);

    emit(CreateJouneySuccessed(jouney: jouney));
    return jouney;
  }
}
