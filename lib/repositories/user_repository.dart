import 'dart:convert';
import 'package:flutter/widgets.dart';
// import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/services/user_service.dart';

class UserRespository with ChangeNotifier {
  late Map _data;
  // List<Application> _applications = [];
  String _errorMessage = '';

  Future<dynamic> getAllUsers() async {
    try {
      final request = await UserService.getAllUsers();
      _data = json.decode(request.body);
    } catch (_) {
      return _;
    }

    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    }
    return _data;
  }

  String get errorMessage => _errorMessage;
}
