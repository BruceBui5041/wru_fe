import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/signin_cubit.dart';
import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/screens/signin.screen.dart';
import 'package:wru_fe/widgets/create_group_buttom_sheet.widget.dart';
import 'package:wru_fe/widgets/group_item.widget.dart';

class GroupsScreen extends StatefulWidget {
  static const routeName = "/group-screen";

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GroupCubit>().fetchGroups();
  }

  Widget _generateGroupListWidget(List<Group> groups) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var group = groups[index];
        return GroupItemWidget(
          group: group,
        );
      },
      itemCount: groups.length,
    );
  }

  Widget _screenContent(GroupState state) {
    if (state is GroupFetching) {
      return Text("Loading ...");
    } else if (state is GroupFetchFailed) {
      return Text(state.message);
    } else if (state is GroupFetchSuccess) {
      return _generateGroupListWidget(state.groups);
    } else {
      return Text("Something went wrong !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is SignedIn) {
          Navigator.of(context).pushNamed(SignInScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            child: _screenContent(state),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              showBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return CreateGroupBottomSheet();
                },
              );
            },
            label: Text('New group'),
            icon: Icon(Icons.add),
            backgroundColor: Theme.of(context).accentColor,
          ),
        );
      },
    );
  }
}
