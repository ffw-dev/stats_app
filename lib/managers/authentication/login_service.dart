import 'package:dev_basic_api/main.dart';
import 'package:dio/dio.dart';
import 'package:stats_app/managers/authentication/secure_cookie_service.dart';



class LoginService {
  final SecureCookieService _secureCookieService = SecureCookieService();

  Future<bool> tryLoginByCookie() {
    return _secureCookieService.loginByCookie();
  }

  Future<bool> login(String email, String password) async {
    FormData formData = FormData.fromMap({
      "email": email,
      "password": password,
    });

    var response = await DevBasicApi.authenticationEndpoints.emailPasswordPost(formData);

    return response.error.fullName == null ? true : false;
  }

  void logout() {
    _secureCookieService.deleteFromStorage();
  }
}