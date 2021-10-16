import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:wru_fe/widgets/create_journey_dialog.widget.dart';

class JourneyAppBar extends StatelessWidget with PreferredSizeWidget {
  const JourneyAppBar({
    Key? key,
    required this.appBarTitle,
    required this.markerCount,
  }) : super(key: key);

  final String appBarTitle;
  final int markerCount;

  void _openCreateJourneyDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => const CreateJourneyDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AppBar(
      backgroundColor: Colors.white70,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => TextButton(
              child: Text(
                "Journeys",
                style: TextStyle(
                  fontSize: theme.textTheme.headline4!.fontSize,
                ),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          Text(
            appBarTitle,
            style: TextStyle(
              fontSize: textTheme.headline6!.fontSize,
              color: Colors.purple,
            ),
          ),
          Badge(
            badgeContent: Text(markerCount.toString()),
            elevation: 0,
            position: BadgePosition.topEnd(end: 1, top: -2),
            animationType: BadgeAnimationType.scale,
            child: IconButton(
              icon: const Icon(Icons.room),
              padding: const EdgeInsets.all(5),
              color: theme.primaryColor,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [Container()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
