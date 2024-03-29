// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wru_fe/api/graphql/graphql.dart';

import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/journey/journey_cubit.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/cubit/signin/signup_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/cubit/user/user_cubit.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/hive_config.dart';
import 'package:wru_fe/repositories/auth.repository.dart';
import 'package:wru_fe/repositories/group.repository.dart';
import 'package:wru_fe/repositories/journey.repository.dart';
import 'package:wru_fe/repositories/makers.repository.dart';
import 'package:wru_fe/repositories/user.repository.dart';
import 'package:wru_fe/screens/group_details.screen.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/screens/journey.screen.dart';
import 'package:wru_fe/screens/journey_details.screen.dart';
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

  getIt.registerSingleton<AuthRepository>(AuthRepository(), signalsReady: true);

  getIt.registerSingleton<SignInCubit>(
    SignInCubit(getIt<AuthRepository>()),
  );

  print(API_URL);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final JourneyRepository _journeyRepository =
      JourneyRepository(client: GraphQLUtil.client());
  final GroupRepository _groupRepository =
      GroupRepository(client: GraphQLUtil.client());
  final MarkerRepository _markerRepository =
      MarkerRepository(client: GraphQLUtil.client());
  final UserRepository _userRepository =
      UserRepository(client: GraphQLUtil.client());

  List<BlocProvider> providers() {
    return [
      BlocProvider<MarkerCubit>(
        create: (BuildContext context) => MarkerCubit(_markerRepository),
      ),
      BlocProvider<SignInCubit>(
        create: (BuildContext context) => getIt<SignInCubit>(),
      ),
      BlocProvider<SignUpCubit>(
        create: (BuildContext context) => SignUpCubit(getIt<AuthRepository>()),
      ),
      BlocProvider<GroupCubit>(
        create: (BuildContext context) => GroupCubit(_groupRepository),
      ),
      BlocProvider<JourneyCubit>(
        create: (BuildContext context) => JourneyCubit(_journeyRepository),
      ),
      BlocProvider<FetchJourneyByIdCubit>(
        create: (BuildContext context) => FetchJourneyByIdCubit(
          _journeyRepository,
        ),
      ),
      BlocProvider<UpdateJourneyCubit>(
        create: (BuildContext context) => UpdateJourneyCubit(
          _journeyRepository,
        ),
      ),
      BlocProvider<CreateJourneyCubit>(
        create: (BuildContext context) => CreateJourneyCubit(
          _journeyRepository,
        ),
      ),
      BlocProvider<ShareJourneyCubit>(
        create: (BuildContext context) => ShareJourneyCubit(
          _journeyRepository,
        ),
      ),
      BlocProvider<UserCubit>(
        create: (BuildContext context) => UserCubit(_userRepository),
      ),
    ];
  }

  Widget _authRoute(BuildContext context, Widget screen) {
    return BlocListener<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            SignInScreen.routeName,
            (route) => false,
          );
        }
      },
      child: screen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: getIt<AuthRepository>(),
      child: MultiBlocProvider(
        providers: providers(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WRU-Dev',
          theme: LightTheme.themeLight,
          home: SplashScreen(),
          routes: {
            HomeScreen.routeName: (context) =>
                _authRoute(context, const HomeScreen()),
            GroupDetailsScreen.routeName: (_) => GroupDetailsScreen(),
            SignInScreen.routeName: (_) => SignInScreen(),
            SignUpScreen.routeName: (_) => SignUpScreen(),
            SplashScreen.routeName: (_) => SplashScreen(),
            JourneyScreen.routeName: (_) => JourneyScreen(),
            JourneyDetailScreen.routeName: (context) =>
                _authRoute(context, JourneyDetailScreen())
          },
        ),
      ),
    );
  }
}
