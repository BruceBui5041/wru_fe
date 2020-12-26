import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/auth.repository.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/screens/splash.screen.dart';
import 'package:wru_fe/styles/style.dart' as style;
import 'package:wru_fe/screens/signup.screen.dart';
import 'package:wru_fe/themes/dark.theme.dart' as theme;

void main() async {
  const isProduction = bool.fromEnvironment('dart.vm.product');
  await DotEnv().load(isProduction ? 'prod.env' : 'dev.env');
  print(API_URL);

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignInCubit>(
            create: (BuildContext context) => SignInCubit(_authRepository),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WRU-Dev',
          home: SplashScreen(),
          routes: {
            SignInScreen.routeName: (_) => SignInScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
            SignUpScreen.routeName: (_) => SignUpScreen(),
          },
        ),
      ),
    );
  }
}
