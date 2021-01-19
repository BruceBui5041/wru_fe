import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/signup.dto.dart';
import 'package:wru_fe/models/auth.repository.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(SignUpInitial());

  Future<void> signUp(SignUpDto signUpDto) async {
    emit(SigningUp());
    final resDto = await _authRepository.callSignUpApi(signUpDto);
    if (resDto.errorCode != null) {
      emit(SignUpFail(
        message: resDto.message.toString(),
        error: resDto.errorCode.toString(),
      ));
      return;
    }

    assert(resDto.result != null);
    emit(SignUpSuccessful());
    _authRepository.saveAccessToken(resDto.result);
  }
}
