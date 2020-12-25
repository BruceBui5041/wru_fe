import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/user.repository.dart';
import 'package:wru_fe/screens/home.screen.dart';
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
          debugShowCheckedModeBanner: false,
          title: 'WRU-Dev',
          theme: ThemeData(
            cardTheme: CardTheme(color: Colors.blueGrey[700]),
            accentIconTheme: IconThemeData(color: Colors.yellow[700]),
            accentColor: Colors.yellow[700],
            backgroundColor: Colors.grey[900],
            buttonColor: Colors.yellow[700],
            // buttonTheme: ButtonThemeData(
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20.0)),
            //   buttonColor: Colors.yellow[900],
            // ),
            textTheme: TextTheme(
              button: TextStyle(color: Colors.grey[900]),
              headline1: TextStyle(color: Colors.yellow[700]),
              headline4: TextStyle(color: Colors.yellow[700]),
            ),
          ),
          home: SplashScreen(),
          routes: {
            SignInScreen.routeName: (_) => SignInScreen(),
            HomeScreen.routeName: (_) => HomeScreen(),
          },
        ),
      ),
    );
  }
}
