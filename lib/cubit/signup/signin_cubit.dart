import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/journey/journey_cubit.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/user/user_cubit.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'package:wru_fe/repositories/auth.repository.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepository) : super(const SignInInitial()) {
    _authRepository.isValidAccessToken().then((bool authorizedStatus) {
      authorizedStatus ? emit(const SignedIn()) : emit(const NotSignIn());
    }).catchError((dynamic error) {
      print(error);
    });
  }

  final AuthRepository _authRepository;

  Future<void> signIn(SignInDto signInDto) async {
    emit(const SigningIn());
    final ResponseDto resDto = await _authRepository.callSignInApi(signInDto);
    if (resDto.errorCode != null) {
      emit(SignInFail(
        message: resDto.message.toString(),
        error: resDto.errorCode.toString(),
      ));
      return;
    }

    assert(resDto.result != null);
    emit(const SignedIn());
    _authRepository.saveAccessToken(resDto.result.toString());
  }
}
