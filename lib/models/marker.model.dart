import 'package:wru_fe/global_constants.dart';
import 'package:wru_fe/models/journey.model.dart';

class CustomMarker {
  CustomMarker({
    required this.journey,
    required this.lng,
    required this.lat,
  });

  CustomMarker.fromJson(Map<String, dynamic> json) {
    name = _getStringValue(json['name']);
    lng = _getNumberValue(json['lng']);
    lat = _getNumberValue(json['lat']);
    description = _getStringValue(json['description']);
    image = _getImageURL(json['image']);
    uuid = _getStringValue(json['uuid']);
    updatedAt = _getStringValue(json['updatedAt']);
    createdAt = _getStringValue(json['createdAt']);
    journey = json['jouney'] != null
        ? Journey.fromJson(json['jouney'] as Map<String, dynamic>)
        : null;
  }

  String? uuid;
  String? name;
  String? description;
  String? visibility;
  Journey? journey;

  double? lng;
  double? lat;

  String? updatedAt;
  String? createdAt;

  String? image;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? image5;

  String? _getStringValue(dynamic nullableValue) {
    return nullableValue != null ? nullableValue as String : null;
  }

  double _getNumberValue(dynamic nullableValue) {
    if (nullableValue == null) return 999;
    return double.parse(nullableValue.toString());
  }

  String? _getImageURL(dynamic filename) {
    return filename != null ? "$IMAGE_URL$filename" : null;
  }
}
