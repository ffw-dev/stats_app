
import 'package:ffw_stat_app_second/providers/authentication_provider.dart';
import 'package:ffw_stat_app_second/screens/home.dart';
import 'package:ffw_stat_app_second/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'managers/authentication/secure_cookie_service.dart';
import 'managers/session_service.dart';


void main() async {
  await SessionService().createAndSaveSession();
  SecureCookieService().deleteFromStorage();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future tryLoginByCookieFuture;

  @override
  void initState() {
    tryLoginByCookieFuture = SessionService().createAndSaveSession().then((value) => AuthenticationProvider().loginByCookie());
    print('initState');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AuthenticationProvider()),
        ],
        child: Consumer<AuthenticationProvider>(
          builder: (ctx, authenticationProvider, _) => MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home: authenticationProvider.isAuthenticated == AuthenticatedState.authenticated ? const HomeScreen() : waitForLoginFutureAndBuildAppropriateWidget(),
          ),
        )
    );
  }

  FutureBuilder<dynamic> waitForLoginFutureAndBuildAppropriateWidget() {
    return FutureBuilder(
        future: tryLoginByCookieFuture,
        builder: (ctx, result) => !result.hasData ? const CircularProgressIndicator() : result.data == false ? const LoginScreen() : const HomeScreen()
    );
  }

}
