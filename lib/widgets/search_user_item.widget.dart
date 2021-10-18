import 'package:flutter/material.dart';
import 'package:wru_fe/models/user.model.dart';

class SearchUserItem extends StatelessWidget {
  const SearchUserItem({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          //Expanded(child: Text(user.profile!.image ?? "")),
          Expanded(
            child: Column(
              children: [
                Text(user.username ?? ""),
                Text(user.email ?? ""),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
