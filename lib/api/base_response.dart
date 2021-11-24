
import 'package:ffw_stat_app_second/api/response_parts/body_response_part.dart';
import 'package:ffw_stat_app_second/api/response_parts/error_response_part.dart';
import 'package:ffw_stat_app_second/api/response_parts/header_response_part.dart';
import 'package:json_annotation/json_annotation.dart';

//part 'response.g.dart';

//@JsonSerializable(genericArgumentFactories: true, fieldRename: FieldRename.snake, nullable: true)
class BaseResponse<T> {

  @JsonKey(name: 'Body')
  BodyResponsePart<T> body;

  @JsonKey(name: 'Error')
  ErrorResponsePart error;

  @JsonKey(name: 'Header')
  HeaderResponsePart header;

  BaseResponse(this.body, this.header, this.error);

  bool get wasSuccess => error.fullName != null;

  static fromApi<T>(Map<String, dynamic> data, T Function(Map<String, dynamic> json) fromJsonT) {
    return BaseResponse(
        BodyResponsePart.fromJson(data['Body'], (data) => fromJsonT(data as Map<String, dynamic>)),
        HeaderResponsePart.fromJson(data['Header']),
        ErrorResponsePart.fromJson(data['Error'])
    );
  }

  /*factory Response.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$ResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$ResponseToJson(this, toJsonT);*/
}