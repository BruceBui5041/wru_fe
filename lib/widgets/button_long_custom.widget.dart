import 'package:flutter/material.dart';

class ButtonLongCustomWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ButtonLongCustomWidget(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Theme.of(context).buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.button,
      ),
      minWidth: double.infinity,
      onPressed: onPressed,
    );
  }
}
