part of 'user_cubit.dart';

@immutable
abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class SearchUser extends UserState {
  const SearchUser();
}

class SearchUserSuccessed extends UserState {
  const SearchUserSuccessed(this.users);
  final List<User> users;
}

class SearchUserFailed extends UserState {
  const SearchUserFailed({this.error, this.message});
  final String? error;
  final String? message;
}
