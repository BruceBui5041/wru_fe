import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/custom_cached_image.widget.dart';

class JouneyItem extends StatelessWidget {
  const JouneyItem({
    Key? key,
    required this.jouney,
  }) : super(key: key);

  final Jouney jouney;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdAt = DateFormat('MM/dd/yyyy, hh:mm a')
        .format(DateTime.parse(jouney.createdAt ?? ""));

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 3, 5, 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: const Alignment(0.8, 0.0),
          colors: <Color>[
            Colors.blue[200] ?? Colors.blue,
            Colors.blue[50] ?? Colors.white
          ],
          tileMode: TileMode.clamp,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: InkWell(
        onTap: () {
          setValueToStore(LAST_SEEN_JOUNEY, jouney.uuid.toString());
          Navigator.of(context).pop();
        },
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    jouney.name ?? "",
                    style: textTheme.headline4,
                  ),
                  Text(
                    jouney.description ?? "",
                    style: TextStyle(
                      fontSize: textTheme.headline3!.fontSize,
                    ),
                  ),
                  Text(
                    createdAt,
                    style: TextStyle(
                      fontSize: textTheme.headline3!.fontSize,
                    ),
                  ),
                  Text(
                    jouney.markerCount.toString(),
                    style: TextStyle(
                      fontSize: textTheme.headline3!.fontSize,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                child: SizedBox(
                  width: 110,
                  height: 80,
                  child: CustomCachedImage(imageUrl: jouney.image),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
