class CreateMarkerDto {
  CreateMarkerDto({
    required this.jouneyId,
    required this.lat,
    required this.lng,
    required this.name,
    this.description,
    this.image,
  });

  final String jouneyId;

  final double lat;
  final double lng;
  final String name;
  String? description;
  String? image;
}
