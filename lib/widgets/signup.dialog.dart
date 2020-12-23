import 'package:flutter/material.dart';

class SignUpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 5, right: 5),
      title: Center(child: Text('Register account')),
      content: Container(
        width: 400,
        height: 250,
        child: Column(
          children: [
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Password",
              ),
            ),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Confirm Password",
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('Sign in'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
