import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smf_mobile/constants/api_endpoints.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/services/base_service.dart';
// import 'dart:developer' as developer;

class UserService extends BaseService {
  UserService(HttpClient client) : super(client);

  static Future<dynamic> getAllUsers() async {
    Map requestData = {
      "active": true,
      "roleId": [inspectorRoleId]
    };
    var body = json.encode(requestData);
    Map<String, String> headers = await BaseService.getHeaders();
    final response = await http.post(Uri.parse(ApiUrl.getAllUsers),
        headers: headers, body: body);
    // developer.log(ApiUrl.getAllUsers);
    // developer.log(headers.toString());
    // developer.log(body);
    // developer.log(response.body);
    return response;
  }
}
