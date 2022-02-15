import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/pages/application_details_page.dart';

class ApplicationCard extends StatefulWidget {
  static const route = AppUrl.homePage;
  final Application application;

  const ApplicationCard({Key? key, required this.application})
      : super(key: key);
  @override
  _ApplicationCardState createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<ApplicationCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ApplicationDetailsPage(
                        applicationTitle: widget.application.title,
                        applicationFields: widget.application.dataObject,
                      )),
            ),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: AppColors.black16, offset: Offset(0, 2), blurRadius: 2)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(widget.application.title,
                    style: GoogleFonts.lato(
                      color: AppColors.black87,
                      fontSize: 16.0,
                      letterSpacing: 0.12,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(widget.application.createdBy,
                    style: GoogleFonts.lato(
                      color: AppColors.black60,
                      fontSize: 14.0,
                      letterSpacing: 0.12,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Scheduled on: ${widget.application.createdDate}',
                    style: GoogleFonts.lato(
                      color: AppColors.black60,
                      fontSize: 14.0,
                      letterSpacing: 0.12,
                      fontWeight: FontWeight.w400,
                    )),
              )
            ],
          ),
        ));
  }
}
