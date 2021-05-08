import 'package:wru_fe/models/user.model.dart';

class Group {
  Group({
    required this.owner,
    required this.groupName,
    this.description,
    this.groupImageUrl,
    this.updatedAt,
    required this.uuid,
    required this.createdAt,
  });

  Group.fromJson(Map<String, dynamic> json)
      : groupName = json['groupName'] as String,
        description = json['description'] as String,
        groupImageUrl = json['groupImageUrl'] as String,
        uuid = json['uuid'] as String,
        owner = json['owner'] != null
            ? User.fromJson(json['owner'] as Map<String, dynamic>)
            : null,
        updatedAt = json['updatedAt'] as String,
        createdAt = json['createdAt'] as String;

  final String uuid;

  //------------------------------------------------------------------

  String groupName;

  // String get groupName => _groupName;

  // set groupName(String groupName) => _groupName = groupName;
  //------------------------------------------------------------------

  String? groupImageUrl;

  // String? get getGroupImageUrl => groupImageUrl;

  // set setGroupImageUrl(String groupImageUrl) =>
  //     this.groupImageUrl = groupImageUrl;
  //------------------------------------------------------------------

  String? description;

  // String? get getDescription => description;

  // set setDescription(String description) => this.description = description;
  //------------------------------------------------------------------

  User? owner;

  // User get getOwner => owner;

  // set setOwner(User owner) {
  //   owner = owner;
  // }

  //------------------------------------------------------------------

  String? updatedAt;

  // String? get getUpdatedAt => updatedAt;

  // set setUpdatedAt(String updatedAt) => this.updatedAt = updatedAt;

  //------------------------------------------------------------------
  String createdAt;

  // String get getCreatedAt => createdAt;

  // set setCreatedAt(String createdAt) => this.createdAt = createdAt;

}
