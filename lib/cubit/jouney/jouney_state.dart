part of 'jouney_cubit.dart';

@immutable
abstract class JouneyState {
  const JouneyState();
}

class JouneyInitial extends JouneyState {
  const JouneyInitial();
}

class FetchingJouney extends JouneyState {
  const FetchingJouney();
}

class FetchJouneysSuccessed extends JouneyState {
  const FetchJouneysSuccessed({this.jouneys = const []});
  final List<Jouney> jouneys;
}

class FetchJouneysFailed extends JouneyState {
  const FetchJouneysFailed({this.error, this.message});
  final String? error;
  final String? message;
}

@immutable
abstract class FetchJouneyByIdState {
  const FetchJouneyByIdState();
}

class FetchJouneyByIdInitial extends FetchJouneyByIdState {
  const FetchJouneyByIdInitial();
}

class FetchJouneyById extends FetchJouneyByIdState {
  const FetchJouneyById();
}

class FetchJouneyByIdSuccessed extends FetchJouneyByIdState {
  const FetchJouneyByIdSuccessed({required this.jouney});
  final Jouney jouney;
}

class FetchJouneyByIdFailed extends FetchJouneyByIdState {
  const FetchJouneyByIdFailed({this.error, this.message});
  final String? error;
  final String? message;
}

@immutable
abstract class CreateJouneyState {
  const CreateJouneyState();
}

class CreateJouneyInitial extends CreateJouneyState {
  const CreateJouneyInitial();
}

class CreateJouney extends CreateJouneyState {
  const CreateJouney();
}

class CreateJouneySuccessed extends CreateJouneyState {
  const CreateJouneySuccessed({required this.jouney});
  final Jouney jouney;
}

class CreateJouneyFailed extends CreateJouneyState {
  const CreateJouneyFailed({this.error, this.message});
  final String? error;
  final String? message;
}
