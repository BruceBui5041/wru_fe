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
  final String? message;
  final String? error;
  const SignUpFail({this.message, this.error});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SignUpFail && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
