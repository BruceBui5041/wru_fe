import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wru_fe/api/graphql/graphql.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/cubit/signup_cubit.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/auth.repository.dart';
import 'package:wru_fe/models/group.repository.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/screens/signup.screen.dart';
import 'package:wru_fe/themes/light.theme.dart';

void main() async {
  const isProduction = bool.fromEnvironment('dart.vm.product');
  await DotEnv().load(isProduction ? 'prod.env' : 'dev.env');
  print(API_URL);

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();
  final GroupRepository _groupRepository =
      GroupRepository(client: GraphQLUtil.client());

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SignInCubit>(
            create: (BuildContext context) => SignInCubit(_authRepository),
          ),
          BlocProvider<SignUpCubit>(
            create: (BuildContext context) => SignUpCubit(_authRepository),
          ),
          BlocProvider<GroupCubit>(
            create: (BuildContext context) => GroupCubit(_groupRepository),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WRU-Dev',
          theme: LightTheme.themeLight,
          home: SignInScreen(),
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            SignInScreen.routeName: (_) => SignInScreen(),
            SignUpScreen.routeName: (_) => SignUpScreen(),
          },
        ),
      ),
    );
  }
}
