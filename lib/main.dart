import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stats_app/managers/session_service.dart';

import 'package:stats_app/providers/authentication_provider.dart';
import 'package:stats_app/screens/home.dart';

import 'screens/login_screen.dart';

void main() async {
  configureInjectionDependencies();
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
    tryLoginByCookieFuture = SessionService().createAndSaveSession()
        .then((value) => AuthenticationProvider().loginByCookie());
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
            home: authenticationProvider.isAuthenticated ==
                    AuthenticatedState.authenticated
                ? const HomeScreen()
                : waitForLoginFutureAndBuildAppropriateWidget(),
          ),
        ));
  }

  FutureBuilder<dynamic> waitForLoginFutureAndBuildAppropriateWidget() {
    return FutureBuilder(
        future: tryLoginByCookieFuture,
        builder: (ctx, result) => !result.hasData
            ? const CircularProgressIndicator()
            : result.data == false
                ? const LoginScreen()
                : const HomeScreen());
  }
}
