import 'package:flutter/material.dart';
import 'package:wru_fe/models/user.model.dart';

class MemberWidget extends StatelessWidget {
  const MemberWidget({required this.member});

  final User member;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          isThreeLine: true,
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: member.profile == null
                  ? const Text("Img")
                  : Image.network(
                      member.profile!.image.toString(),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          title: Text(member.username ?? ""),
          subtitle: Text(member.email == null ? "" : member.email.toString()),
          onTap: () {},
        ),
      ),
    );
  }
}
