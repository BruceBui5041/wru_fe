part of 'member_cubit.dart';

@immutable
abstract class MemberState {
  const MemberState();
}

class MemberInitial extends MemberState {
  const MemberInitial();
}

class FetchingMembers extends MemberState {
  const FetchingMembers();
}

class FetchingMembersSuccessed extends MemberState {
  const FetchingMembersSuccessed({this.members = const []});
  final List<User> members;
}

class FetchingMembersFailed extends MemberState {
  const FetchingMembersFailed({this.error, this.message});
  final String? error;
  final String? message;
}
