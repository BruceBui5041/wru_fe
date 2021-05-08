class FetchGroupDto {
  bool own;
  List<String?>? ids;

  FetchGroupDto({
    this.own = false,
    this.ids = const [],
  });
}
