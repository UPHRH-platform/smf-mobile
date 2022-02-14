import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';

class PeopleCard extends StatelessWidget {
  const PeopleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 80,
            decoration: BoxDecoration(
              color: AppColors.black08,
              borderRadius: BorderRadius.circular(4),
              // border: Border.all(color: AppColors.black08),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Center(
                      child: Text('SM',
                          style: GoogleFonts.lato(color: Colors.white)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shoaib Muhammed',
                          style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Designation',
                            style: GoogleFonts.lato(
                                color: AppColors.black60,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
