import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/user.repository.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/screens/splash.screen.dart';

void main() async {
  const isProduction = bool.fromEnvironment('dart.vm.product');
  await DotEnv().load(isProduction ? 'prod.env' : 'dev.env');
  print(API_URL);

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _userRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignInCubit>(
            create: (BuildContext context) => SignInCubit(_userRepository),
          ),
        ],
        child: MaterialApp(
          title: 'WRU-Dev',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
          routes: {
            SignInScreen.routeName: (_) => SignInScreen(),
          },
        ),
      ),
    );
  }
}
