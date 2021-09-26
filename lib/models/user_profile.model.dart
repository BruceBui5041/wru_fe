class UserProfile {
  UserProfile({required this.uuid, this.avatarUrl});

  UserProfile.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'] as String,
        avatarUrl = json['avatarUrl'] as String;

  final String uuid;
  // String get getUuid => uuid;
  // set setUuid(String uuid) => this.uuid = uuid;

  String? avatarUrl;
  // String? get getAvatarUrl => avatarUrl;
  // set setAvatarUrl(String avatarUrl) => this.avatarUrl = avatarUrl;

}
