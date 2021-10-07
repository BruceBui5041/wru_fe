import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wru_fe/cubit/group/group_cubit.dart';
import 'package:wru_fe/dto/fetch_group.dto.dart';
import 'package:wru_fe/screens/home.screen.dart';
import 'package:wru_fe/widgets/custom_cached_image.widget.dart';

class GroupDetailsScreen extends StatefulWidget {
  static const String routeName = "/group-details-screen";
  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  @override
  void didChangeDependencies() {
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
            child: const Icon(
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
        label: const Text('Add Member'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: BlocConsumer<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state is FetchSelectedGroup) {
          } else if (state is FetchSelectedGroupSuccessed) {}
        },
        builder: (context, state) {
          if (state is FetchSelectedGroupSuccessed) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: CustomCachedImage(imageUrl: state.group.groupImageUrl),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        width: 70,
                        height: 70,
                        child: const Icon(Icons.person),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Text("Loading .....");
        },
      ),
    );
  }
}
