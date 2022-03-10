import 'package:flutter/material.dart';
import 'package:smf_mobile/pages/error_page.dart';
import 'package:smf_mobile/pages/home_page.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/pages/login_otp_page.dart';
import 'constants/app_urls.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    try {
      // final Map<String, dynamic> args = routeSettings.arguments;

      switch (routeSettings.name) {
        // case AppUrl.loginPage:
        //   return MaterialPageRoute(
        //       settings: routeSettings, builder: (_) => Login());
        case AppUrl.loginEmailPage:
          return MaterialPageRoute(
              settings: routeSettings, builder: (_) => const LoginEmailPage());

        case AppUrl.loginOtpPage:
          return MaterialPageRoute(
              settings: routeSettings,
              builder: (_) => const LoginOtpPage(
                    username: '',
                  ));

        case AppUrl.homePage:
          return MaterialPageRoute(
              settings: routeSettings, builder: (_) => const HomePage());

        default:
          return errorRoute(routeSettings);
      }
    } catch (_) {
      return errorRoute(routeSettings);
    }
  }

  static Route<dynamic> errorRoute(RouteSettings routeSettings) {
    return MaterialPageRoute(
        settings: routeSettings, builder: (_) => const ErrorPage());
  }
}
