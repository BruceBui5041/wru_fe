import 'package:flutter/material.dart';
import 'package:wru_fe/models/group.model.dart';

class GroupItemWidget extends StatelessWidget {
  final Group group;

  GroupItemWidget({this.group});

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
        ),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}
