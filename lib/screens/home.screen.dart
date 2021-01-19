import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/screens/signin.screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    context.read<GroupCubit>().fetchGroup();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupFetchSuccess) {
          print("sucess!");
        } else if (state is SignedIn) {
          Navigator.of(context).pushNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Home"),
          ),
          body: Container(
            child: Center(
              child: Text("asda"),
            ),
          ),
        );
      },
    );
  }
}
