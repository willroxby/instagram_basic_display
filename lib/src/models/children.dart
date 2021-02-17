part of instagram.models;

@JsonSerializable(createToJson: false)
class Children extends Object {
  Children();

  factory Children.fromJson(Map<String, dynamic> json) {
    return _$ChildrenFromJson(json);
  }

  List<Map> data;
}
