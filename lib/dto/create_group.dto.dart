import 'package:flutter/foundation.dart';

class CreateGroupDto {
  String groupName;
  String groupImageUrl;
  String description;

  CreateGroupDto({
    @required this.groupName,
    this.description = '',
    this.groupImageUrl = '',
  });
}
