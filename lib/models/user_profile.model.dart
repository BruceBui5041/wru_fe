class UserProfile {
  UserProfile({required this.uuid, this.image});

  UserProfile.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'] as String,
        image = json['image'] as String;

  final String uuid;
  String? image;
}
