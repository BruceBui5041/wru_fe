import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/create_jouney_dialog.widget.dart';
import 'package:wru_fe/widgets/jouneys.widget.dart';
import 'package:wru_fe/widgets/jouneys_drawer_topbar.widget.dart';

class JouneyDrawer extends StatefulWidget {
  const JouneyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _JouneyDrawerState createState() => _JouneyDrawerState();
}

class _JouneyDrawerState extends State<JouneyDrawer> {
  void _openCreateJouneyDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => CreateJouneyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final floatingBtnTheme = theme.floatingActionButtonTheme;
    final textTheme = theme.textTheme;

    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(5),
          ),
          child: Scaffold(
            backgroundColor: Colors.blue[100],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: JouneyDrawerTopBar(),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.fromLTRB(0, 0, 4, 2),
              child: JouneyList(),
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: "createJouney",
              mini: true,
              onPressed: () {
                _openCreateJouneyDialog(context);
              },
              elevation: 4.0,
              child: Icon(
                Icons.add,
                size: textTheme.headline6!.fontSize,
              ),
              backgroundColor: floatingBtnTheme.backgroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
