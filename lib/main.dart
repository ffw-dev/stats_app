import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stats_app/managers/session_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stats_app/providers/authentication_provider.dart';
import 'package:stats_app/screens/collaborator_overview_screen.dart';
import 'package:stats_app/screens/overview_screen.dart';
import 'package:stats_app/screens/select_collaborators_screen.dart';

import 'screens/login_screen.dart';

void main() async {
  configureInjectionDependencies();
  await dotenv.load(fileName: ".env");
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
              backgroundColor: Colors.red
            ),
            onGenerateRoute: (RouteSettings settings) {
              print('build route for ${settings.name}');
              var routes = <String, WidgetBuilder>{
                "clientSummary": (ctx) => CollaboratorOverviewScreen(settings.arguments),
              };
              WidgetBuilder builder = routes['clientSummary']!;
              return MaterialPageRoute(builder: (ctx) => builder(ctx));
            },
            routes: {
              '/': (_) => waitForLoginFutureAndBuildAppropriateWidget(),
              '/selectCollaborators': (_) => const SelectCollaborator(),
            },
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
                : const OverviewScreen());
  }
}
