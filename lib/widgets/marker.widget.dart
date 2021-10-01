import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/utils.dart';

class MarkerItem extends StatelessWidget {
  const MarkerItem({
    Key? key,
    required this.marker,
    required this.moveMapCameraTo,
  }) : super(key: key);

  final CustomMarker marker;
  final Function(CameraPosition cameraPosition) moveMapCameraTo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdAt = DateFormat('MM/dd/yyyy, hh:mm a')
        .format(DateTime.parse(marker.createdAt ?? ""));

    return Card(
      color: Colors.white70,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      child: ListTile(
        isThreeLine: true,
        title: Text(
          marker.name ?? "",
          style: TextStyle(
            fontSize: textTheme.headline4!.fontSize,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              marker.description ?? "",
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
          ],
        ),
        trailing: SizedBox(
          width: 110,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: marker.image == null
                ? const Text("Img")
                : Image.network(
                    marker.image.toString(),
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
          double lat = marker.lat as double;
          double lng = marker.lng as double;

          CameraPosition cameraPosition = CameraPosition(
            target: LatLng(lat, lng),
            zoom: 14.4746,
          );

          moveMapCameraTo(cameraPosition);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
