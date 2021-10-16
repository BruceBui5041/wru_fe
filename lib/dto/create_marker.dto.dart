class CreateMarkerDto {
  CreateMarkerDto({
    required this.journeyId,
    required this.lat,
    required this.lng,
    required this.name,
    this.description,
    this.image,
  });

  final String journeyId;

  final double lat;
  final double lng;
  final String name;
  String? description;
  String? image;
}
