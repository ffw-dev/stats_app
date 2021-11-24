

import 'package:dio/dio.dart';
import 'package:ffw_stat_app_second/models/secure_cookie.dart';
import 'package:ffw_stat_app_second/models/user.dart';

import '../base_fetch.dart';
import '../base_response.dart';

class AuthenticationEndpoints {
  static Future<BaseResponse<User>> emailPasswordPost(FormData formData) async {
    var response = await BaseFetch().postFetch("EmailPassword/Login", formData, true).then((value) => value);
    var data = response;

    return BaseResponse.fromApi<User>(data, (data) => User.fromJson(data));
  }

  static Future<BaseResponse<SecureCookie>> secureCookieLogin(FormData formData) async {
    var response = await BaseFetch().postFetch("SecureCookie/Login", formData, true).then((value) => value);

    var data = response;

    return BaseResponse.fromApi(data, (data) => SecureCookie.fromJson(data));
  }

  static Future<BaseResponse<SecureCookie>> secureCookieCreate() async {
    var response = await BaseFetch().getFetch("SecureCookie/Create", {}, true).then((value) => value);
    var data = response;

    return BaseResponse.fromApi(data, (data) => SecureCookie.fromJson(data));
  }
}