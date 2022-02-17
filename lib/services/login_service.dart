import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smf_mobile/constants/api_endpoints.dart';
import 'package:smf_mobile/services/base_service.dart';
import 'package:smf_mobile/util/helper.dart';
// import 'dart:developer' as developer;

class LoginService extends BaseService {
  LoginService(HttpClient client) : super(client);

  static Future<dynamic> getOtp(String username) async {
    Map requestData = {
      'username': username,
    };
    var body = json.encode(requestData);
    Map<String, String> headers = await Helper.getHeaders();
    final response =
        await http.post(Uri.parse(ApiUrl.getOtp), headers: headers, body: body);
    return response;
  }

  static Future<dynamic> validateOtp(String username, String otp) async {
    Map requestData = {'username': username, 'otp': otp};
    var body = json.encode(requestData);
    Map<String, String> headers = await Helper.getHeaders();
    final response = await http.post(Uri.parse(ApiUrl.validateOtp),
        headers: headers, body: body);
    return response;
  }
}
