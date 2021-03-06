import 'package:dev_basic_api/main.dart';
import 'package:dio/dio.dart';


import '../storable.dart';

class SecureCookieService extends Storable<SecureCookie>  {
  @override
  String get key => "secureCookie";

  Future<void> createCookie() async {
    var response = await DevBasicApi.authenticationEndpoints.secureCookieCreate();

    replaceOldCookie(response.body.results[0]);
  }

  Future<void> replaceOldCookie(SecureCookie cookie) async {
    deleteFromStorage();
    await writeToStorage(cookie);
  }

  Future<bool> loginByCookie() async {
    var cookie = await readFromStorage();
    
    if(cookie == null) {
      return false;
    }

    var formData = FormData.fromMap({
      'guid': cookie.guid,
      'passwordGuid': cookie.passwordGuid
    });

    var response = await DevBasicApi.authenticationEndpoints.secureCookieLogin(formData);

    if(response == null) {
      return false;
    }
    replaceOldCookie(response.body.results[0]);

    return response.error.fullName == null ? true : false;
  }

  @override
  SecureCookie fromJson(Map<String, dynamic> json) {
    return SecureCookie.fromJson(json);
  }
}