import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smf_mobile/constants/api_endpoints.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/services/base_service.dart';
// import 'dart:developer' as developer;

class ApplicationService extends BaseService {
  ApplicationService(HttpClient client) : super(client);

  static Future<dynamic> getApplications() async {
    Map requestData = {'status': InspectionStatus.sentForInspection};
    var body = json.encode(requestData);
    Map<String, String> headers = await BaseService.getHeaders();

    final response = await http.post(Uri.parse(ApiUrl.getAllApplications),
        headers: headers, body: body);
    // developer.log(response.body);
    return response;
  }

  static Future<dynamic> submitInspection(Map data) async {
    var body = json.encode(data);
    Map<String, String> headers = await BaseService.getHeaders();

    final response = await http.post(Uri.parse(ApiUrl.submitInspection),
        headers: headers, body: body);
    // developer.log(ApiUrl.submitInspection);
    // developer.log(body);
    // developer.log(response.body);
    return response;
  }
}
