import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class Storable<T> {
  abstract final String key;
  T fromJson(Map<String, dynamic> json);

  final storage = const FlutterSecureStorage();
  final T? data = null;

  Future<void> writeToStorage(T data) async {
    return storage.write(key: key, value: json.encode(data));
  }

  Future<T?> readFromStorage() {
    return storage.read(key: key).then((value) {
      if(value == null) {
        return null;
      }
      return fromJson(json.decode(value));
    });
  }

  void deleteFromStorage() {
    storage.delete(key: key);
  }
}