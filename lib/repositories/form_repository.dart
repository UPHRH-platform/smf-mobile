import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/services/form_service.dart';
import 'package:smf_mobile/models/form_model.dart';
import 'package:smf_mobile/util/helper.dart';
// import 'dart:developer' as developer;

class FormRespository with ChangeNotifier {
  late Map _data;
  late FormData _formData;
  String _errorMessage = '';

  Future<dynamic> getAllForms() async {
    List forms = [];
    try {
      String username = await Helper.getUser(Storage.username);
      final request = await FormService.getAllForms();
      _data = json.decode(request.body);
      if (_data['statusInfo']['statusCode'] == 200) {
        Map<String, Object> data = {
          'username': username,
          'form_data': request.body
        };
        await OfflineModel.deleteForms(username);
        await OfflineModel.saveForms(data);
        // Map<dynamic, dynamic> _forms = await OfflineModel.getForms(username);
        // print(request.body);
      }
    } catch (_) {
      return _;
    }
    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    } else {
      forms = _data['responseData'];
    }
    return forms;
  }

  // Future<dynamic> getFormDetails(int formId) async {
  //   try {
  //     final request = await FormService.getFormDetails(formId);
  //     _data = json.decode(request.body);
  //   } catch (_) {
  //     return _;
  //   }
  //   if (_data['statusInfo']['statusCode'] != 200) {
  //     _errorMessage = _data['statusInfo']['errorMessage'];
  //   } else {
  //     _formData = FormData.fromJson(_data['responseData']);
  //   }
  //   return _formData;
  // }

  Future<dynamic> getFormDetails(int formId) async {
    Map<String, dynamic> formDetails = {};
    try {
      String username = await Helper.getUser(Storage.username);
      var rawData = await OfflineModel.getForms(username);
      Map formData = json.decode(rawData['form_data']);
      List forms = formData['responseData'];
      for (var form in forms) {
        if (form['id'] == formId) {
          formDetails = form;
        }
      }
      if (formDetails['id'] == null) {
        return;
      }
    } catch (_) {
      return _;
    }
    if (formDetails.isNotEmpty) {
      _formData = FormData.fromJson(formDetails);
    }
    return _formData;
  }

  String get errorMessage => _errorMessage;
}
