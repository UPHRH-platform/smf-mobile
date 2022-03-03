import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/pages/past_applications.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:smf_mobile/widgets/application_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  static const route = AppUrl.homePage;

  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Application> _allApplications = [];
  final List<Application> _pendingApplications = [];
  final List<Application> _upcomingApplications = [];
  final List<Application> _pastApplications = [];
  @override
  void initState() {
    super.initState();
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

  Future<dynamic> _getApplications() async {
    _validateUser();
    _allApplications =
        await Provider.of<ApplicationRespository>(context, listen: false)
            .getApplications();
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
          if (days == 0) {
            _pendingApplications.add(application);
          } else if (days > 0) {
            _pastApplications.add(application);
          } else {
            _upcomingApplications.add(application);
          }
        }
      }
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
                    'Logout',
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
                                    child: Text('No applications at the moment',
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
                                  application: _upcomingApplications[i]);
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
