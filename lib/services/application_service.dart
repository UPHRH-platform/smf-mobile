import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:dio/adapter.dart';
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

  static Future<dynamic> submitBulkInspection(List data) async {
    var body = json.encode(data);
    Map<String, String> headers = await BaseService.getHeaders();

    final response = await http.post(Uri.parse(ApiUrl.submitBulkInspection),
        headers: headers, body: body);
    // developer.log(ApiUrl.submitBulkInspection);
    // developer.log(body);
    // developer.log(response.body);
    return response;
  }

  static Future<dynamic> submitConcent(Map data) async {
    var body = json.encode(data);
    Map<String, String> headers = await BaseService.getHeaders();

    final response = await http.post(Uri.parse(ApiUrl.submitConcent),
        headers: headers, body: body);
    // developer.log(ApiUrl.submitConcent);
    // developer.log(body);
    // developer.log(response.body);
    return response;
  }

  static Future<dynamic> submitBulkConsent(List data) async {
    var body = json.encode(data);
    Map<String, String> headers = await BaseService.getHeaders();

    final response = await http.post(Uri.parse(ApiUrl.submitBulkConcent),
        headers: headers, body: body);
    // developer.log(ApiUrl.submitBulkConcent);
    // developer.log(body);
    // developer.log(response.body);
    return response;
  }

  static Future<dynamic> uploadImage(filepath) async {
    var dio = Dio();
    dio.options.headers = await BaseService.getHeaders();
    var formData = FormData.fromMap({
      'files': await MultipartFile.fromFile(filepath,
          filename: filepath.split("/").last)
    });
    final response = await dio.post(
      ApiUrl.fileUpload,
      data: formData,
    );
    return response.data['responseData'][0];
  }

  static Future<dynamic> deleteImage(List data) async {
    var body = json.encode(data);
    Map<String, String> headers = await BaseService.getHeaders();

    final response = await http.delete(Uri.parse(ApiUrl.deleteFile),
        headers: headers, body: body);
    Map _data = json.decode(response.body);
    return _data['responseData'];
  }
}
