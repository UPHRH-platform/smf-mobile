import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smf_mobile/constants/api_endpoints.dart';
import 'package:smf_mobile/services/base_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'dart:developer' as developer;

class ApplicationService extends BaseService {
  ApplicationService(HttpClient client) : super(client);

  static Future<dynamic> getApplications() async {
    Map requestData = {'searchObjects': []};
    var body = json.encode(requestData);
    Map<String, String> headers = BaseService.defaultHeaders;
    const _storage = FlutterSecureStorage();
    var authToken = await _storage.read(key: 'authToken');
    headers['Authorization'] = '$authToken';
    final response = await http.post(Uri.parse(ApiUrl.getAllApplications),
        headers: BaseService.defaultHeaders, body: body);
    return response;
  }
}
