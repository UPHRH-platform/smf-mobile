import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  static int getDateDiffence(DateTime today, DateTime dateTimeCreatedAt) {
    String month = today.month < 10 ? '0${today.month}' : '${today.month}';
    DateTime dateTimeNow = DateTime.parse('${today.year}-$month-${today.day}');
    final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;
    return differenceInDays;
  }

  static Future<bool> isTokenExpired() async {
    bool isTokenExpired = true;
    var authToken = await _storage.read(key: 'authToken');
    isTokenExpired = JwtDecoder.isExpired(authToken!);
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
}
