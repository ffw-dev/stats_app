import 'package:dev_basic_api/main.dart';
import 'package:dotenv/dotenv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    List<String> mapTolist = [];

    dotenv.env.forEach((key, value) {
      mapTolist.add(value);
    });

    for(var i = 1; i <= mapTolist.length; i++) {
      if(i % 2 != 0) {
        var url = mapTolist[i];
        var token = mapTolist[i-1];
        var collaborator = url.substring(8);
        collaborator = collaborator.split('-basic')[0].toUpperCase();

        columnList.add(
            Column(children: [
              TextButton(onPressed: () {
                Navigator.of(context).pushNamed('clientSummary', arguments: {
                  'authToken': token,
                  'baseUrl': url,
                  'collaborator': collaborator
                });
              }, child: Text(collaborator),),
              const Divider(),
            ],)
        );
      }
    }

    return columnList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppMainBar('Fastforward Collaborators'),
      body: ListView(
        children: <Widget>[
          ...buildClientsContainers()
        ],
      ),
    );
  }
}
