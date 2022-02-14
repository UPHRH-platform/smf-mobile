import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:smf_mobile/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smf_mobile/services/login_service.dart';

class LoginRespository with ChangeNotifier {
  late Map _data;
  late Login _loginDetails;
  String _errorMessage = '';

  final _storage = const FlutterSecureStorage();

  Future<dynamic> getOtp(String username) async {
    try {
      final request = await LoginService.getOtp(username);
      _data = json.decode(request.body);
    } catch (_) {
      return _;
    }

    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    } else {
      _storage.write(key: 'username', value: username);
    }
    return _data['statusInfo']['statusCode'];
  }

  Future<dynamic> validateOtp(String otp) async {
    try {
      final username = await _storage.read(key: 'username');
      final request = await LoginService.validateOtp(username!, otp);
      _data = json.decode(request.body);
    } catch (_) {
      return _;
    }
    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    } else {
      _loginDetails = Login.fromJson(_data['responseData']);
      _storage.write(key: 'id', value: '${_loginDetails.id}');
      _storage.write(key: 'username', value: _loginDetails.username);
      _storage.write(key: 'email', value: _loginDetails.email);
      _storage.write(key: 'firstName', value: _loginDetails.firstName);
      _storage.write(key: 'lastName', value: _loginDetails.lastName);
      _storage.write(key: 'authToken', value: _loginDetails.authToken);
    }
    return _data['statusInfo']['statusCode'];
  }

  Future<void> clearData() async {
    await _storage.deleteAll();
  }

  String get errorMessage => _errorMessage;
}