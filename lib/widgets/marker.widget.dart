import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/utils.dart';
import 'package:wru_fe/widgets/custom_cached_image.widget.dart';

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

    return InkWell(
      splashColor: Colors.brown.withOpacity(0.5),
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.name ?? "",
                      style: TextStyle(
                        fontSize: textTheme.headline4!.fontSize,
                      ),
                    ),
                    Text(
                      marker.description ?? "",
                      style: TextStyle(
                        fontSize: textTheme.bodyText1!.fontSize,
                      ),
                    ),
                    Text(
                      createdAt,
                      style: textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  child: SizedBox(
                    width: 110,
                    height: 80,
                    child: CustomCachedImage(imageUrl: marker.image),
                  ),
                ),
              )
            ],
          ),
          const Divider()
        ],
      ),
    );
  }
}
