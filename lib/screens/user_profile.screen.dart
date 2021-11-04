import 'package:flutter/material.dart';
import 'package:wru_fe/api/api.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/repositories/auth.repository.dart';
import 'package:wru_fe/screens/signin.screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileScreen> {
  void _logout(BuildContext context) {
    getIt<AuthRepository>().callLogoutApi().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(value)),
      );
      Navigator.of(context).pushNamedAndRemoveUntil(
        SignInScreen.routeName,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text(
          "Logout",
          style: Theme.of(context).textTheme.headline4,
        ),
        onPressed: () {
          _logout(context);
        },
      ),
    );
  }
}
