part of 'journey_cubit.dart';

@immutable
abstract class JourneyState {
  const JourneyState();
}

class JourneyInitial extends JourneyState {
  const JourneyInitial();
}

class FetchingJourney extends JourneyState {
  const FetchingJourney();
}

class FetchJourneysSuccessed extends JourneyState {
  const FetchJourneysSuccessed({this.journeys = const []});
  final List<Journey> journeys;
}

class FetchJourneysFailed extends JourneyState {
  const FetchJourneysFailed({this.error, this.message});
  final String? error;
  final String? message;
}

@immutable
abstract class FetchJourneyByIdState {
  const FetchJourneyByIdState();
}

class FetchJourneyByIdInitial extends FetchJourneyByIdState {
  const FetchJourneyByIdInitial();
}

class FetchJourneyById extends FetchJourneyByIdState {
  const FetchJourneyById();
}

class FetchJourneyByIdSuccessed extends FetchJourneyByIdState {
  const FetchJourneyByIdSuccessed({required this.journey});
  final Journey journey;
}

class FetchJourneyByIdFailed extends FetchJourneyByIdState {
  const FetchJourneyByIdFailed({this.error, this.message});
  final String? error;
  final String? message;
}

@immutable
abstract class CreateJourneyState {
  const CreateJourneyState();
}

class CreateJourneyInitial extends CreateJourneyState {
  const CreateJourneyInitial();
}

class CreateJourney extends CreateJourneyState {
  const CreateJourney();
}

class CreateJourneySuccessed extends CreateJourneyState {
  const CreateJourneySuccessed({required this.journey});
  final Journey journey;
}

class CreateJourneyFailed extends CreateJourneyState {
  const CreateJourneyFailed({this.error, this.message});
  final String? error;
  final String? message;
}

@immutable
abstract class UpdateJourneyState {
  const UpdateJourneyState();
}

class UpdateJourneyInitial extends UpdateJourneyState {
  const UpdateJourneyInitial();
}

class UpdateJourney extends UpdateJourneyState {
  const UpdateJourney();
}

class UpdateJourneySuccessed extends UpdateJourneyState {
  const UpdateJourneySuccessed({required this.journey});
  final Journey journey;
}

class UpdateJourneyFailed extends UpdateJourneyState {
  const UpdateJourneyFailed({this.error, this.message});
  final String? error;
  final String? message;
}
