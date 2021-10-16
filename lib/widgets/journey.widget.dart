import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/custom_cached_image.widget.dart';

class JourneyItem extends StatelessWidget {
  const JourneyItem({Key? key, required this.journey, this.selected = false})
      : super(key: key);

  final Journey journey;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdAt = DateFormat('MM/dd/yyyy, hh:mm a')
        .format(DateTime.parse(journey.createdAt ?? ""));

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 3, 5, 5),
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: const Alignment(0.8, 0.0),
          colors: [
            selected ? Colors.purple[200]! : Colors.blue[200]!,
            selected ? Colors.purple[50]! : Colors.blue[50]!
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
          setValueToStore(LAST_SEEN_JOURNEY, journey.uuid!);
          Navigator.of(context).pop();
        },
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journey.name ?? "",
                    style: textTheme.headline4,
                  ),
                  Text(
                    journey.description ?? "",
                    style: textTheme.bodyText1,
                  ),
                  Text(
                    createdAt,
                    style: textTheme.subtitle1,
                  ),
                  Text(
                    journey.markerCount.toString(),
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
                  child: CustomCachedImage(imageUrl: journey.image),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
