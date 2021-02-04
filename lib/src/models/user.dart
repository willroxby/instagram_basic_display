part of instagram.models;

@JsonSerializable(createToJson: false)
class User extends Object {
  User();
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String account_type;
  String id;
  int media_count;
  String username;
}
