import 'package:json_annotation/json_annotation.dart';

part 'error_response_part.g.dart';

@JsonSerializable()
class ErrorResponsePart {
  final String? fullName;
  final int? code;
  final String? message;

  ErrorResponsePart(this.fullName, this.code, this.message);

  factory ErrorResponsePart.fromJson(Map<String, dynamic> json) => _$ErrorResponsePartFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponsePartToJson(this);
}