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
  const GroupFetchSuccess({this.groups});
}

class GroupFetchFailed extends GroupState {
  final String error;
  final String message;
  const GroupFetchFailed({this.error, this.message});
}
