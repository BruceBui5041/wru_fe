import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/create_group.dto.dart';
import 'package:wru_fe/dto/fetch_group.dto.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/models/user.model.dart';
import 'package:wru_fe/repositories/group.repository.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit(this.groupRepository) : super(const GroupInitial());

  final GroupRepository groupRepository;

  Future<void> fetchGroups(FetchGroupDto fetchGroupDto) async {
    emit(const GroupFetching());

    final ResponseDto res = await groupRepository.fetchGroup(fetchGroupDto);

    if (res.errorCode != null) {
      emit(GroupFetchFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        emit(const Unauthorized());
      }

      return;
    }

    final List<dynamic> groupsJson =
        res.result['fetchMyGroups'] as List<dynamic>;

    final List<Group> groups = groupsJson
        .map((groupJson) => Group.fromJson(groupJson as Map<String, dynamic>))
        .toList();

    emit(GroupFetchSuccess(groups: groups));
  }

  Future<void> fetchSelectedGroup(FetchGroupDto fetchGroupDto) async {
    emit(const FetchSelectedGroup());

    final ResponseDto res = await groupRepository.fetchGroup(fetchGroupDto);

    if (res.errorCode != null) {
      emit(FetchSelectedGroupFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));
    }

    final List<dynamic> groupsJson =
        res.result['fetchMyGroups'] as List<dynamic>;

    final List<Group> groups = groupsJson
        .map((groupJson) => Group.fromJson(groupJson as Map<String, dynamic>))
        .toList();

    print(groups[0].owner!.profile);
    emit(FetchSelectedGroupSuccessed(groups[0]));
  }

  Future<void> createGroup(CreateGroupDto input) async {
    emit(const CreatingNewGroup());

    final ResponseDto res = await groupRepository.createGroup(input);

    if (res.errorCode != null) {
      emit(CreateNewGroupFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));
    }

    final Map<String, dynamic> groupJson =
        res.result['createGroup'] as Map<String, dynamic>;

    final Group group = Group.fromJson(groupJson);
    emit(CreateNewGroupSuccessed(group));
  }
}
