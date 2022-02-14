import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/pages/past_applications.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/widgets/application_card.dart';

// import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  static const route = AppUrl.homePage;

  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _getApplications(context);
  }

  Future<dynamic> _getApplications(context) async {
    List<Application> applications =
        await Provider.of<ApplicationRespository>(context, listen: false)
            .getApplications();
    return applications;
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
            'Pending applications',
            style: GoogleFonts.lato(
              color: AppColors.black87,
              fontSize: 16.0,
              letterSpacing: 0.12,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        // Tab controller
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 150,
          ),
          child: FutureBuilder(
            future: _getApplications(context),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<Application> _todaysApplications = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text('Today',
                          style: GoogleFonts.lato(
                            color: AppColors.black87,
                            fontSize: 16.0,
                            letterSpacing: 0.12,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _todaysApplications.length,
                      itemBuilder: (context, i) {
                        return ApplicationCard(
                            application: _todaysApplications[i]);
                      },
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text('Upcoming',
                          style: GoogleFonts.lato(
                            color: AppColors.black87,
                            fontSize: 16.0,
                            letterSpacing: 0.12,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _todaysApplications.length,
                      itemBuilder: (context, i) {
                        return ApplicationCard(
                            application: _todaysApplications[i]);
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
                                      pastApplications: _todaysApplications)),
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
                            'View past applications',
                            style: GoogleFonts.lato(
                                color: AppColors.primaryBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )));
  }
}
