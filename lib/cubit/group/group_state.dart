part of 'group_cubit.dart';

@immutable
abstract class GroupState {
  const GroupState();
}

class GroupInitial extends GroupState {
  const GroupInitial();
}

class GroupFetching extends GroupState {
  const GroupFetching();
}

class GroupFetchSuccess extends GroupState {
  final List<Group> groups;
  const GroupFetchSuccess({this.groups = const []});
}

class GroupFetchFailed extends GroupState {
  final String? error;
  final String? message;
  const GroupFetchFailed({this.error, this.message});
}

class FetchSelectedGroup extends GroupState {
  const FetchSelectedGroup();
}

class FetchSelectedGroupFailed extends GroupState {
  final String? error;
  final String? message;
  const FetchSelectedGroupFailed({this.error, this.message});
}

class FetchSelectedGroupSuccessed extends GroupState {
  final Group group;
  const FetchSelectedGroupSuccessed(this.group);
}

class CreatingNewGroup extends GroupState {
  const CreatingNewGroup();
}

class CreateNewGroupFailed extends GroupState {
  final String? error;
  final String? message;
  const CreateNewGroupFailed({this.error, this.message});
}

class CreateNewGroupSuccessed extends GroupState {
  final Group group;
  const CreateNewGroupSuccessed(this.group);
}
