import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:stats_app/managers/session_service.dart';
import 'package:stats_app/redux/app_state.dart';

import 'authentication.dart';

class LoginAction extends ReduxAction<AppState> {
  String email;
  String password;

  LoginAction(this.email, this.password);

  @override
  Future<AppState> reduce() {
    return store.state.authentication
        .login(email, password)
        .then((value) => state);
  }
}

class LoginByCookieAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    return SessionService()
        .createAndSaveSession()
        .then((value) => store.state.authentication.loginByCookie())
        .then((value) => state);
  }
}
