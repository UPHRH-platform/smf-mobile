import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

abstract class BaseService {
  final HttpClient client;
  const BaseService(this.client);

  static Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
    };
    var authToken = await _storage.read(key: 'smf_user_auth_token');
    if (authToken != '' && authToken != null) {
      headers['Authorization'] = authToken;
    }
    return headers;
  }
}
