import 'package:dio/dio.dart';
import 'package:ffw_stat_app_second/api/api_endpoints/authentication_endpoints.dart';
import 'package:ffw_stat_app_second/managers/authentication/secure_cookie_service.dart';


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

    var response = await AuthenticationEndpoints.emailPasswordPost(formData);

    return response.error.fullName == null ? true : false;
  }

  void logout() {
    _secureCookieService.deleteFromStorage();
  }
}