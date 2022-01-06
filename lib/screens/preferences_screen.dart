import 'package:async_redux/async_redux.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:stats_app/data/client_setup_item.dart';
import 'package:stats_app/redux/app_state.dart';
import 'package:stats_app/redux/preferences_state_part/preferences_actions.dart';
import 'package:stats_app/widgets/app_main_bar.dart';

class PreferencesScreenConnector extends StatelessWidget {
  const PreferencesScreenConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, PreferencesScreenViewModel>(
    vm: () => PreferencesScreenFactory(),
    builder: (BuildContext context, PreferencesScreenViewModel vm) {
      return PreferencesScreen(vm.clientSetupItems, vm.onToggleClient, vm.onTurnOnAll, vm.onTurnOffAll);
    },
  );

}

class PreferencesScreenFactory extends VmFactory<AppState, PreferencesScreenConnector> {
  @override
  Vm fromStore() {
    return PreferencesScreenViewModel(
      state.preferences.clientSetupItems,
          (ClientSetupItem clientItem) => dispatch(ClientMonitoredToggleAction(clientItem)),
          () => dispatch(MonitorAllAction()),
          () => dispatch(StopMonitorAllAction()),
    );
  }
}

class PreferencesScreenViewModel extends Vm {
  final IList<ClientSetupItem> clientSetupItems;
  final Function(ClientSetupItem clientItem) onToggleClient;
  final Function onTurnOffAll;
  final Function onTurnOnAll;

  PreferencesScreenViewModel(
      this.clientSetupItems,
      this.onToggleClient,
      this.onTurnOnAll,
      this.onTurnOffAll) : super(equals: [...clientSetupItems, clientSetupItems.map((element) => element.monitored)]);
}

class PreferencesScreen extends StatelessWidget {
  final IList<ClientSetupItem> clientUrlTokenList;
  final Function(ClientSetupItem clientItem) onToggleClient;
  final Function onTurnOffAll;
  final Function onTurnOnAll;

  const PreferencesScreen(this.clientUrlTokenList, this.onToggleClient, this.onTurnOnAll, this.onTurnOffAll, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMainBarConnector('Preferences',),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildToggleOnSwitchRow(),
              buildToggleOffSwitchRow()
            ],
          ),
          ...buildClientPreferenceRow()
        ],
      ),
    );
  }

  Row buildToggleOffSwitchRow() {
    return Row(
      children: [
        const Text(
          'Off',
          style: TextStyle(color: Colors.red),
        ),
        Switch(
            value: clientUrlTokenList.every((element) => !element.monitored),
            activeColor: Colors.red,
            onChanged: (_) {
              onTurnOffAll();
            }),
      ],
    );
  }

  Row buildToggleOnSwitchRow() {
    return Row(
      children: [
        const Text(
          'On',
          style: TextStyle(color: Colors.red),
        ),
        Switch(
            value: clientUrlTokenList.every((element) => element.monitored),
            activeColor: Colors.red,
            onChanged: (_) {
              onTurnOnAll();
            }),
      ],
    );
  }

  List<Column> buildClientPreferenceRow() {
    List<Column> list = [];

    for (var clientItem in clientUrlTokenList) {
      list.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(clientItem.name),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Switch(
                    value: clientItem.monitored,
                    activeColor: Colors.red,
                    onChanged: (_) =>
                        dispatchToggleMonitored(clientItem)),
              ),
            ],
          ),
          const Divider(),
        ],
      ));
    }

    return list;
  }

  void dispatchToggleMonitored(
      ClientSetupItem clientItem) {
    onToggleClient(clientItem);
  }
}

