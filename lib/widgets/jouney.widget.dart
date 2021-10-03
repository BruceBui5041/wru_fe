import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/jouney.model.dart';
import 'package:wru_fe/utils.dart';

class JouneyItem extends StatelessWidget {
  const JouneyItem({
    Key? key,
    required this.jouney,
    required this.onJouneySelected,
  }) : super(key: key);

  final Function(String?) onJouneySelected;
  final Jouney jouney;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdAt = DateFormat('MM/dd/yyyy, hh:mm a')
        .format(DateTime.parse(jouney.createdAt ?? ""));

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 5, 0),
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
          onJouneySelected(jouney.name);
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
                    style: TextStyle(
                      fontSize: textTheme.headline4!.fontSize,
                    ),
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
                  child: CachedNetworkImage(
                    imageUrl: jouney.image.toString(),
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        value: downloadProgress.totalSize != null
                            ? downloadProgress.downloaded /
                                downloadProgress.totalSize!
                            : null,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
