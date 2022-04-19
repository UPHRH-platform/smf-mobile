import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smf_mobile/constants/api_endpoints.dart';
import 'package:smf_mobile/services/base_service.dart';
// import 'dart:developer' as developer;

class LoginService extends BaseService {
  LoginService(HttpClient client) : super(client);

  static Future<dynamic> getOtp(String username) async {
    Map requestData = {
      'username': username,
      'isMobile': true,
    };
    var body = json.encode(requestData);
    Map<String, String> headers = await BaseService.getHeaders();
    final response =
        await http.post(Uri.parse(ApiUrl.getOtp), headers: headers, body: body);
    return response;
  }

  static Future<dynamic> validateOtp(Map requestData) async {
    var body = json.encode(requestData);
    Map<String, String> headers = await BaseService.getHeaders();
    final response = await http.post(Uri.parse(ApiUrl.validateOtp),
        headers: headers, body: body);
    // developer.log(ApiUrl.validateOtp);
    // developer.log(jsonEncode(requestData));
    // developer.log(response.body);
    return response;
  }

  static Future<dynamic> generatePin(
      String username, String pin, String otp) async {
    Map requestData = {
      'username': username,
      'pin': pin,
      'otp': otp,
    };
    var body = json.encode(requestData);
    Map<String, String> headers = await BaseService.getHeaders();
    final response = await http.post(Uri.parse(ApiUrl.generatePin),
        headers: headers, body: body);
    // developer.log(ApiUrl.generatePin);
    // developer.log(jsonEncode(requestData));
    // developer.log(response.body);
    return response;
  }

  static Future<dynamic> updateUserDeviceToken(
      String token, String identifier, int userId) async {
    Map requestData = {
      "deviceToken": token,
      "deviceId": identifier,
      "userId": userId
    };
    var body = json.encode(requestData);
    Map<String, String> headers = await BaseService.getHeaders();
    final response = await http.post(Uri.parse(ApiUrl.updateUserDeviceToken),
        headers: headers, body: body);
    return response;
  }

  static Future<dynamic> deleteDeviceToken(String identifier) async {
    Map<String, String> headers = await BaseService.getHeaders();
    final response = await http.delete(
      Uri.parse(ApiUrl.deleteDeviceToken + identifier),
      headers: headers,
    );
    return response;
  }
}
