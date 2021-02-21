class User {
  String uuid;

  String get getUuid => uuid;

  set setUuid(String uuid) => this.uuid = uuid;

//------------------------------------------------------------
  String username;

  String get getUsername => username;

  set setUsername(String username) => this.username = username;
//------------------------------------------------------------

  String email;

  String get getEmail => email;

  set setEmail(String email) => this.email = email;

//-------------------------------------------------------------
  User({this.uuid, this.username, this.email});

  User.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        username = json['user'],
        email = json['email'];
}
