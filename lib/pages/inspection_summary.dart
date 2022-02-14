import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/widgets/people_card.dart';

import 'inspection_completed.dart';

// import 'dart:developer' as developer;

class InspectionSummaryPage extends StatefulWidget {
  static const route = AppUrl.inspectionSummary;

  const InspectionSummaryPage({Key? key}) : super(key: key);
  @override
  _InspectionSummaryPageState createState() => _InspectionSummaryPageState();
}

class _InspectionSummaryPageState extends State<InspectionSummaryPage> {
  final List<String> _dropdownItems = [
    'Select from the list',
    'Somorjit Phuritshabam',
    'Shoaib Muhammed'
  ];
  String _selectedItem = 'Select from the list';

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
            'Inspection Summary',
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
            child: Column(children: [
          Container(
            // height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: AppColors.black16,
                    offset: Offset(0, 2),
                    blurRadius: 2)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                    child: Text(
                      'Enter summary of this inspection',
                      style: GoogleFonts.lato(
                        color: AppColors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.25,
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.black16),
                  ),
                  child: TextFormField(
                    // autofocus: true,
                    // focusNode: _notesFocus,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.multiline,
                    minLines: 10, //Normal textInputField will be displayed
                    maxLines: 15, // wh
                    // controller: notesController,
                    style:
                        const TextStyle(color: AppColors.black87, fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type here',
                      hintStyle:
                          TextStyle(fontSize: 14.0, color: AppColors.black60),
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                    child: Text(
                      'People accopanied you',
                      style: GoogleFonts.lato(
                        color: AppColors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.25,
                      ),
                    )),
                // Container(
                //     margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                //     child: Row(children: [
                //       Container(
                //           padding: const EdgeInsets.only(right: 10),
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(4),
                //             border: Border.all(color: AppColors.black16),
                //           ),
                //           child: DropdownButton<String>(
                //             value: _selectedItem,
                //             icon: const Icon(
                //               Icons.arrow_drop_down_outlined,
                //               color: AppColors.black60,
                //             ),
                //             iconSize: 20,
                //             elevation: 16,
                //             style: const TextStyle(
                //                 color: AppColors.black60, fontSize: 12),
                //             underline: Container(),
                //             selectedItemBuilder: (BuildContext context) {
                //               return _dropdownItems.map<Widget>((String item) {
                //                 return Row(
                //                   children: [
                //                     Padding(
                //                         padding: const EdgeInsets.fromLTRB(
                //                             20.0, 0.0, 20, 0.0),
                //                         child: Text(
                //                           item,
                //                           style: GoogleFonts.lato(
                //                             color: AppColors.black60,
                //                             fontSize: 12,
                //                             fontWeight: FontWeight.w400,
                //                           ),
                //                         ))
                //                   ],
                //                 );
                //               }).toList();
                //             },
                //             onChanged: (newValue) {
                //               setState(() {
                //                 _selectedItem = newValue.toString();
                //               });
                //             },
                //             items: _dropdownItems
                //                 .map<DropdownMenuItem<String>>((String value) {
                //               return DropdownMenuItem<String>(
                //                 value: value,
                //                 child: Text(value),
                //               );
                //             }).toList(),
                //           )),
                //       const Spacer(),
                //       ButtonTheme(
                //         child: OutlinedButton(
                //           onPressed: () {
                //             // Navigator.of(context).pop(false);
                //           },
                //           style: OutlinedButton.styleFrom(
                //             // primary: Colors.white,
                //             padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                //             side: const BorderSide(
                //                 width: 1, color: AppColors.primaryBlue),
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(4),
                //             ),
                //             // onSurface: Colors.grey,
                //           ),
                //           child: Text(
                //             'Add',
                //             style: GoogleFonts.lato(
                //                 color: AppColors.primaryBlue,
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w700),
                //           ),
                //         ),
                //       ),
                //     ])),
                for (int i = 0; i < 3; i++) const PeopleCard(),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                          value: true,
                          activeColor: AppColors.primaryBlue,
                          onChanged: (newValue) {
                            // setState(() {
                            //   checkBoxValue = newValue;
                            // });),
                          }),
                      Container(
                          padding: const EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width - 120,
                          child: Text(
                            'Sunt autem vel illum, qui dolorem aspernari ut calere ignem, nivem esse albam, dulce mel quorum nihil ut ita ruant itaque earum rerum necessitatibus saepe eveniet, ut labore et aperta iudicari ea commodi consequatur? quis autem vel eum iure reprehenderit, qui in liberos atque corrupti.',
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontSize: 12.0,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w400,
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: const EdgeInsets.only(right: 20, bottom: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const InspectionCompletedPage()));
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
                    'Submit',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ))
        ])));
  }
}
