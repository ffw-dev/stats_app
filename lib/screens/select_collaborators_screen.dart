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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppMainBar('Fastforward Collaborators'),
      body: Column(
        children: <Widget>[
          TextButton(onPressed: () { 
            Navigator.of(context).pushNamed('clientSummary', arguments: {
              'authToken': dotenv.env['SVT0TOKEN'],
              'baseUrl': dotenv.env['SVT0BASEURL'],
              'collaborator': 'SVT-0'
            });
          }, child: const Text('SVT0'),),
          Divider(),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamed('clientSummary', arguments: {
              'authToken': dotenv.env['SVT1TOKEN'],
              'baseUrl': dotenv.env['SVT1BASEURL'],
              'collaborator': 'SVT-1'
            });
          }, child: const Text('SVT1'),),
          Divider(),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamed('clientSummary', arguments: {
              'authToken': dotenv.env['SVT2TOKEN'],
              'baseUrl': dotenv.env['SVT2BASEURL'],
              'collaborator': 'SVT-2'
            });
          }, child: const Text('SVT2'),),
          Divider(),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamed('clientSummary', arguments: {
              'authToken': dotenv.env['BBCBRISTOLTOKEN'],
              'baseUrl': dotenv.env['BBCBRISTOLBASEURL'],
              'collaborator': 'BBC-Bristol'
            });
          }, child: const Text('BBC-Bristol'),),
          Divider(),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamed('clientSummary', arguments: {
              'authToken': dotenv.env['YFETOKEN'],
              'baseUrl': dotenv.env['YFEBASEURL'],
              'collaborator': 'YFE'
            });
          }, child: const Text('YFE'),),
          Divider(),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamed('clientSummary', arguments: {
              'authToken': dotenv.env['RTE0TOKEN'],
              'baseUrl': dotenv.env['RTE0BASEURL'],
              'collaborator': 'RTE-0'
            });
          }, child: const Text('RTE-0'),),
          Divider(),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamed('clientSummary', arguments: {
              'authToken': dotenv.env['RTE1TOKEN'],
              'baseUrl': dotenv.env['RTE1BASEURL'],
              'collaborator': 'RTE-1'
            });
          }, child: const Text('RTE-1'),),
        ],
      ),
    );
  }
}
