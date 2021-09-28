import 'package:wru_fe/models/group.model.dart';
import 'package:wru_fe/models/jouney.model.dart';

class Marker {
  Marker({
    required this.jouney,
    required this.lng,
    required this.lat,
  });

  Marker.fromJson(Map<String, dynamic> json) {
    name = _getStringValue(json['name']);
    lng = _getNumberValue(json['lng']);
    lat = _getNumberValue(json['lat']);
    description = _getStringValue(json['description']);
    image = _getStringValue(json['image']);
    uuid = _getStringValue(json['uuid']);
    updatedAt = _getStringValue(json['updatedAt']);
    createdAt = _getStringValue(json['createdAt']);
    jouney = json['jouney'] != null
        ? Jouney.fromJson(json['jouney'] as Map<String, dynamic>)
        : null;
  }

  String? uuid;
  String? name;
  String? description;
  String? visibility;
  Jouney? jouney;

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
    return double.parse(nullableValue.toString());
  }
}
