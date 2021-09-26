class CreateGroupDto {
  CreateGroupDto({
    required this.groupName,
    this.description = '',
    this.groupImageUrl = '',
  });

  String groupName;
  String groupImageUrl;
  String description;
}
