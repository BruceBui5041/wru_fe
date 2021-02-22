import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/create_group.dto.dart';
import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/models/group.repository.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository groupRepository;
  GroupCubit(this.groupRepository) : super(GroupInitial());

  void fetchGroups({bool own = false}) async {
    emit(GroupFetching());

    var res = await groupRepository.fetchGroup(own);

    if (res.errorCode != null) {
      emit(GroupFetchFailed(error: res.errorCode, message: res.message));
    }

    var groupsJson = res.result['fetchMyGroups'] as List;
    List<Group> groups =
        groupsJson.map((groupJson) => Group.fromJson(groupJson)).toList();

    emit(GroupFetchSuccess(groups: groups));
  }

  void createGroup(CreateGroupDto input) async {
    emit(CreatingNewGroup());

    var res = await groupRepository.createGroup(input);

    if (res.errorCode != null) {
      emit(CreateNewGroupFailed(error: res.errorCode, message: res.message));
    }

    var groupJson = res.result['createGroup'];
    Group group = Group.fromJson(groupJson);
    emit(CreateNewGroupSuccessed(group));
  }
}
