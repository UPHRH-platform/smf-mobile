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

  void _saveApplications(String username, String applicationData) async {
    Map<String, Object> data = {
      'username': username,
      'application_data': applicationData
    };
    await OfflineModel.deleteApplications(username);
    await OfflineModel.saveApplications(data);
  }

  Future<dynamic> getApplications(bool internetConnected) async {
    String username = await Helper.getUser(Storage.username);
    try {
      if (internetConnected) {
        final request = await ApplicationService.getApplications();
        _data = json.decode(request.body);
        if (_data['statusInfo']['statusCode'] == 200) {
          _saveApplications(username, request.body);
        }
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
          'inspection_data': json.encode(data)
        };
        await OfflineModel.saveInspection(applicationData);

        // Updating application status in the database
        String username = await Helper.getUser(Storage.username);
        var rawData = await OfflineModel.getApplications(username);
        Map applicationFieldData = json.decode(rawData['application_data']);
        List applications = applicationFieldData['responseData'];
        for (int i = 0; i < applications.length; i++) {
          if (applications[i]['applicationId'] == data['applicationId']) {
            applications[i]['inspection']['status'] =
                InspectionStatus.leadInspectorCompleted;
            applications[i]['inspectorDataObject'] = data;
          }
        }

        applicationFieldData['responseData'] = applications;
        _saveApplications(username, jsonEncode(applicationFieldData));
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
    // print(_data);
    return statusCode;
  }

  Future<dynamic> submitBulkInspection() async {
    List<Map> inspections = [];
    List<Map> consents = [];
    Map data1 = {}, data2 = {};
    bool response = false;
    List<Map> attachments = [];
    try {
      List<Map> rawInspections = await OfflineModel.getInspections();
      for (var inspection in rawInspections) {
        Map inspectionData = jsonDecode(inspection['inspection_data']);
        attachments =
            await OfflineModel.getAttachments(inspectionData['applicationId']);
        for (var attachment in attachments) {
          String temp = json.encode(inspectionData);
          String fileUrl =
              await ApplicationService.uploadImage(attachment['attachment']);
          temp = temp.replaceAll(attachment['attachment'], fileUrl);
          inspectionData = json.decode(temp);
        }
        if (inspection['inspector_type'] == Inspector.leadInspector) {
          inspections.add(inspectionData);
        } else {
          consents.add(inspectionData);
        }
      }
      if (inspections.isNotEmpty) {
        final request1 =
            await ApplicationService.submitBulkInspection(inspections);
        data1 = json.decode(request1.body);
      }
      if (consents.isNotEmpty) {
        final request2 = await ApplicationService.submitBulkConsent(consents);
        data2 = json.decode(request2.body);
      }
    } catch (_) {
      return false;
    }
    if (data1['statusInfo'] != null && data2['statusInfo'] != null) {
      if (data1['statusInfo']['statusCode'] != 200 ||
          data2['statusInfo']['statusCode'] != 200) {
        _errorMessage = _data['statusInfo']['errorMessage'];
      }
    }
    if ((inspections.isNotEmpty && data1['statusInfo']['statusCode'] == 200) ||
        (consents.isNotEmpty && data2['statusInfo']['statusCode'] == 200)) {
      for (var attachment in attachments) {
        await OfflineModel.deleteAttachments(attachment['attachment']);
      }
      await OfflineModel.deleteInspections();
      response = true;
    }
    // print(_errorMessage);
    // print('Data synced');
    return response;
  }

  Future<dynamic> submitConcent(bool internetConnected, Map data) async {
    try {
      if (!internetConnected) {
        Map<String, Object> applicationData = {
          'inspector_type': Inspector.assistantInspector,
          'inspection_data': data
        };
        await OfflineModel.saveInspection(applicationData);

        // Updating application status in the database
        String username = await Helper.getUser(Storage.username);
        var rawData = await OfflineModel.getApplications(username);
        Map applicationFieldData = json.decode(rawData['application_data']);
        List applications = applicationFieldData['responseData'];

        for (int i = 0; i < applications.length; i++) {
          if (applications[i]['applicationId'] == data['applicationId']) {
            applications[i]['status'] = InspectionStatus.inspectionCompleted;
          }
        }
        applicationFieldData['responseData'] = applications;
        _saveApplications(username, jsonEncode(applicationFieldData));
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
