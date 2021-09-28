import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/cubit/signup/signin_cubit.dart';
import 'package:wru_fe/dto/fetch_group.dto.dart';
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
    context.read<GroupCubit>().fetchGroups(FetchGroupDto(ids: null));
  }

  Widget _generateGroupListWidget(List<Group> groups) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final Group group = groups[index];
        return GroupItemWidget(
          group: group,
        );
      },
      itemCount: groups.length,
    );
  }

  Widget _screenContent(GroupState state) {
    if (state is GroupFetchFailed) {
      return Text(state.message.toString());
    } else if (state is GroupFetchSuccess) {
      return _generateGroupListWidget(state.groups);
    } else {
      return const Text("Loading ...");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingBtnTheme = theme.floatingActionButtonTheme;
    final textTheme = theme.textTheme;

    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
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
            label: Text(
              'Group',
              style: TextStyle(fontSize: textTheme.headline4!.fontSize),
            ),
            icon: Icon(
              Icons.add,
              size: textTheme.headline4!.fontSize,
            ),
            backgroundColor: floatingBtnTheme.backgroundColor,
          ),
        );
      },
    );
  }
}
