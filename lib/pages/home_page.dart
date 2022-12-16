import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
// import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/pages/application_details_page.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/pages/past_applications.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/repositories/form_repository.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:smf_mobile/util/notification_helper.dart';
import 'package:smf_mobile/widgets/application_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:smf_mobile/util/connectivity_helper.dart';

// import 'dart:async';
// import 'dart:convert';

// import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  static const route = AppUrl.homePage;
  // final String applicationId;
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // Map _source = {ConnectivityResult.none: false};
  // final MyConnectivity _connectivity = MyConnectivity.instance;
  List<Application> _allApplications = [];
  final List<Application> _pendingApplications = [];
  final List<Application> _upcomingApplications = [];
  final List<Application> _pastApplications = [];
  bool _isInForeground = true;

  @override
  void initState() {
    super.initState();
    // _connectivity.initialise();
    // _connectivity.myStream.listen((source) {
    //   if (mounted) {
    //     setState(() {
    //       _source = source;
    //     });
    //   }
    // });
    // print('applicationId:' + widget.applicationId);
    WidgetsBinding.instance!.addObserver(this);
  }

  void _checkNewApplication(String applicationId) {
    // print('applicationId $applicationId');
    if (applicationId != '') {
      for (Application application in _allApplications) {
        if (application.applicationId == applicationId) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ApplicationDetailsPage(
                      application: application,
                    )),
          );
          return;
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    if (_isInForeground) {
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          // print('getInitialMessage: ${message.data}');
          _checkNewApplication(message.data['applicationId']);
        }
      });
    }
  }

  @override
  void dispose() {
    // WidgetsBinding.instance!.removeObserver(this);
    // _connectivity.disposeStream();
    super.dispose();
  }

  void _validateUser() async {
    bool tokenExpired = await Helper.isTokenExpired();
    if (tokenExpired) {
      Helper.toastMessage(AppLocalizations.of(context)!.sessionExpiredMessage);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginEmailPage(),
      ));
    }
  }

  Future<dynamic> _getForms() async {
    await Provider.of<FormRespository>(context, listen: false).getAllForms();
  }

  Future<dynamic> _syncApplications() async {
    // print('_syncApplications...');
    var synced =
        await Provider.of<ApplicationRespository>(context, listen: false)
            .submitBulkInspection();
    if (synced) {
      NotificationHelper.scheduleNotification(
          DateTime.now(),
          0,
          AppLocalizations.of(context)!.dataSynchoronized,
          AppLocalizations.of(context)!.dataSynchoronizedText,
          '');
    }
  }

  Future<dynamic> _getApplications() async {
    String rawUserId = await Helper.getUser(Storage.userId);
    String username = await Helper.getUser(Storage.username);
    int userId = int.parse(rawUserId);
    bool isInternetConnected = await Helper.isInternetConnected();
    // await Future.delayed(const Duration(milliseconds: 10));
    if (isInternetConnected) {
      _validateUser();
      await _getForms();
      await _syncApplications();
    }

    _allApplications =
        await Provider.of<ApplicationRespository>(context, listen: false)
            .getApplications(isInternetConnected);
    String _errorMessage =
        Provider.of<ApplicationRespository>(context, listen: false)
            .errorMessage;
    _pendingApplications.clear();
    _upcomingApplications.clear();
    _pastApplications.clear();
    if (_allApplications.isNotEmpty) {
      List temp = [];
      for (Application application in _allApplications) {
        if (application.scheduledDate != '') {
          temp = application.scheduledDate.split("-");
          temp = List.from(temp.reversed);
          int days = Helper.getDateDiffence(
              DateTime.now(), DateTime.parse(temp.join("-")));
          if ((days == 0) &&
              application.status == InspectionStatus.sentForInspection) {
            if (application.inspectionStatus ==
                    InspectionStatus.leadInspectorCompleted &&
                application.updatedBy == username) {
              _pastApplications.add(application);
            } else {
              _pendingApplications.add(application);
            }
          } else if (((days == 0) &&
                  application.status != InspectionStatus.sentForInspection) ||
              (days > 0)) {
            _pastApplications.add(application);
          } else {
            _upcomingApplications.add(application);
          }
        }
      }
      // print(_pendingApplications[1].inspectorDataObject);
    } else if (_errorMessage.isNotEmpty) {
      Helper.toastMessage(_errorMessage);
    }
    return _allApplications;
  }

  Future<void> _logout() async {
    await Provider.of<LoginRespository>(context, listen: false).clearData();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginEmailPage(),
    ));
  }

  Future<void> _pullRefresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 0,
          titleSpacing: 20,
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.pendingApplications,
            style: GoogleFonts.lato(
              color: AppColors.black87,
              fontSize: 16.0,
              letterSpacing: 0.12,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            SizedBox.fromSize(
                size: const Size(0, 10),
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.black87,
                  iconSize: 20,
                  onPressed: () {},
                )),
            PopupMenuButton<String>(
              // initialValue: _dropdownOptions[0],
              onSelected: (String result) {
                switch (result) {
                  case 'logout':
                    _logout();
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text(
                    AppLocalizations.of(context)!.logout,
                    style: GoogleFonts.lato(
                      color: AppColors.black87,
                      fontSize: 14.0,
                      letterSpacing: 0.12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        // Tab controller
        body: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 150,
          ),
          child: FutureBuilder(
            future: _getApplications(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return RefreshIndicator(
                    onRefresh: _pullRefresh,
                    child: ListView(children: [
                      SingleChildScrollView(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _pendingApplications.isEmpty &&
                                  _upcomingApplications.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height - 250,
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .noApplications,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black87,
                                          fontSize: 16.0,
                                          letterSpacing: 0.12,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ))
                              : const Center(),
                          _pendingApplications.isNotEmpty
                              ? Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child:
                                      Text(AppLocalizations.of(context)!.today,
                                          style: GoogleFonts.lato(
                                            color: AppColors.black87,
                                            fontSize: 16.0,
                                            letterSpacing: 0.12,
                                            fontWeight: FontWeight.w600,
                                          )),
                                )
                              : const Center(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _pendingApplications.length,
                            itemBuilder: (context, i) {
                              return ApplicationCard(
                                  application: _pendingApplications[i]);
                            },
                          ),
                          _upcomingApplications.isNotEmpty
                              ? Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: Text(
                                      AppLocalizations.of(context)!.upcoming,
                                      style: GoogleFonts.lato(
                                        color: AppColors.black87,
                                        fontSize: 16.0,
                                        letterSpacing: 0.12,
                                        fontWeight: FontWeight.w600,
                                      )),
                                )
                              : const Center(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _upcomingApplications.length,
                            itemBuilder: (context, i) {
                              return ApplicationCard(
                                application: _upcomingApplications[i],
                                isUpcomingApplication: true,
                              );
                            },
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20),
                            child: ButtonTheme(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PastApplications(
                                            pastApplications:
                                                _pastApplications)),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  // primary: Colors.white,
                                  side: const BorderSide(
                                      width: 1, color: AppColors.primaryBlue),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  // onSurface: Colors.grey,
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .viewPastApplications,
                                  style: GoogleFonts.lato(
                                      color: AppColors.primaryBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          )
                        ],
                      ))
                    ]));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }
}
