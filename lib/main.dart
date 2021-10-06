// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wru_fe/api/graphql/graphql.dart';

import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/jouney/jouney_cubit.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/signin/signup_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';
import 'package:wru_fe/repositories/auth.repository.dart';
import 'package:wru_fe/repositories/group.repository.dart';
import 'package:wru_fe/repositories/jouney.repository.dart';
import 'package:wru_fe/repositories/makers.repository.dart';
import 'package:wru_fe/screens/group_details.screen.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/jouney.screen.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/screens/signup.screen.dart';
import 'package:wru_fe/screens/splash.screen.dart';
import 'package:wru_fe/themes/light.theme.dart';

Future<void> main() async {
  const isProduction = bool.fromEnvironment('dart.vm.product');
  await dotenv.load(fileName: isProduction ? 'prod.env' : 'dev.env');

  getIt.registerSingleton<HiveConfig>(
    HiveConfig(),
    signalsReady: true,
  );

  await getIt<HiveConfig>().initHive();

  print(API_URL);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();
  final JouneyRepository _jouneyRepository =
      JouneyRepository(client: GraphQLUtil.client());
  final GroupRepository _groupRepository =
      GroupRepository(client: GraphQLUtil.client());
  final MarkerRepository _markerRepository =
      MarkerRepository(client: GraphQLUtil.client());

  List<BlocProvider> providers() {
    return [
      BlocProvider<MarkerCubit>(
        create: (BuildContext context) => MarkerCubit(_markerRepository),
      ),
      BlocProvider<SignInCubit>(
        create: (BuildContext context) => SignInCubit(_authRepository),
      ),
      BlocProvider<SignUpCubit>(
        create: (BuildContext context) => SignUpCubit(_authRepository),
      ),
      BlocProvider<GroupCubit>(
        create: (BuildContext context) => GroupCubit(_groupRepository),
      ),
      BlocProvider<JouneyCubit>(
        create: (BuildContext context) => JouneyCubit(_jouneyRepository),
      ),
      BlocProvider<FetchJouneyByIdCubit>(
        create: (BuildContext context) => FetchJouneyByIdCubit(
          _jouneyRepository,
        ),
      ),
      BlocProvider<CreateJouneyCubit>(
        create: (BuildContext context) => CreateJouneyCubit(
          _jouneyRepository,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: MultiBlocProvider(
        providers: providers(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WRU-Dev',
          theme: LightTheme.themeLight,
          home: SplashScreen(),
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            GroupDetailsScreen.routeName: (_) => GroupDetailsScreen(),
            SignInScreen.routeName: (_) => SignInScreen(),
            SignUpScreen.routeName: (_) => SignUpScreen(),
            SplashScreen.routeName: (_) => SplashScreen(),
            JouneyScreen.routeName: (_) => JouneyScreen()
          },
        ),
      ),
    );
  }
}
