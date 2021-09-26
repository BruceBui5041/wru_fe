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

class Unauthorized extends JouneyState {
  const Unauthorized();
}
