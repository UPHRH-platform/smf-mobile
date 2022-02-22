import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/widgets/application_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PastApplications extends StatefulWidget {
  final List<Application> pastApplications;
  const PastApplications({Key? key, required this.pastApplications})
      : super(key: key);
  @override
  _PastApplicationsState createState() => _PastApplicationsState();
}

class _PastApplicationsState extends State<PastApplications> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 10,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: const BackButton(color: AppColors.black60),
          title: Text(
            AppLocalizations.of(context)!.pastApplications,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.pastApplications.length,
                itemBuilder: (context, i) {
                  return ApplicationCard(
                      application: widget.pastApplications[i]);
                },
              ),
            ],
          ),
        )));
  }
}
