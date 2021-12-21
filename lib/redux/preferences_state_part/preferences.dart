import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stats_app/data/client_setup_item.dart';

class Preferences {
  final List<ClientSetupItem> clientUrlTokenList = [];

  List<ClientSetupItem> get filteredUrlTokenList =>
      clientUrlTokenList.where((element) => element.monitored).toList();

  Preferences() {
    List<String> list = [];
    dotenv.env.forEach((key, value) {
      list.add(value);
    });

    for (var i = 1; i <= list.length; i++) {
      if (i % 2 == 0) {
        continue;
      }

      var url = list[i];
      var token = list[i - 1];
      var name = url.substring(8).split('-basic')[0].toUpperCase();

      clientUrlTokenList.add(ClientSetupItem(url, token, name));
    }
  }
}

