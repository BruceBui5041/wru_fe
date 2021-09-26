class FetchGroupDto {
  FetchGroupDto({
    this.own = false,
    this.ids = const [],
  });

  bool own;
  List<String?>? ids;
}
