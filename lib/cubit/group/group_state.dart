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
  const GroupFetchSuccess({this.groups = const []});
  final List<Group> groups;
}

class GroupFetchFailed extends GroupState {
  const GroupFetchFailed({this.error, this.message});
  final String? error;
  final String? message;
}

class FetchSelectedGroup extends GroupState {
  const FetchSelectedGroup();
}

class FetchSelectedGroupFailed extends GroupState {
  const FetchSelectedGroupFailed({this.error, this.message});
  final String? error;
  final String? message;
}

class FetchSelectedGroupSuccessed extends GroupState {
  const FetchSelectedGroupSuccessed(this.group);
  final Group group;
}

class CreatingNewGroup extends GroupState {
  const CreatingNewGroup();
}

class CreateNewGroupFailed extends GroupState {
  const CreateNewGroupFailed({this.error, this.message});
  final String? error;
  final String? message;
}

class CreateNewGroupSuccessed extends GroupState {
  const CreateNewGroupSuccessed(this.group);
  final Group group;
}

class FetchingMembers extends GroupState {
  const FetchingMembers();
}

class FetchingMembersSuccessed extends GroupState {
  const FetchingMembersSuccessed({this.members = const []});
  final List<User> members;
}

class FetchingMembersFailed extends GroupState {
  const FetchingMembersFailed({this.error, this.message});
  final String? error;
  final String? message;
}

class Unauthorized extends GroupState {
  const Unauthorized();
}
