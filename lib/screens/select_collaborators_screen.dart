import 'package:dev_basic_api/main.dart';
import 'package:dotenv/dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stats_app/main.dart';
import 'package:stats_app/widgets/app_main_bar.dart';

class SelectCollaborator extends StatefulWidget {
  const SelectCollaborator({Key? key}) : super(key: key);

  @override
  State<SelectCollaborator> createState() => _SelectCollaboratorState();
}

class _SelectCollaboratorState extends State<SelectCollaborator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMainBarConnector(
        'Fastforward Collaborators',
      ),
      body: ListView(
        children: <Widget>[...buildClientsContainers()],
      ),
    );
  }

  List<Column> buildClientsContainers() {
    List<Column> columnList = [];

    for (var clientItem in store.state.preferences.clientSetupItems) {
      columnList.add(Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('clientSummary', arguments: {
                'authToken': clientItem.token,
                'baseUrl': clientItem.url,
                'collaborator': clientItem.name
              });
            },
            child: Text(clientItem.name),
          ),
          const Divider(),
        ],
      ));
    }

    return columnList;
  }
}
