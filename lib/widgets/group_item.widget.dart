import 'package:flutter/material.dart';
import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/screens/group_details.screen.dart';

class GroupItemWidget extends StatelessWidget {
  final Group group;

  GroupItemWidget({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FittedBox(child: Text('${group.groupImageUrl}')),
            ),
          ),
          title: Text(group.groupName),
          subtitle: Text("${group.createdAt}"),
          trailing: Text("${group.description}"),
          onTap: () {
            Navigator.of(context).popAndPushNamed(
              GroupDetailsScreen.routeName,
              arguments: group.uuid,
            );
          },
        ),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
