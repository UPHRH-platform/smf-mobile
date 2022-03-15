import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/pages/home_page.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/repositories/form_repository.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:smf_mobile/repositories/user_repository.dart';
import 'package:smf_mobile/services/application_service.dart';
import 'package:smf_mobile/util/helper.dart';
import 'constants/app_constants.dart';
import 'constants/app_urls.dart';
import 'constants/color_constants.dart';
import 'routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LandingPage extends StatefulWidget {
  static const route = AppUrl.landingPage;

  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
  static _LandingPageState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LandingPageState>();
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('firebaseMessagingBackgroundHandler...');
  bool tokenExpired = await Helper.isTokenExpired();
  if (!tokenExpired) {
    saveApplications();
    submitBulkInspection();
  }
  // BuildContext context;
  // if (message.notification != null) {
  //   String applicationId = message.data['applicationId'] ?? '';
  //   String body = message.notification!.body.toString();
  // for (int i = 0; i < 10; i++) {
  // NotificationHelper.scheduleNotification(DateTime.now(), 0,
  //     message.notification!.title.toString(), body, applicationId);
  // }
}

void saveApplications() async {
  print('saveApplications...');
  Map _data;
  final request = await ApplicationService.getApplications();
  _data = json.decode(request.body);
  if (_data['statusInfo']['statusCode'] == 200) {
    String username = await Helper.getUser(Storage.username);
    Map<String, Object> data = {
      'username': username,
      'application_data': request.body
    };
    await OfflineModel.deleteApplications(username);
    await OfflineModel.saveApplications(data);
  }
}

void submitBulkInspection() async {
  print('submitBulkInspection...');
  List<Map> inspections = [];
  List<Map> consents = [];
  try {
    List<Map> rawInspections = await OfflineModel.getInspections();
    for (var inspection in rawInspections) {
      if (inspection['inspector_type'] == Inspector.leadInspector) {
        inspections.add(jsonDecode(inspection['inspection_data']));
      } else {
        consents.add(jsonDecode(inspection['inspection_data']));
      }
    }
    if (inspections.isNotEmpty) {
      await ApplicationService.submitBulkInspection(inspections);
    }
    if (consents.isNotEmpty) {
      await ApplicationService.submitBulkConsent(consents);
    }
  } catch (_) {
    // print(_);
  }
}

class _LandingPageState extends State<LandingPage> {
  final client = HttpClient();
  Locale _locale = const Locale('en', 'US');
  bool _isTokenExpired = false;
  // final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  Future<dynamic> _initilizeApp(context) async {
    _isTokenExpired = await Helper.isTokenExpired();
    await Firebase.initializeApp();
    // await Future.delayed(const Duration(microseconds: 100));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.scaffoldBackground,
        child: FutureBuilder(
            // Initialize FlutterFire
            future: _initilizeApp(context),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              // Check for errors
              if (snapshot.hasData) {
                return MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(value: LoginRespository()),
                      ChangeNotifierProvider.value(
                          value: ApplicationRespository()),
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
                      home: !_isTokenExpired
                          ? const HomePage()
                          : const LoginEmailPage(),
                      // home: const HomePage(),
                    ));
              } else {
                return const Center();
              }
            }));
  }
}
