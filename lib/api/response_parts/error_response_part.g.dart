// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponsePart _$ErrorResponsePartFromJson(Map<String, dynamic> json) =>
    ErrorResponsePart(
      json['fullName'] as String?,
      json['code'] as int?,
      json['message'] as String?,
    );

Map<String, dynamic> _$ErrorResponsePartToJson(ErrorResponsePart instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'code': instance.code,
      'message': instance.message,
    };
