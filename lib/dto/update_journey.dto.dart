import 'package:wru_fe/enums.dart';

class UpdateJourneyDto {
  UpdateJourneyDto({
    required this.journeyId,
    this.name,
    this.description,
    this.image,
    this.visibility,
  });

  String journeyId;
  String? name;
  String? description;
  String? image;
  JourneyVisibility? visibility;
}
