import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/signin.dto.dart';
import 'package:wru_fe/models/user.repository.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final UserRepository _userRepository;

  SignInCubit(this._userRepository) : super(SignInInitial()) {
    _userRepository.isValidAccessToken().then((authorizedStatus) {
      authorizedStatus ? emit(SignedIn()) : emit(NotSignIn());
    });
  }

  Future<void> signIn(SignInDto signInDto) async {
    emit(SigningIn(signInDto));
    final resDto = await _userRepository.callSignInApi(signInDto);
    if (resDto.error != null) {
      emit(SignInFail(resDto.message.toString()));
      return;
    }

    assert(resDto.result != null);
    emit(SignedIn());
    _userRepository.saveAccessToken(resDto.result);
  }
}
