import 'package:dio/dio.dart';

import 'package:ffw_stat_app_second/managers/session_service.dart';


import '../authenticated_exception.dart';
import 'client.dart';

class BaseFetch {
  final Dio _clientDio = Client().init();

  Future<Map<String, dynamic>> getFetch(String endpoint, Map<String, String> query, bool requiresAuthed) async {
    if(requiresAuthed) {
      var session = await SessionService().readFromStorage();

      if(session == null) {
        throw SessionDoesntExistException("doesnt exist");
      }

      query.addAll({'sessionGUID' : session.guid});
    }

    return _clientDio.get(createURL(endpoint), queryParameters: query).then((response) {

      if(response.statusCode != 200) {
        throw Exception("Something went wrong at getFetch()");
      }

      return response.data as Map<String, dynamic>;
    });
  }

  Future<Map<String, dynamic>> postFetch(String endpoint, FormData formData, bool requiresAuthed) async {
      if(requiresAuthed) {
        formData = await addSessionOrThrow(formData);
      }

      late Response<dynamic> response;
      try {

          response = await _clientDio.post(
            createURL(endpoint),
            data: formData,
          );

          if(response.statusCode != 200) {
            throw Exception('Something went wrong status:' + response.statusCode.toString());
          }

          var data = response.data;

          return Future.value(data);
      } catch (e) {
        print(e);
        return {};
      }

  }

  Future<FormData> addSessionOrThrow(FormData formData) async {
    var session = await SessionService().readFromStorage();
    if(session == null) {
      throw SessionDoesntExistException("Session does not exist.");
    }

    formData.fields.add(MapEntry('SessionGUID', session.guid));

    return formData;
  }

  String createURL(String endpoint) {
    return _clientDio.options.baseUrl + endpoint;
  }

}