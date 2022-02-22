import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/pages/home_page.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/repositories/form_repository.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:smf_mobile/repositories/user_repository.dart';
import 'constants/app_constants.dart';
import 'constants/app_urls.dart';
import 'constants/color_constants.dart';
import 'routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingPage extends StatefulWidget {
  static const route = AppUrl.landingPage;

  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
  static _LandingPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LandingPageState>();
}

class _LandingPageState extends State<LandingPage> {
  final client = HttpClient();
  Locale _locale = const Locale('en', 'US');

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: LoginRespository()),
          ChangeNotifierProvider.value(value: ApplicationRespository()),
          ChangeNotifierProvider.value(value: UserRespository()),
          ChangeNotifierProvider.value(value: FormRespository()),
        ],
        child: MaterialApp(
          title: appName,
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            // Locale('es', 'ES'),
          ],
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
