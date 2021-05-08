import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/dto/fetch_group.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';

class GroupDetailsScreen extends StatefulWidget {
  static const String routeName = "/group-details-screen";
  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    String? groupId = ModalRoute.of(context)?.settings.arguments.toString();
    context
        .read<GroupCubit>()
        .fetchSelectedGroup(FetchGroupDto(own: true, ids: [groupId]));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group'),
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return const SizedBox();
            },
          );
        },
        label: Text('Add Member'),
        icon: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: BlocConsumer<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state is FetchSelectedGroup) {
          } else if (state is FetchSelectedGroupSuccessed) {}
        },
        builder: (context, state) {
          if (state is FetchSelectedGroupSuccessed) {
            return Container(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.network(
                            state.group.groupImageUrl.toString())),
                  ),
                  CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                        child: Text(state.group.owner!.username),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Text("Loading .....");
        },
      ),
    );
  }
}
