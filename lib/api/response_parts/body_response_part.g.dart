// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_response_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyResponsePart<T> _$BodyResponsePartFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BodyResponsePart<T>(
      json['Count'] as int?,
      json['TotalCount'] as int?,
      (json['Results'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$BodyResponsePartToJson<T>(
  BodyResponsePart<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'Count': instance.count,
      'TotalCount': instance.totalCount,
      'Results': instance.results.map(toJsonT).toList(),
    };
