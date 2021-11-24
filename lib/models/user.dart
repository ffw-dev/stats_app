import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  @JsonKey(name: 'Guid')
  String guid;

  @JsonKey(name: 'SystemPermissions')
  int systemPermissions;

  @JsonKey(name: 'Email')
  String email;

  @JsonKey(name: 'SessionDateCreated')
  int sessionDateCreated;

  @JsonKey(name: 'SessionDateModified')
  int sessionDateModified;

  @JsonKey(name: 'FullName')
  String fullName;

  User(this.guid,
        this.systemPermissions,
        this.email,
        this.sessionDateCreated,
        this.sessionDateModified,
        this.fullName);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}