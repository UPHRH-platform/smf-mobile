import 'package:jwt_decoder/jwt_decoder.dart';

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

  static int getDateDiffence(DateTime today, DateTime dateTimeCreatedAt) {
    String month = today.month < 10 ? '0${today.month}' : '${today.month}';
    DateTime dateTimeNow = DateTime.parse('${today.year}-$month-${today.day}');
    final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;
    return differenceInDays;
  }

  static bool isTokenExpired(String token) {
    bool isTokenExpired = JwtDecoder.isExpired(token);
    return isTokenExpired;
  }
}
