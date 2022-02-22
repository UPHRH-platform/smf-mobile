import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:smf_mobile/services/form_service.dart';
import 'package:smf_mobile/models/form_model.dart';
// import 'dart:developer' as developer;

class FormRespository with ChangeNotifier {
  late Map _data;
  late FormData _formData;
  String _errorMessage = '';

  Future<dynamic> getFormDetails(int formId) async {
    try {
      final request = await FormService.getFormDetails(formId);
      _data = json.decode(request.body);
    } catch (_) {
      return _;
    }
    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    } else {
      _formData = FormData.fromJson(_data['responseData']);
    }
    return _formData;
  }

  String get errorMessage => _errorMessage;
}
