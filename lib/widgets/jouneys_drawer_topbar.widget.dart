import 'package:flutter/material.dart';

class JouneyDrawerTopBar extends StatefulWidget {
  JouneyDrawerTopBar({Key? key}) : super(key: key);
  final List<bool> _isSelected = [true, false];

  @override
  _JouneyDrawerTopBarState createState() => _JouneyDrawerTopBarState();
}

class _JouneyDrawerTopBarState extends State<JouneyDrawerTopBar> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isSelected = widget._isSelected;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 8, 3, 8),
            child: Text(
              isSelected[0] == true ? "My jouney" : "Shared jouney",
              style: TextStyle(
                fontSize: theme.textTheme.headline4!.fontSize,
                color: Colors.purple,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ToggleButtons(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            renderBorder: false,
            fillColor: Colors.blue[200],
            children: [
              Icon(
                Icons.person_outline,
                color: theme.primaryColor,
              ),
              Icon(
                Icons.people_alt_outlined,
                color: theme.primaryColor,
              ),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < isSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isSelected[buttonIndex] = true;
                  } else {
                    isSelected[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: isSelected,
          ),
        )
      ],
    );
  }
}
