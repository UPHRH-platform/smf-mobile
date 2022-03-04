import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/services/application_service.dart';
import 'package:smf_mobile/util/helper.dart';

class ApplicationRespository with ChangeNotifier {
  late Map _data;
  List<Application> _applications = [];
  String _errorMessage = '';

  Future<dynamic> getApplications(bool internetConnected) async {
    String rawUserId = await Helper.getUser(Storage.userId);
    int userId = int.parse(rawUserId);
    try {
      if (internetConnected) {
        final request = await ApplicationService.getApplications();
        _data = json.decode(request.body);
        Map<String, Object> data = {
          'user_id': userId,
          'application_data': request.body
        };
        await OfflineModel.deleteApplications(userId);
        await OfflineModel.saveApplications(data);
      } else {
        var applications = await OfflineModel.getApplications(userId);
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

  Future<dynamic> submitInspection(Map data) async {
    try {
      final request = await ApplicationService.submitInspection(data);
      _data = json.decode(request.body);
    } catch (_) {
      return _;
    }

    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    }
    return _data['statusInfo']['statusCode'];
  }

  String get errorMessage => _errorMessage;
}
