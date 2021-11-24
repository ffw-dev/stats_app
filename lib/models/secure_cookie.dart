import 'package:json_annotation/json_annotation.dart';

part 'secure_cookie.g.dart';

@JsonSerializable(explicitToJson: true)
class SecureCookie {

  @JsonKey(name: 'Guid')
  String guid;

  @JsonKey(name: 'PasswordGuid')
  String passwordGuid;

  @JsonKey(name: 'FullName')
  String fullName;

  SecureCookie(this.guid, this.fullName, this.passwordGuid);

  factory SecureCookie.fromJson(Map<String, dynamic> json) => _$SecureCookieFromJson(json);
  Map<String, dynamic> toJson() => _$SecureCookieToJson(this);
}