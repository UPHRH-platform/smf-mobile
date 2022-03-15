import 'dart:math';
import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const _storage = FlutterSecureStorage();

class Helper {
  static String getInitials(String name) {
    String shortCode = 'UN';
    name = name.replaceAll(RegExp(r'\s+'), ' ');
    List temp = name.split(' ');
    if (temp.length > 1) {
      shortCode = temp[0][0].toUpperCase() + temp[1][0].toUpperCase();
    } else if (temp[0] != '') {
      shortCode = temp[0][0].toUpperCase() + temp[0][1].toUpperCase();
    }
    return shortCode;
  }

  static Future<dynamic> getUser(String key) async {
    var value = await _storage.read(key: key);
    return value;
  }

  static Future<void> setUser(String key, String value) async {
    _storage.write(key: key, value: value);
  }

  static int getDateDiffence(DateTime today, DateTime dateTimeCreatedAt) {
    // print('$today, $dateTimeCreatedAt');
    // String month = today.month < 10 ? '0${today.month}' : '${today.month}';
    // DateTime dateTimeNow = DateTime.parse('${today.year}-03-${today.day}');
    final differenceInDays = today.difference(dateTimeCreatedAt).inDays;
    return differenceInDays;
  }

  static Future<bool> isTokenExpired() async {
    bool isTokenExpired = true;
    var authToken = await _storage.read(key: Storage.authtoken);
    if (authToken != null && authToken != '') {
      isTokenExpired = JwtDecoder.isExpired(authToken);
    }
    return isTokenExpired;
  }

  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static getUniqueId() {
    DateTime _now = DateTime.now();
    var random = Random();
    int id1 = random.nextInt(99999);
    int id2 = random.nextInt(99999);
    int notificationId = id1 + id2 + _now.millisecond;
    return notificationId;
  }

  static formatDate(String date) {
    List temp = date.split("-");
    temp = List.from(temp.reversed);
    return DateFormat.yMMMEd().format(DateTime.parse(temp.join('-')));
  }

  static capitalize(String string) => string.isNotEmpty
      ? '${string[0].toUpperCase()}${string.substring(1).toLowerCase()}'
      : '';

  static getInspectionStatus(BuildContext context, String status) {
    String _inspectionStatus = '';
    switch (status) {
      case InspectionStatus.inspectionCompleted:
        _inspectionStatus = AppLocalizations.of(context)!.completed;
        break;
      case InspectionStatus.sentForInspection:
        _inspectionStatus = AppLocalizations.of(context)!.sentForInspection;
        break;
      case InspectionStatus.leadInspectorCompleted:
        _inspectionStatus =
            AppLocalizations.of(context)!.leadInspectorCompleted;
        break;
      default:
        _inspectionStatus = capitalize(status);
    }
    // print(_inspectionStatus);
    return _inspectionStatus;
  }

  // static bool isInternetConnected(source) {
  //   bool connected;
  //   switch (source.keys.toList()[0]) {
  //     case ConnectivityResult.mobile:
  //       print('connected to mobile...');
  //       connected = true;
  //       break;
  //     case ConnectivityResult.wifi:
  //       print('connected to wifi...');
  //       connected = true;
  //       break;
  //     case ConnectivityResult.none:
  //     default:
  //       print('offline mode...');
  //       connected = false;
  //   }
  //   return connected;
  // }

  static Future<bool> isInternetConnected() async {
    bool _isConnectionSuccessful;
    try {
      final response = await InternetAddress.lookup('www.google.com');
      _isConnectionSuccessful = response.isNotEmpty;
    } on SocketException catch (e) {
      _isConnectionSuccessful = false;
    }
    return _isConnectionSuccessful;
  }
}
