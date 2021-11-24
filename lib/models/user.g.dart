// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['Guid'] as String,
      json['SystemPermissions'] as int,
      json['Email'] as String,
      json['SessionDateCreated'] as int,
      json['SessionDateModified'] as int,
      json['FullName'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'Guid': instance.guid,
      'SystemPermissions': instance.systemPermissions,
      'Email': instance.email,
      'SessionDateCreated': instance.sessionDateCreated,
      'SessionDateModified': instance.sessionDateModified,
      'FullName': instance.fullName,
    };
