import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class JouneyAppBar extends StatelessWidget with PreferredSizeWidget {
  const JouneyAppBar({
    Key? key,
    required this.appBarTitle,
    required this.markerCount,
  }) : super(key: key);

  final String appBarTitle;
  final int markerCount;

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
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              color: theme.primaryColor,
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          Text(
            appBarTitle,
            style: TextStyle(
              fontSize: textTheme.headline5!.fontSize,
              color: theme.primaryColor,
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
