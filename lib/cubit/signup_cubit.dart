import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wru_fe/dto/signup.dto.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignUpState> {
  SignupCubit() : super(SignUpInitial());

  Future<void> signUp(SignUpDto signUpDto) async {
    emit(SigningUp());
  }
}
