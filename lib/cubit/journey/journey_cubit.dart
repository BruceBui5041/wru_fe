import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/create_group.dto.dart';
import 'package:wru_fe/dto/create_jouney.dto.dart';
import 'package:wru_fe/dto/fetch_journey.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/share_journey.dto.dart';
import 'package:wru_fe/dto/update_journey.dto.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/models/shared_journey.model.dart';
import 'package:wru_fe/repositories/journey.repository.dart';

part 'journey_state.dart';

class JourneyCubit extends Cubit<JourneyState> {
  JourneyCubit(this.journeyRepository) : super(const JourneyInitial());

  final JourneyRepository journeyRepository;

  Future<void> fetchJourneys(FetchJourneyDto? fetchJourneyDto) async {
    emit(const FetchingJourney());

    final ResponseDto res =
        await journeyRepository.fetchJourney(fetchJourneyDto);

    if (res.errorCode != null) {
      emit(FetchJourneysFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        getIt<SignInCubit>().emit(const Unauthorized());
      }

      return;
    }

    final List<dynamic> journeysJson = res.result['jouneys'] as List<dynamic>;

    final List<Journey> journeys = journeysJson
        .map((groupJson) => Journey.fromJson(groupJson as Map<String, dynamic>))
        .toList();

    emit(FetchJourneysSuccessed(journeys: journeys));
  }
}

class FetchJourneyByIdCubit extends Cubit<FetchJourneyByIdState> {
  FetchJourneyByIdCubit(this.journeyRepository)
      : super(const FetchJourneyByIdInitial());

  final JourneyRepository journeyRepository;

  Future<Journey?> fetchJourneyById(
    String journeyId, {
    bool details = false,
  }) async {
    emit(const FetchJourneyById());

    final ResponseDto res = await (details
        ? journeyRepository.fetchJourneyDetailsById(journeyId)
        : journeyRepository.fetchJourneyById(journeyId));

    if (res.errorCode != null) {
      emit(FetchJourneyByIdFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        getIt<SignInCubit>().emit(const Unauthorized());
      }

      return null;
    }

    final dynamic journeyJson = res.result['jouney'] as dynamic;

    final Journey journey =
        Journey.fromJson(journeyJson as Map<String, dynamic>);

    emit(FetchJourneyByIdSuccessed(journey: journey));
    return journey;
  }
}

class CreateJourneyCubit extends Cubit<CreateJourneyState> {
  CreateJourneyCubit(this.journeyRepository)
      : super(const CreateJourneyInitial());

  final JourneyRepository journeyRepository;

  Future<Journey?> createJourney(CreateJourneyDto createJourneyDto) async {
    emit(const CreateJourney());

    final ResponseDto res =
        await journeyRepository.createJourney(createJourneyDto);

    if (res.errorCode != null) {
      emit(CreateJourneyFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        getIt<SignInCubit>().emit(const Unauthorized());
      }

      return null;
    }

    final dynamic journeyJson = res.result['createJouney'] as dynamic;
    final Journey journey =
        Journey.fromJson(journeyJson as Map<String, dynamic>);

    emit(CreateJourneySuccessed(journey: journey));
    return journey;
  }
}

class UpdateJourneyCubit extends Cubit<UpdateJourneyState> {
  UpdateJourneyCubit(this.journeyRepository)
      : super(const UpdateJourneyInitial());

  final JourneyRepository journeyRepository;

  Future<Journey?> updateJourney(UpdateJourneyDto updateJourneyDto) async {
    emit(const UpdateJourney());

    final ResponseDto res =
        await journeyRepository.updateJourney(updateJourneyDto);

    if (res.errorCode != null) {
      emit(UpdateJourneyFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        getIt<SignInCubit>().emit(const Unauthorized());
      }

      return null;
    }

    final dynamic journeyJson = res.result['updateJouney'] as dynamic;
    final Journey journey =
        Journey.fromJson(journeyJson as Map<String, dynamic>);

    emit(UpdateJourneySuccessed(journey: journey));
    return journey;
  }
}

class ShareJourneyCubit extends Cubit<ShareJourneyState> {
  ShareJourneyCubit(this.journeyRepository)
      : super(const ShareJourneyInitial());

  final JourneyRepository journeyRepository;

  Future<SharedJourney?> shareJourney(ShareJourneyDto shareJourneyDto) async {
    emit(const ShareJourney());

    final ResponseDto res =
        await journeyRepository.shareJourney(shareJourneyDto);

    if (res.errorCode != null) {
      emit(ShareJourneyFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        getIt<SignInCubit>().emit(const Unauthorized());
      }

      return null;
    }

    final dynamic journeyJson = res.result['shareJouney'] as dynamic;
    final SharedJourney sharedJourney =
        SharedJourney.fromJson(journeyJson as Map<String, dynamic>);

    emit(ShareJourneySuccessed(sharedJourney: sharedJourney));
    return sharedJourney;
  }
}
