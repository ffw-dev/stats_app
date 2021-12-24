import 'package:async_redux/async_redux.dart';
import 'package:dev_basic_api/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:stats_app/managers/authentication/secure_cookie_service.dart';
import 'package:stats_app/managers/session_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stats_app/redux/authentication_state_part/authenticated_actions.dart';
import 'package:stats_app/redux/authentication_state_part/authentication.dart';
import 'package:stats_app/redux/app_state.dart';
import 'package:stats_app/redux/preferences_state_part/preferences.dart';
import 'package:stats_app/screens/collaborator_overview_screen.dart';
import 'package:stats_app/screens/overview_screen.dart';
import 'package:stats_app/screens/preferences_screen.dart';
import 'package:stats_app/screens/select_collaborators_screen.dart';

import 'screens/login_screen.dart';

var store = Store<AppState>(initialState: AppState());

void main() async {
  configureInjectionDependencies();
  await dotenv.load(fileName: ".env");
  await store.state.initState();
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
    tryLoginByCookieFuture = store
        .dispatchFuture(LoginByCookieAction())
        .then((value) => store.state.authentication.isAuthenticated);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncReduxProvider<AppState>.value(
        value: store,
        child: MaterialApp(
          theme:
              ThemeData(primarySwatch: Colors.red, backgroundColor: Colors.red),
          onGenerateRoute: (RouteSettings settings) {
            print(settings.name);
            var routes = <String, WidgetBuilder>{
              "clientSummary": (ctx) =>
                  CollaboratorOverviewScreen(settings.arguments),
            };

            WidgetBuilder builder = routes[settings.name]!;
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },
          routes: {
            '/': (_) => waitForLoginFutureAndBuildAppropriateWidget(),
            '/selectCollaborators': (_) => const SelectCollaborator(),
            '/overviewScreen': (_) => const OverviewScreen(),
            '/preferences': (ctx) => const PreferencesScreen()
          },
        ));
  }

  FutureBuilder<dynamic> waitForLoginFutureAndBuildAppropriateWidget() {
    return FutureBuilder(
        future: tryLoginByCookieFuture,
        builder: (ctx, result) {
          return !result.hasData
              ? const CircularProgressIndicator()
              : result.data != AuthenticatedState.authenticated
                  ? const LoginScreen()
                  : const OverviewScreen();
        });
  }
}
