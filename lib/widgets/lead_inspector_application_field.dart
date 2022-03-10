import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/widgets/lead_inspector_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeadInspectorApplicationField extends StatefulWidget {
  final String fieldName;
  final Map fieldData;
  final String fieldType;
  final List fieldOptions;
  final String applicationStatus;
  final ValueChanged<Map> parentAction;
  const LeadInspectorApplicationField({
    Key? key,
    required this.fieldName,
    required this.fieldData,
    required this.fieldType,
    required this.fieldOptions,
    required this.applicationStatus,
    required this.parentAction,
  }) : super(key: key);
  @override
  _LeadInspectorApplicationFieldState createState() =>
      _LeadInspectorApplicationFieldState();
}

class _LeadInspectorApplicationFieldState
    extends State<LeadInspectorApplicationField> {
  late Map _data;
  late String _radioValue;
  String _inspectionValue = '';
  String _summaryText = '';
  final List<String> _options = [FieldValue.correct, FieldValue.inCorrect];

  @override
  void initState() {
    super.initState();

    _data = widget.fieldData[widget.fieldData.keys.elementAt(0)];
    // print('Field: ' + _data.toString());
    _radioValue = _data[_data.keys.elementAt(0)];
    _summaryText = _data[_data.keys.elementAt(1)];
    try {
      _inspectionValue = _data[_data.keys.elementAt(2)];
    } catch (_) {
      return;
    }
  }

  triggerUpdate(Map dialogData) {
    Map data = {
      widget.fieldName: {
        widget.fieldData.keys.elementAt(0): {
          'value': _radioValue,
          'comments': dialogData['summaryText'],
          'inspectionValue': dialogData['inspectionValue']
        }
      }
    };
    // print(data);
    setState(() {
      _summaryText = dialogData['summaryText'];
      _inspectionValue = dialogData['inspectionValue'];
    });
    widget.parentAction(data);
  }

  Future _displayCommentDialog() {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return LeadInspectorDialog(
                summaryText: _summaryText,
                inspectionValue: _inspectionValue,
                fieldType: widget.fieldType,
                fieldOptions: widget.fieldOptions,
                parentAction: triggerUpdate,
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    // if (_data != widget.fieldData[widget.fieldData.keys.elementAt(0)]) {
    //   _radioValue = _data[_data.keys.elementAt(0)];
    //   _summaryText = _data[_data.keys.elementAt(1)];
    // }
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
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(bottom: 0),
                                  child: Row(
                                    // alignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      for (int i = 0; i < _options.length; i++)
                                        InkWell(
                                            onTap: () {
                                              // print(_options[i]);
                                              if (widget.applicationStatus !=
                                                  InspectionStatus
                                                      .inspectionCompleted) {
                                                setState(() {
                                                  _radioValue = _options[i];
                                                });
                                                if (_options[i] ==
                                                    FieldValue.inCorrect) {
                                                  _displayCommentDialog();
                                                }
                                                Map data = {
                                                  'summaryText': _summaryText,
                                                  'inspectionValue':
                                                      _inspectionValue
                                                };
                                                triggerUpdate(data);
                                              }
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    right: 15),
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                decoration: BoxDecoration(
                                                  color: _radioValue ==
                                                          _options[i]
                                                      ? AppColors.radioSelected
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  border: Border.all(
                                                    color: _radioValue ==
                                                            _options[i]
                                                        ? AppColors.primaryBlue
                                                        : AppColors.black16,
                                                  ),
                                                ),
                                                child: Row(children: [
                                                  Radio(
                                                    value: _options[i],
                                                    groupValue: _radioValue,
                                                    activeColor:
                                                        AppColors.primaryBlue,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    onChanged: (val) {
                                                      if (widget
                                                              .applicationStatus !=
                                                          InspectionStatus
                                                              .inspectionCompleted) {
                                                        setState(() {
                                                          _radioValue =
                                                              _options[i];
                                                        });
                                                        Map data = {
                                                          'summaryText':
                                                              _summaryText,
                                                          'inspectionValue':
                                                              _inspectionValue
                                                        };
                                                        triggerUpdate(data);
                                                        if (_options[i] ==
                                                            FieldValue
                                                                .inCorrect) {
                                                          _displayCommentDialog();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    _options[i],
                                                    style: GoogleFonts.lato(
                                                      color: AppColors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.25,
                                                    ),
                                                  ),
                                                ]))),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: IconButton(
                                          onPressed: () {
                                            if (widget.applicationStatus !=
                                                    InspectionStatus
                                                        .inspectionCompleted &&
                                                _radioValue !=
                                                    FieldValue.correct) {
                                              _displayCommentDialog();
                                            }
                                          },
                                          icon:
                                              _radioValue != FieldValue.correct
                                                  ? const Icon(
                                                      Icons.edit,
                                                      color: AppColors.black40,
                                                    )
                                                  : const Icon(
                                                      Icons.message,
                                                      color: AppColors.black40,
                                                    ),
                                        ),
                                      )
                                    ],
                                  )),
                              _radioValue != FieldValue.correct &&
                                      _summaryText != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColors.black16),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _summaryText,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : const Center(),
                              _radioValue != FieldValue.correct &&
                                      _inspectionValue != ''
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        widget.fieldName,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                        ),
                                      ))
                                  : const Center(),
                              _radioValue != FieldValue.correct &&
                                      _inspectionValue != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColors.black16),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _inspectionValue,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : const Center()
                            ],
                          )))
                ])));
  }
}