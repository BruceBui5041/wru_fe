import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/models/group.repository.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository groupRepository;

  GroupCubit(this.groupRepository) : super(GroupInitial());

  Future<GroupState> fetchGroup() async {
    var res = await groupRepository.fetchGroup();
    var groupsJson = res.result['fetchMyGroups'] as List;
    List<Group> groups =
        groupsJson.map((tagJson) => Group.fromJson(tagJson)).toList();

    emit(GroupFetchSuccess(groups: groups));
  }
}
