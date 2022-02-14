import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/pages/home_page.dart';

// import 'dart:developer' as developer;

class InspectionCompletedPage extends StatefulWidget {
  static const route = AppUrl.inspectionSummary;

  const InspectionCompletedPage({Key? key}) : super(key: key);
  @override
  _InspectionCompletedPageState createState() =>
      _InspectionCompletedPageState();
}

class _InspectionCompletedPageState extends State<InspectionCompletedPage> {
  @override
  void initState() {
    super.initState();
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
            'Inspection Completed',
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
                height: MediaQuery.of(context).size.height - 100,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 45,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: const BoxDecoration(
                          color: AppColors.black08,
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/thumb_up.png',
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Inspection completed',
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontSize: 20.0,
                              letterSpacing: 0.12,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        style: TextButton.styleFrom(
                          // primary: Colors.white,
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          backgroundColor: AppColors.primaryBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: AppColors.black16)),
                        ),
                        child: Text(
                          'View pending appllications',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}
