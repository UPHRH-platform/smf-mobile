import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/pages/home_page.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'constants/app_constants.dart';
import 'constants/app_urls.dart';
import 'constants/color_constants.dart';
import 'routes.dart';

class LandingPage extends StatefulWidget {
  static const route = AppUrl.landingPage;

  const LandingPage({Key? key}) : super(key: key);
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final client = HttpClient();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: LoginRespository()),
          ChangeNotifierProvider.value(value: ApplicationRespository()),
        ],
        child: MaterialApp(
          title: appName,
          theme: ThemeData(
              scaffoldBackgroundColor: AppColors.scaffoldBackground,
              primaryColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              dividerColor: AppColors.black08,
              canvasColor: Colors.white,
              unselectedWidgetColor: AppColors.black40),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.generateRoute,
          onUnknownRoute: Routes.errorRoute,
          home: const LoginEmailPage(),
          // home: const HomePage(),
        ));
  }
}
