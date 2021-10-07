import 'package:wru_fe/enums.dart';

class UpdateJouneyDto {
  UpdateJouneyDto({
    required this.jouneyId,
    this.name,
    this.description,
    this.image,
    this.visibility,
  });

  String jouneyId;
  String? name;
  String? description;
  String? image;
  JouneyVisibility? visibility;
}
