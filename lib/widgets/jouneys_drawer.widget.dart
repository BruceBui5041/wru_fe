import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/create_jouney_dialog.widget.dart';
import 'package:wru_fe/widgets/jouneys.widget.dart';
import 'package:wru_fe/widgets/jouneys_drawer_topbar.widget.dart';

class JouneyDrawer extends StatefulWidget {
  const JouneyDrawer({
    Key? key,
    required this.onJouneySelected,
  }) : super(key: key);

  final Function(String?) onJouneySelected;

  @override
  _JouneyDrawerState createState() => _JouneyDrawerState();
}

class _JouneyDrawerState extends State<JouneyDrawer> {
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
              child: JouneyList(
                onJouneySelected: widget.onJouneySelected,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () async {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => CreateJouneyDialog(),
                );
                // final ImagePicker _picker = ImagePicker();
                // final XFile? image =
                //     await _picker.pickImage(source: ImageSource.gallery);
                // if (image != null) {
                //   Upload.uploadSingleImage(image, (String? filename) {
                //     print(filename);
                //   });
                // }
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
