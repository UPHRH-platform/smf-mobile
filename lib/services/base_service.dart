import 'dart:io';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/util/helper.dart';

abstract class BaseService {
  final HttpClient client;
  const BaseService(this.client);

  static Future<Map<String, String>> getHeaders() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
    };
    var authToken = await Helper.getUser(Storage.authtoken);
    if (authToken != '' && authToken != null) {
      headers['Authorization'] = authToken;
    }
    return headers;
  }
}
