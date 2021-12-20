import 'package:async_redux/async_redux.dart';
import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stats_app/managers/authentication/secure_cookie_service.dart';
import 'package:stats_app/managers/session_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stats_app/redux/authenticated_actions.dart';
import 'package:stats_app/redux/authentication.dart';
import 'package:stats_app/providers/monitored_clients_provider.dart';
import 'package:stats_app/redux/app_state.dart';
import 'package:stats_app/screens/collaborator_overview_screen.dart';
import 'package:stats_app/screens/overview_screen.dart';
import 'package:stats_app/screens/preferences_screen.dart';
import 'package:stats_app/screens/select_collaborators_screen.dart';

import 'screens/login_screen.dart';

var store = Store<AppState>(initialState: AppState());

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
    tryLoginByCookieFuture = Future(() async {
      await store.dispatch(LoginByCookieAction());
      return store.state.authentication.isAuthenticated;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          theme:
              ThemeData(primarySwatch: Colors.red, backgroundColor: Colors.red),
          onGenerateRoute: (RouteSettings settings) {
            print('build route for ${settings.name}');
            var routes = <String, WidgetBuilder>{
              "clientSummary": (ctx) =>
                  CollaboratorOverviewScreen(settings.arguments),
            };
            WidgetBuilder builder = routes['clientSummary']!;
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },
          routes: {
            '/': (_) => waitForLoginFutureAndBuildAppropriateWidget(),
            '/selectCollaborators': (_) => const SelectCollaborator(),
            '/preferences': (_) => const PreferencesScreen(),
            '/overviewScreen': (_) => const OverviewScreen(),
          },
        ));
  }

  FutureBuilder<dynamic> waitForLoginFutureAndBuildAppropriateWidget() {
    return FutureBuilder(
        future: tryLoginByCookieFuture,
        builder: (ctx, result) {
          return !result.hasData
              ? const CircularProgressIndicator()
              : result.data == AuthenticatedState.unauthenticated
                  ? const LoginScreen()
                  : const OverviewScreen();
        });
  }
}
