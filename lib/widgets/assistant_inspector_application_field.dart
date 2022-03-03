import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smf_mobile/util/helper.dart';

class AssistantInspectorApplicationField extends StatefulWidget {
  final String fieldName;
  final Map fieldData;
  final Map leadInspectorData;
  final ValueChanged<Map> parentAction;
  const AssistantInspectorApplicationField({
    Key? key,
    required this.fieldName,
    required this.fieldData,
    required this.leadInspectorData,
    required this.parentAction,
  }) : super(key: key);
  @override
  _AssistantInspectorApplicationFieldState createState() =>
      _AssistantInspectorApplicationFieldState();
}

class _AssistantInspectorApplicationFieldState
    extends State<AssistantInspectorApplicationField> {
  String _radioValue = '';
  String _inspectionValue = '';
  String _inspectionComment = '';
  String _noteText = '';

  @override
  void initState() {
    super.initState();
    try {
      _inspectionComment = widget.leadInspectorData['comments'];
      _radioValue = widget.leadInspectorData['value'];
      _inspectionValue = widget.leadInspectorData['inspectionValue'];
    } catch (_) {
      return;
    }
    // print('$_inspectionComment, $_radioValue, $_inspectionValue');
  }

  triggerUpdate(Map dialogData) {
    Map data = {
      widget.fieldName: {
        widget.fieldData.keys.elementAt(0): {
          'value': _radioValue,
          'comments': dialogData['noteText'],
          'inspectionValue': dialogData['inspectionValue']
        }
      }
    };
    // print(data);
    setState(() {
      _noteText = dialogData['noteText'];
      _inspectionValue = dialogData['inspectionValue'];
    });
    widget.parentAction(data);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        reverse: true,
        child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      color: Colors.white,
                      boxShadow: [
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
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.fieldName,
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontSize: 14.0,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.black16),
                          ),
                          child: Text(
                            widget.fieldData.keys.elementAt(0),
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontSize: 14.0,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                        color: AppColors.fieldBackground,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.black16,
                              offset: Offset(0, 2),
                              blurRadius: 2)
                        ],
                      ),
                      child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .isGivenInformationCorrect,
                                    style: GoogleFonts.lato(
                                      color: AppColors.black60,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                      letterSpacing: 0.25,
                                    ),
                                  )),
                              Container(
                                // width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(bottom: 0),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                    border: Border.all(
                                      color: AppColors.black16,
                                    ),
                                  ),
                                  child: Text(
                                    Helper.capitalize(_radioValue),
                                    style: GoogleFonts.lato(
                                      color: AppColors.black87,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      letterSpacing: 0.25,
                                    ),
                                  ),
                                ),
                              ),
                              _radioValue == 'incorrect'
                                  ? Wrap(children: [
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            'Reason for the incorrect selection',
                                            style: GoogleFonts.lato(
                                              color: AppColors.black60,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                              letterSpacing: 0.25,
                                            ),
                                          )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 15, 10),
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            border: Border.all(
                                              color: AppColors.black08,
                                            ),
                                          ),
                                          child: Text(
                                            _inspectionComment,
                                            style: GoogleFonts.lato(
                                              color: AppColors.black87,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                              letterSpacing: 0.25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .actualValue,
                                            style: GoogleFonts.lato(
                                              color: AppColors.black60,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.0,
                                              letterSpacing: 0.25,
                                            ),
                                          )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 0),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 10, 15, 10),
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4.0)),
                                            border: Border.all(
                                              color: AppColors.black08,
                                            ),
                                          ),
                                          child: Text(
                                            _inspectionValue,
                                            style: GoogleFonts.lato(
                                              color: AppColors.black87,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                              letterSpacing: 0.25,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //     width:
                                      //         MediaQuery.of(context).size.width,
                                      //     padding:
                                      //         const EdgeInsets.only(top: 20),
                                      //     child: Text(
                                      //       "Instiute's comment",
                                      //       style: GoogleFonts.lato(
                                      //         color: AppColors.black60,
                                      //         fontWeight: FontWeight.w700,
                                      //         fontSize: 14.0,
                                      //         letterSpacing: 0.25,
                                      //       ),
                                      //     )),
                                      // Container(
                                      //   width:
                                      //       MediaQuery.of(context).size.width,
                                      //   margin:
                                      //       const EdgeInsets.only(bottom: 0),
                                      //   child: Container(
                                      //     padding: const EdgeInsets.fromLTRB(
                                      //         15, 10, 15, 10),
                                      //     margin:
                                      //         const EdgeInsets.only(top: 10),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.white,
                                      //       borderRadius:
                                      //           const BorderRadius.all(
                                      //               Radius.circular(4.0)),
                                      //       border: Border.all(
                                      //         color: AppColors.black08,
                                      //       ),
                                      //     ),
                                      //     child: Text(
                                      //       'Omne animal, simul atque integre iudicante itaque turbent.',
                                      //       style: GoogleFonts.lato(
                                      //         color: AppColors.black87,
                                      //         fontWeight: FontWeight.w400,
                                      //         fontSize: 14.0,
                                      //         letterSpacing: 0.25,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ])
                                  : const Center()
                            ],
                          ))),
                ])));
  }
}
