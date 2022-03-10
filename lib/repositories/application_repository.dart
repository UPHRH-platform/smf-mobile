import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/services/application_service.dart';
import 'package:smf_mobile/util/helper.dart';
// import 'dart:developer' as developer;

class ApplicationRespository with ChangeNotifier {
  late Map _data;
  List<Application> _applications = [];
  String _errorMessage = '';

  Future<dynamic> getApplications(bool internetConnected) async {
    String username = await Helper.getUser(Storage.username);
    try {
      if (internetConnected) {
        final request = await ApplicationService.getApplications();
        _data = json.decode(request.body);
        Map<String, Object> data = {
          'username': username,
          'application_data': request.body
        };
        await OfflineModel.deleteApplications(username);
        await OfflineModel.saveApplications(data);
      } else {
        var applications = await OfflineModel.getApplications(username);
        _data = json.decode(applications['application_data']);
      }
    } catch (_) {
      return _;
    }

    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    } else {
      _applications = [
        for (final item in _data['responseData']) Application.fromJson(item)
      ];
    }
    return _applications;
  }

  Future<dynamic> submitInspection(bool internetConnected, Map data) async {
    try {
      if (!internetConnected) {
        Map<String, Object> applicationData = {
          'inspector_type': Inspector.leadInspector,
          'inspection_data': data
        };
        await OfflineModel.saveInspection(applicationData);
      } else {
        final request = await ApplicationService.submitInspection(data);
        _data = json.decode(request.body);
      }
    } catch (_) {
      return _;
    }
    int statusCode;
    if (internetConnected) {
      if (_data['statusInfo']['statusCode'] != 200) {
        _errorMessage = _data['statusInfo']['errorMessage'];
      }
      statusCode = _data['statusInfo']['statusCode'];
    } else {
      statusCode = 200;
    }
    // var tData = await OfflineModel.getInspections();
    // developer.log(tData.toString());
    return statusCode;
  }

  Future<dynamic> submitConcent(bool internetConnected, Map data) async {
    try {
      if (!internetConnected) {
        Map<String, Object> applicationData = {
          'inspector_type': Inspector.assistantInspector,
          'inspection_data': data
        };
        await OfflineModel.saveInspection(applicationData);
      } else {
        final request = await ApplicationService.submitConcent(data);
        _data = json.decode(request.body);
      }
    } catch (_) {
      return _;
    }
    int statusCode;
    if (internetConnected) {
      if (_data['statusInfo']['statusCode'] != 200) {
        _errorMessage = _data['statusInfo']['errorMessage'];
      }
      statusCode = _data['statusInfo']['statusCode'];
    } else {
      statusCode = 200;
    }
    return statusCode;
  }

  String get errorMessage => _errorMessage;
}
