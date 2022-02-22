import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smf_mobile/constants/api_endpoints.dart';
import 'package:smf_mobile/services/base_service.dart';
// import 'dart:developer' as developer;

class FormService extends BaseService {
  FormService(HttpClient client) : super(client);

  static Future<dynamic> getFormDetails(int formId) async {
    Map<String, String> headers = await BaseService.getHeaders();

    final response = await http.get(
        Uri.parse(ApiUrl.getFormDetails + formId.toString()),
        headers: headers);
    // developer.log(ApiUrl.getAllUsers);
    // developer.log(headers.toString());
    // developer.log(response.body);
    return response;
  }
}
