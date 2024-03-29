import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/signin.screen.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = "/splash-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignedIn) {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          } else if (state is NotSignIn) {
            Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
          }
        },
        child: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
