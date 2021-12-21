import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:stats_app/data/client_setup_item.dart';
import 'package:stats_app/redux/app_state.dart';

class ClientMonitoredToggleAction extends ReduxAction<AppState> {
  final ClientSetupItem _clientSetupItem;

  ClientMonitoredToggleAction(this._clientSetupItem);

  @override
  AppState reduce() {
    state.preferences.clientUrlTokenList
        .firstWhere((element) => element == _clientSetupItem)
        .monitored = !_clientSetupItem.monitored;

    return state;
  }
}

class MonitorAllAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    for (var element in state.preferences.clientUrlTokenList) {
      element.monitored = true;
    }

    return state;
  }
}

class StopMonitorAllAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    for (var element in state.preferences.clientUrlTokenList) {
      element.monitored = false;
    }

    return state;
  }
}
