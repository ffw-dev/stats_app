
import 'package:dev_basic_api/main.dart';

import 'storable.dart';

class SessionService extends Storable<Session> {
  @override
  String get key => "session";

  Future<Session> createAndSaveSession() async {
    var response = await DevBasicApi.sessionEndpoints.createSessionGet();
    var session = response.body.results[0];

    await writeToStorage(session);

    return session;
  }

  @override
  Session fromJson(Map<String, dynamic> json) {
    return Session.fromJson(json);
  }
}