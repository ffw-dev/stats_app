
import 'package:ffw_stat_app_second/models/session.dart';

import '../base_fetch.dart';
import '../base_response.dart';

class SessionEndpoints {
  static Future<BaseResponse<Session>> createSessionGet() async {
    var response = await BaseFetch().getFetch("Session/Create", {}, false);
    var data = response;

    return BaseResponse.fromApi<Session>(data, (data) => Session.fromJson(data));
  }
}

