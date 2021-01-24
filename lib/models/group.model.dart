import 'package:wru_fe/models/user.model.dart';

class GroupModel {
  String uuid;

  String get getUuid => uuid;

  set setUuid(String uuid) => this.uuid = uuid;
  //------------------------------------------------------------------

  String groupName;

  String get getGroupName => groupName;

  set setGroupName(String groupName) => this.groupName = groupName;
  //------------------------------------------------------------------

  String groupImageUrl;

  String get getGroupImageUrl => groupImageUrl;

  set setGroupImageUrl(String groupImageUrl) =>
      this.groupImageUrl = groupImageUrl;
  //------------------------------------------------------------------

  String description;

  String get getDescription => description;

  set setDescription(String description) => this.description = description;
  //------------------------------------------------------------------

  UserModel user;

  UserModel get getUser => user;

  set setUser(UserModel user) {
    user = user;
  }

  //------------------------------------------------------------------

  String updatedAt;

  String get getUpdatedAt => updatedAt;

  set setUpdatedAt(String updatedAt) => this.updatedAt = updatedAt;

  //------------------------------------------------------------------
  String createdAt;

  String get getCreatedAt => createdAt;

  set setCreatedAt(String createdAt) => this.createdAt = createdAt;

  GroupModel(
      {this.user,
      this.groupName,
      this.description,
      this.groupImageUrl,
      this.uuid});

  GroupModel.fromJson(Map<String, dynamic> json)
      : groupName = json['groupName'],
        description = json['description'],
        groupImageUrl = json['groupImageUrl'],
        uuid = json['uuid'],
        user = json['user'];
}
