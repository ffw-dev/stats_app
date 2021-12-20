import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stats_app/widgets/app_main_bar.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  List<String> client_url_token_list = [];

  @override
  void initState() {
    super.initState();

    dotenv.env.forEach((key, value) {
      client_url_token_list.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppMainBar('Preferences'),
      body: ListView(
        children: [
          ...buildContainerList()
        ],
      ),
    );
  }

  List<Column> buildContainerList() {
    List<Column> list = [];

    for (var i = 1; i <= client_url_token_list.length; i++) {
      if (i % 2 != 0) {
        var url = client_url_token_list[i];
        var token = client_url_token_list[i - 1];
        var collaborator = url.substring(8);
        collaborator = collaborator.split('-basic')[0].toUpperCase();

        list.add(Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('clientSummary',
                          arguments: {
                            'authToken': token,
                            'baseUrl': url,
                            'collaborator': collaborator
                          });
                    },
                    child: Text(collaborator),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Switch(
                      value: true, activeColor: Colors.red, onChanged: (_) {}),
                ),
              ],
            ),
            const Divider(),
          ],
        ));
      }
    }

    return list;
  }
}

class ClientSetupPreferencesItem {
  final String value;
  bool isMonitored = true;

  ClientSetupPreferencesItem(this.value);

  void toggleIsMonitored() {
    isMonitored = !isMonitored;
  }
}
