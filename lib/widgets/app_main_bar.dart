import 'package:async_redux/async_redux.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stats_app/redux/app_state.dart';
import 'package:stats_app/redux/preferences_state_part/preferences.dart';
import 'package:stats_app/screens/overview_screen.dart';
import 'package:stats_app/screens/preferences_screen.dart';

class AppMainBarConnector extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppMainBarConnector(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppMainBarViewModel>(
        vm: () => AppMainBarFactory(title, this),
        builder: (ctx, vm) => AppMainBar(vm.title));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppMainBarFactory extends VmFactory<AppState, AppMainBarConnector> {
  String title;

  AppMainBarFactory(this.title, widget) : super(widget);

  @override
  Vm fromStore() => AppMainBarViewModel(title);
}

class AppMainBarViewModel extends Vm {
  final String title;

  AppMainBarViewModel(this.title);
}

class AppMainBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const AppMainBar(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  State<AppMainBar> createState() => _AppMainBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppMainBarState extends State<AppMainBar> {
  @override
  Widget build(BuildContext context) {
    var isRoutePreferences = ModalRoute.of(context)?.settings.name;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.red,
      title: Text(widget.title),
      actions: [
        if (isRoutePreferences != null)
          buildPreferencesIconButton(context),
        buildOverviewIconButton(context)
      ],
    );
  }

  IconButton buildPreferencesIconButton(BuildContext context) {
    return IconButton(
            onPressed: () {
              Navigator.push( context, MaterialPageRoute( builder: (context) => PreferencesScreenConnector()), );
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ));
  }

  IconButton buildOverviewIconButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push( context, MaterialPageRoute( builder: (context) => OverviewScreenConnector()), );
        },
        icon: const Icon(
          Icons.add_chart,
          color: Colors.white,
        ));
  }
}
