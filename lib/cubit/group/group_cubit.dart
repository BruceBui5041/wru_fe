import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';

import 'package:wru_fe/models/auth.repository.dart';
import 'package:wru_fe/models/group.repository.dart';

part 'group_state.dart';

class GroupCubit extends Cubit<GroupState> {
  final AuthRepository _authRepository;
  final GroupRepository groupRepository;

  GroupCubit(this._authRepository, this.groupRepository)
      : super(GroupInitial()) {
    _authRepository.isValidAccessToken().then((authorizedStatus) {
      if (authorizedStatus) {
        emit(GroupFetchSuccess());
      } else {
        emit(GroupFetchFailed());
      }
    });
  }

  // ignore: missing_return
  Future<GroupState> fetchGroup() async {
    var res = await groupRepository.fetchGroup();
    emit(GroupFetchSuccess());
    emit(GroupFetched(data: res));
  }
}
