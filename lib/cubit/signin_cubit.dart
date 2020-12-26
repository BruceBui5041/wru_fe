import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'package:wru_fe/models/auth.repository.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit(this._authRepository) : super(SignInInitial()) {
    _authRepository.isValidAccessToken().then((authorizedStatus) {
      authorizedStatus ? emit(SignedIn()) : emit(NotSignIn());
    });
  }

  Future<void> signIn(SignInDto signInDto) async {
    emit(SigningIn());
    final resDto = await _authRepository.callSignInApi(signInDto);
    if (resDto.error != null) {
      emit(SignInFail(
        message: resDto.message.toString(),
        error: resDto.error.toString(),
      ));
      return;
    }

    assert(resDto.result != null);
    emit(SignedIn());
    _authRepository.saveAccessToken(resDto.result);
  }
}
