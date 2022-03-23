import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/landing_page.dart';
// import 'package:smf_mobile/constants/app_urls.dart';
// import 'package:smf_mobile/landing_page.dart';
import 'package:smf_mobile/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smf_mobile/services/login_service.dart';
// import 'package:smf_mobile/util/notification_helper.dart';

class LoginRespository with ChangeNotifier {
  late Map _data;
  late Login _loginDetails;
  String _errorMessage = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
    }
    return _data['statusInfo']['statusCode'];
  }

  Future<dynamic> generatePin(String username, String pin, String otp) async {
    try {
      final request = await LoginService.generatePin(username, pin, otp);
      _data = json.decode(request.body);
    } catch (_) {
      return _;
    }

    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    }
    return _data['responseData'];
  }

  Future<dynamic> validateOtp(context, String username, String otp,
      String identifier, String pin, bool isOtp) async {
    try {
      Map requestData = {};
      if (isOtp) {
        requestData = {'username': username, 'otp': otp};
      } else {
        requestData = {
          'username': username,
          'pin': pin,
        };
      }
      // print(requestData);
      final request = await LoginService.validateOtp(requestData);
      _data = json.decode(request.body);
    } catch (_) {
      return _;
    }
    if (_data['statusInfo']['statusCode'] != 200) {
      _errorMessage = _data['statusInfo']['errorMessage'];
    } else {
      _loginDetails = Login.fromJson(_data['responseData']);
      _storage.write(key: Storage.userId, value: '${_loginDetails.id}');
      _storage.write(key: Storage.username, value: _loginDetails.username);
      _storage.write(key: Storage.email, value: _loginDetails.email);
      _storage.write(key: Storage.firstname, value: _loginDetails.firstName);
      _storage.write(key: Storage.lastname, value: _loginDetails.lastName);
      _storage.write(key: Storage.authtoken, value: _loginDetails.authToken);
      _firebaseMessaging.getToken().then((token) async {
        final request = await LoginService.updateUserDeviceToken(
          token.toString(),
          identifier,
          _loginDetails.id,
        );
        _data = json.decode(request.body);
        // print(_data);
        if (_data['statusInfo']['statusCode'] == 200) {
          // print('_configureMessaging...');
          _configureMessaging(context);
        }
      });
    }
    return _data['statusInfo']['statusCode'];
  }

  void _configureMessaging(context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // print('onMessageOpenedApp ${message.data}');
      // await _storage.write(
      //     key: Storage.applicationId,
      //     value: '${message.data['application_id']}');
    });
  }

  Future<void> clearData() async {
    await _storage.deleteAll();
  }

  String get errorMessage => _errorMessage;
}
