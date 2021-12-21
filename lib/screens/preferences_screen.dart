import 'package:async_redux/src/store.dart';
import 'package:flutter/material.dart';
import 'package:provider_for_redux/provider_for_redux.dart';
import 'package:stats_app/data/client_setup_item.dart';
import 'package:stats_app/main.dart';
import 'package:stats_app/redux/app_state.dart';
import 'package:stats_app/redux/preferences_state_part/preferences_actions.dart';
import 'package:stats_app/widgets/app_main_bar.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<ClientSetupItem> get client_url_token_list =>
      store.state.preferences.clientUrlTokenList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReduxConsumer<AppState>(
      builder: (ctx, store, state, dispatch, child) => Scaffold(
        appBar: AppMainBar('Preferences', () => null, () =>
            Navigator.of(context).popAndPushNamed('/overviewScreen')),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text('On', style: TextStyle(color: Colors.red),),
                    Switch(
                        value: client_url_token_list
                            .every((element) => element.monitored),
                        activeColor: Colors.red,
                        onChanged: (_) {
                          setState(() {
                            dispatch(MonitorAllAction());
                          });
                        }),
                  ],
                ),
                Row(
                  children: [
                    const Text('Off', style: TextStyle(color: Colors.red),),
                    Switch(
                        value: client_url_token_list
                            .every((element) => !element.monitored),
                        activeColor: Colors.red,
                        onChanged: (_) {
                          setState(() {
                            dispatch(StopMonitorAllAction());
                          });
                        }),
                  ],
                )
              ],
            ),
            ...buildContainerList(dispatch)
          ],
        ),
      ),
    );
  }

  List<Column> buildContainerList(Dispatch dispatch) {
    List<Column> list = [];

    for (var clientItem in client_url_token_list) {
      list.add(Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('clientSummary', arguments: {
                      'authToken': clientItem.token,
                      'baseUrl': clientItem.url,
                      'collaborator': clientItem.name
                    });
                  },
                  child: Text(clientItem.name),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Switch(
                    value: clientItem.monitored,
                    activeColor: Colors.red,
                    onChanged: (_) {
                      setState(() {
                        dispatch(ClientMonitoredToggleAction(clientItem));
                      });
                    }),
              ),
            ],
          ),
          const Divider(),
        ],
      ));
    }

    return list;
  }
}
