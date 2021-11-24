
import 'package:ffw_stat_app_second/managers/authentication/login_service.dart';
import 'package:ffw_stat_app_second/managers/authentication/secure_cookie_service.dart';
import 'package:flutter/cupertino.dart';


class AuthenticationProvider with ChangeNotifier {
  LoginService get _loginService => LoginService();
  AuthenticatedState isAuthenticated = AuthenticatedState.unauthenticated;

  Future<bool> loginByCookie() async {
    var success = await _loginService.tryLoginByCookie();

    if(success) {
      isAuthenticated = AuthenticatedState.authenticated;
    } else {
      isAuthenticated = AuthenticatedState.unauthenticated;
    }

    notifyListeners();
    return success;
  }

  Future<AuthenticatedState> login(String email, String password) async {
    var logged = await _loginService.login(email, password);

    if(logged) {
      SecureCookieService().createCookie();
      isAuthenticated = AuthenticatedState.authenticated;
    } else {
      isAuthenticated = AuthenticatedState.unauthenticated;
    }

    notifyListeners();
    return isAuthenticated;
  }

}

enum AuthenticatedState {
  authenticated,
  checking,
  unauthenticated
}