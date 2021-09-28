import 'package:wru_fe/models/user.model.dart';

class Jouney {
  Jouney({
    required this.owner,
    required this.name,
  });

  Jouney.fromJson(Map<String, dynamic> json) {
    name = _getStringValue(json['name']);
    description = _getStringValue(json['description']);
    image = _getStringValue(json['image']);
    uuid = _getStringValue(json['uuid']);
    markerCount = json['markerCount'] != null ? json['markerCount'] as int : 0;
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
  String? visibility;
  User? owner;
  int? markerCount;

  String? updatedAt;
  String? createdAt;

  String? _getStringValue(dynamic nullableValue) {
    return nullableValue != null ? nullableValue as String : null;
  }
}
