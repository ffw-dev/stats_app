// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_cookie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecureCookie _$SecureCookieFromJson(Map<String, dynamic> json) => SecureCookie(
      json['Guid'] as String,
      json['FullName'] as String,
      json['PasswordGuid'] as String,
    );

Map<String, dynamic> _$SecureCookieToJson(SecureCookie instance) =>
    <String, dynamic>{
      'Guid': instance.guid,
      'PasswordGuid': instance.passwordGuid,
      'FullName': instance.fullName,
    };
