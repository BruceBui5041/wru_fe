import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/user.repository.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/screens/splash.screen.dart';
import 'package:wru_fe/styles/style.dart' as style;
import 'package:wru_fe/screens/signup.screen.dart';

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
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.yellow[700]),
            ),
            cardTheme: style.Style.backgroundCardColor,
            accentIconTheme: style.Style.iconTheme,
            backgroundColor: style.Style.backgroundColor,
            buttonColor: style.Style.buttonColor,
            primaryColor: style.Style.textColor,
            buttonTheme: ButtonThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              buttonColor: Colors.yellow[900],
              hoverColor: Colors.yellow[700],
            ),
            textTheme: TextTheme(
              button: style.Style.buttonBgColor,
              headline4: style.Style.textBody,
              headline5: style.Style.textHeader,
              headline6: style.Style.textLogo,
            ),
          ),
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
