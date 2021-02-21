import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';

class GroupsScreen extends StatefulWidget {
  static const routeName = "/group-screen";

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GroupCubit>().fetchGroup();
  }

  Widget _generateGroupListWidget(List<Group> groups) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var group = groups[index];
        return Text(group.groupName);
      },
      itemCount: groups.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupFetchSuccess) {
          print(state.groups);
        } else if (state is SignedIn) {
          Navigator.of(context).pushNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        return Container(
          child: Center(
            child: state is GroupFetching
                ? Text("Loading ...")
                : (state is GroupFetchFailed
                    ? Text(
                        state.message,
                      )
                    : state is GroupFetchSuccess
                        ? _generateGroupListWidget(state.groups)
                        : null),
          ),
        );
      },
    );
  }
}
