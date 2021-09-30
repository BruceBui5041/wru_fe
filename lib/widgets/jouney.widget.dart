import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wru_fe/cubit/marker/marker_cubit.dart';
import 'package:wru_fe/dto/fetch_marker.dto.dart';
import 'package:wru_fe/models/jouney.model.dart';

class JouneyItem extends StatelessWidget {
  const JouneyItem({
    Key? key,
    required this.jouney,
    required this.markerCubit,
  }) : super(key: key);
  final Jouney jouney;
  final MarkerCubit markerCubit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdAt = DateFormat('MM/dd/yyyy, hh:mm a')
        .format(DateTime.parse(jouney.createdAt ?? ""));

    return Card(
      color: Colors.white70,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: ListTile(
        isThreeLine: true,
        title: Text(
          jouney.name ?? "",
          style: TextStyle(
            fontSize: textTheme.headline4!.fontSize,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
        trailing: SizedBox(
          width: 110,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: jouney.image == null
                ? const Text("Img")
                : Image.network(
                    jouney.image.toString(),
                    fit: BoxFit.cover,
                    loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ),
        onTap: () {
          markerCubit.fetchMarkers(
            FetchMarkerDto(jouneyId: jouney.uuid.toString()),
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
