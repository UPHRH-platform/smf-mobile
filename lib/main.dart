import 'package:flutter/material.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'landing_page.dart';

void main() {
  runApp(MaterialApp(
    home: const LandingPage(),
    routes: <String, WidgetBuilder>{
      AppUrl.landingPage: (BuildContext context) => const LandingPage()
    },
  ));
}
  