import 'package:wru_fe/models/user_profile.model.dart';

class User {
  User({required this.uuid, required this.username, this.email, this.profile});

  User.fromJson(Map<String, dynamic> json) {
    uuid = _getStringValue(json['uuid']);
    username = _getStringValue(json['username']);
    profile = json['profile'] != null
        ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
        : null;
    email = _getStringValue(json['email']);
  }

  String? uuid;

  // String get getUuid => uuid;

  // set setUuid(String uuid) => this.uuid = uuid;

//------------------------------------------------------------
  String? username;

  // String get getUsername => username;

  // set setUsername(String username) => this.username = username;
//------------------------------------------------------------

  String? email;

  // String? get getEmail => email;

  // set setEmail(String email) => this.email = email;

//------------------------------------------------------------

  UserProfile? profile;

  // UserProfile? get getProfile => profile;

  // set setEProfile(UserProfile profile) => this.profile = profile;

//-------------------------------------------------------------
  String _getStringValue(dynamic nullableValue) {
    return nullableValue != null ? nullableValue as String : "";
  }
}
