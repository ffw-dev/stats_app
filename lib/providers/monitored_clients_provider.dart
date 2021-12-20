import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MonitoredClientsProvider with ChangeNotifier {
  List<ClientSetupItem> clientUrlTokenList = [];

  MonitoredClientsProvider() {
    List<String> list = [];
    dotenv.env.forEach((key, value) {
      list.add(value);
    });

    for(var i = 1; i <= list.length; i++) {
      if(i % 2 == 0) {
        continue;
      }

      var url = list[i];
      var token = list[i-1];

      clientUrlTokenList.add(ClientSetupItem(url, token));
    }

  }
}

class ClientSetupItem {
  String url;
  String token;
  bool monitored = true;

  ClientSetupItem(this.url, this.token);
}