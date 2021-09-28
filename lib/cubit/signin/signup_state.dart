part of 'signup_cubit.dart';

@immutable
abstract class SignUpState {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SigningUp extends SignUpState {
  const SigningUp();
}

class SignUpSuccessful extends SignUpState {
  const SignUpSuccessful();
}

class SignUpFail extends SignUpState {
  const SignUpFail({this.message, this.error});

  final String? message;
  final String? error;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SignUpFail && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class Unauthorized extends SignUpState {
  const Unauthorized();
}
