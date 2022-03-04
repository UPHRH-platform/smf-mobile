import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/models/login_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smf_mobile/services/login_service.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:smf_mobile/util/notification_helper.dart';

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
    } else {
      _storage.write(key: 'username', value: username);
    }
    return _data['statusInfo']['statusCode'];
  }

  Future<dynamic> validateOtp(context, String otp, String identifier) async {
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

  _configureMessaging(context) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('message.notification...');
      if (message.notification != null) {
        // int uniqueNotificationId = Helper.getUniqueId();
        String body = message.notification!.body.toString();
        NotificationHelper.scheduleNotification(context, DateTime.now(), 0,
            message.notification!.title.toString(), body);
      }
      print('Message data: $message');
    });
    return;
  }

  Future<void> clearData() async {
    await _storage.deleteAll();
  }

  String get errorMessage => _errorMessage;
}
