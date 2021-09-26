import 'package:flutter/material.dart';
import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/screens/group_details.screen.dart';

class GroupItemWidget extends StatelessWidget {
  const GroupItemWidget({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        child: ListTile(
          isThreeLine: true,
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: group.groupImageUrl == null
                  ? const Text("Img")
                  : Image.network(
                      group.groupImageUrl.toString(),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Text(group.groupName),
          subtitle: Text(group.createdAt),
          trailing: Text(group.description.toString()),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
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
