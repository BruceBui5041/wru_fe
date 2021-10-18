import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/models/user.model.dart';
import 'package:wru_fe/repositories/user.repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository) : super(const UserInitial());

  final UserRepository _userRepository;

  Future<void> searchUsers(String searchQuery) async {
    emit(const SearchUser());

    final ResponseDto res = await _userRepository.searchUser(searchQuery);

    if (res.errorCode != null) {
      emit(SearchUserFailed(
        error: res.errorCode.toString(),
        message: res.message.toString(),
      ));

      if (res.errorCode == 401) {
        emit(const Unauthorized());
      }

      return;
    }

    final usersJson = res.result['searchUsers'] as List<dynamic>;
    final users = usersJson
        .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
        .toList();

    emit(SearchUserSuccessed(users));
  }
}
