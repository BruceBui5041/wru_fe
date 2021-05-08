import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/response.dto.dart';
import 'package:wru_fe/dto/signup.dto.dart';
import 'package:wru_fe/models/auth.repository.dart';

part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpInitial());

  final AuthRepository _authRepository;

  Future<void> signUp(SignUpDto signUpDto) async {
    emit(const SigningUp());
    final ResponseDto resDto = await _authRepository.callSignUpApi(signUpDto);
    if (resDto.errorCode != null) {
      emit(SignUpFail(
        message: resDto.message.toString(),
        error: resDto.errorCode.toString(),
      ));
      return;
    }

    assert(resDto.result != null);
    emit(const SignUpSuccessful());
    _authRepository.saveAccessToken(resDto.result.toString());
  }
}
