// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      json['Guid'] as String,
      json['UserGuid'] as String,
      json['DateCreated'] as int,
      json['DateModified'] as int,
      json['FullName'] as String,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'Guid': instance.guid,
      'UserGuid': instance.userGuid,
      'DateCreated': instance.dateCreated,
      'DateModified': instance.dateModified,
      'FullName': instance.fullName,
    };
