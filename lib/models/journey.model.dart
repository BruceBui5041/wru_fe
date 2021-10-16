import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wru_fe/enums.dart';
import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/marker.model.dart';
import 'package:wru_fe/models/user.model.dart';

class Journey {
  Journey({
    required this.owner,
    required this.name,
  });

  Journey.fromJson(Map<String, dynamic> json) {
    name = _getStringValue(json['name']);
    description = _getStringValue(json['description']);
    image = _getImageURL(json['image']);
    uuid = _getStringValue(json['uuid']);
    visibility = _getVisibility(json['visibility']);
    markerCount = json['markerCount'] != null ? json['markerCount'] as int : 0;
    markers = json['markers'] != null
        ? json['markers']
            .map<CustomMarker>(
                (markerJson) => CustomMarker.fromJson(markerJson))
            .toList()
        : [];
    owner = json['owner'] != null
        ? User.fromJson(json['owner'] as Map<String, dynamic>)
        : null;
    updatedAt = _getStringValue(json['updatedAt']);
    createdAt = _getStringValue(json['createdAt']);
  }

  String? uuid;
  String? name;
  String? description;
  String? image;
  String? imageName;
  JourneyVisibility visibility = JourneyVisibility.private;
  User? owner;
  int? markerCount;
  List<CustomMarker> markers = [];

  String? updatedAt;
  String? createdAt;

  String? _getStringValue(dynamic nullableValue) {
    return nullableValue != null ? nullableValue as String : null;
  }

  String? _getImageURL(dynamic filename) {
    imageName = filename;
    return filename != null ? "$IMAGE_URL$filename" : null;
  }

  JourneyVisibility _getVisibility(dynamic visibility) {
    if (visibility == null) {
      return JourneyVisibility.private;
    }
    return visibility.toString() == "0"
        ? JourneyVisibility.private
        : JourneyVisibility.public;
  }
}
