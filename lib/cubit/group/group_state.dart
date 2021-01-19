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

class GroupFetched extends GroupState {
  final dynamic data;
  const GroupFetched({this.data});
}

class GroupFetchSuccess extends GroupState {
  const GroupFetchSuccess();
}

class GroupFetchFailed extends GroupState {
  final String error;
  final String message;
  const GroupFetchFailed({this.error, this.message});
}
