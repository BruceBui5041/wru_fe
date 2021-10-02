import 'package:flutter/material.dart';

class JouneyDrawerTopBar extends StatefulWidget {
  JouneyDrawerTopBar({Key? key}) : super(key: key);
  final List<bool> _isSelected = [false, false];

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
        const Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.fromLTRB(3, 8, 3, 8),
            child: TextField(
              maxLines: 1,
              decoration: InputDecoration(
                focusColor: Colors.red,
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                ),
                border: OutlineInputBorder(),
                labelText: 'Search',
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
