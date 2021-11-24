

import 'package:json_annotation/json_annotation.dart';

part 'body_response_part.g.dart';

@JsonSerializable(genericArgumentFactories: true, explicitToJson: true)
class BodyResponsePart<T> {
  @JsonKey(name: 'Count')
  final int? count;

  @JsonKey(name: 'TotalCount')
  final int? totalCount;

  @JsonKey(name: 'Results')
  final List<T> results;

  BodyResponsePart(this.count, this.totalCount, this.results);

  factory BodyResponsePart.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$BodyResponsePartFromJson(json, fromJsonT);
  Map<String, dynamic> toJson() => _$BodyResponsePartToJson(this, (value) => value.runtimeType);
}