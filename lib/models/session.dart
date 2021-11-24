import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable(explicitToJson: true)
class Session {
  @JsonKey(name: 'Guid')
  final String guid;
  @JsonKey(name: 'UserGuid')
  final String userGuid;
  @JsonKey(name: 'DateCreated')
  final int dateCreated;
  @JsonKey(name: 'DateModified')
  final int dateModified;
  @JsonKey(name: 'FullName')
  final String fullName;

  Session(this.guid, this.userGuid, this.dateCreated, this.dateModified, this.fullName);

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
