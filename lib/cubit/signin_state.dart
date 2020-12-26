part of 'signin_cubit.dart';

@immutable
abstract class SignInState {
  const SignInState();
}

class SignInInitial extends SignInState {
  const SignInInitial();
}

class NotSignIn extends SignInState {
  const NotSignIn();
}

class SigningIn extends SignInState {
  const SigningIn();
}

class SignedIn extends SignInState {
  const SignedIn();
}

class SignInFail extends SignInState {
  final String message;
  const SignInFail(this.message);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SignInFail && o.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
