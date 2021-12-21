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

  List<Column> buildClientsContainers() {
    List<Column> columnList = [];

    for (var e in store.state.preferences.clientUrlTokenList) {
      columnList.add(
          Column(children: [
            TextButton(onPressed: () {
              Navigator.of(context).pushNamed('clientSummary', arguments: {
                'authToken': e.token,
                'baseUrl': e.url,
                'collaborator': e.name
              });
            }, child: Text(e.name),),
            const Divider(),
          ],)
      );
    }

    return columnList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppMainBar('Fastforward Collaborators', () =>
          Navigator.of(context).pushNamed('/preferences'),
              () =>
              Navigator.of(context).pushNamed('/overviewScreen')),
      body: ListView(
        children: <Widget>[
          ...buildClientsContainers()
        ],
      ),
    );
  }
}
