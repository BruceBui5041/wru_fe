import 'package:wru_fe/models/journey.model.dart';
import 'package:wru_fe/models/user.model.dart';

class SharedJourney {
  SharedJourney({required this.uuid});

  SharedJourney.fromJson(Map<String, dynamic> json) {
    uuid = _getStringValue(json['uuid']);

    journeyOwner = json['jouneyOwner'] != null
        ? User.fromJson(json['jouneyOwner'] as Map<String, dynamic>)
        : null;

    sharedUser = json['sharedUser'] != null
        ? User.fromJson(json['sharedUser'] as Map<String, dynamic>)
        : null;

    journey = json['jouney'] != null
        ? Journey.fromJson(json['jouney'] as Map<String, dynamic>)
        : null;

    updatedAt = _getStringValue(json['updatedAt']);
    createdAt = _getStringValue(json['createdAt']);
  }

  String? uuid;

  Journey? journey;

  User? journeyOwner;

  User? sharedUser;

  String? updatedAt;
  String? createdAt;

  String? _getStringValue(dynamic nullableValue) {
    return nullableValue != null ? nullableValue as String : null;
  }
}
