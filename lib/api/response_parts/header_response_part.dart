import 'package:json_annotation/json_annotation.dart';

part 'header_response_part.g.dart';

@JsonSerializable()
class HeaderResponsePart {
  final double? duration;

  HeaderResponsePart(this.duration);

  factory HeaderResponsePart.fromJson(Map<String, dynamic> json) => _$HeaderResponsePartFromJson(json);
  Map<String, dynamic> toJson() => _$HeaderResponsePartToJson(this);
}