import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stats_app/data/client_setup_item.dart';
import 'package:stats_app/redux/app_state.dart';

class ClientMonitoredToggleAction extends ReduxAction<AppState> {
  final ClientSetupItem _clientSetupItem;

  ClientMonitoredToggleAction(this._clientSetupItem);

  @override
  AppState reduce() {
    var isClientMonitored = _clientSetupItem.monitored;

    SharedPreferences.getInstance().then((value) {
      value.setBool(_clientSetupItem.name, !isClientMonitored);
    });

    state.preferences.clientSetupItems
        .firstWhere((element) => element == _clientSetupItem)
        .monitored = !_clientSetupItem.monitored;

    state.preferences.clientSetupItems = IList(state.preferences.clientSetupItems);

    return state.copy(authentication: state.authentication, preferences: state.preferences);
  }
}

class MonitorAllAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    for (var element in state.preferences.clientSetupItems) {
      element.monitored = true;
      SharedPreferences.getInstance().then((value) => value.setBool(element.name, true));
    }

    state.preferences.clientSetupItems = IList(state.preferences.clientSetupItems);
    
    return state.copy(authentication: state.authentication, preferences: state.preferences);
  }
}

class StopMonitorAllAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    for (var element in state.preferences.clientSetupItems) {
      element.monitored = false;
      SharedPreferences.getInstance().then((value) => value.setBool(element.name, false));
    }

    return state.copy(authentication: state.authentication, preferences: state.preferences);  }
}
