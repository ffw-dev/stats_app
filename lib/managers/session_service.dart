
import 'package:stats_app/api/api_endpoints/session_endpoints.dart';
import 'package:stats_app/models/session.dart';

import 'storable.dart';

class SessionService extends Storable<Session> {
  @override
  String get key => "session";

  Future<Session> createAndSaveSession() async {
    var response = await SessionEndpoints.createSessionGet();
    var session = response.body.results[0];

    await writeToStorage(session);

    return session;
  }

  @override
  Session fromJson(Map<String, dynamic> json) {
    return Session.fromJson(json);
  }
}