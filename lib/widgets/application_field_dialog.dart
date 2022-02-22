import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/widgets/questions/text_question.dart';

class ApplicationFieldDialog extends StatefulWidget {
  final String summaryText;
  final String inspectionValue;
  final String fieldType;
  final ValueChanged<Map> parentAction;
  const ApplicationFieldDialog({
    Key? key,
    required this.summaryText,
    required this.inspectionValue,
    required this.fieldType,
    required this.parentAction,
  }) : super(key: key);

  @override
  _ApplicationFieldDialogState createState() => _ApplicationFieldDialogState();
}

class _ApplicationFieldDialogState extends State<ApplicationFieldDialog> {
  final TextEditingController _summaryController = TextEditingController();
  String _inspectionValue = '';
  bool inspectionUpdated = false;
  Map data = {};
  @override
  void initState() {
    super.initState();
    _summaryController.text = widget.summaryText;
  }

  saveData(String inspectionValue) {
    setState(() {
      _inspectionValue = inspectionValue;
    });
    // _submitData();
  }

  _submitData() {
    data = {
      'summaryText': _summaryController.text,
      'inspectionValue': _inspectionValue
    };
    widget.parentAction(data);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
            alignment: FractionalOffset.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(4)),
              constraints: const BoxConstraints(minHeight: 300, maxHeight: 400),
              width: MediaQuery.of(context).size.width - 40,
              child: Material(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 290,
                      child: ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  'Enter the reason for the incorrect selection',
                                  style: GoogleFonts.lato(
                                    color: AppColors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: 0.25,
                                  ),
                                )),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.black16),
                              ),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                child: Focus(
                                  child: TextFormField(
                                    autofocus: true,
                                    controller: _summaryController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    minLines:
                                        8, //Normal textInputField will be displayed
                                    maxLines: 8, // wh
                                    // controller: notesController,
                                    style: const TextStyle(
                                        color: AppColors.black87, fontSize: 14),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type here',
                                      hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: AppColors.black60),
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Actual value(s)',
                                  style: GoogleFonts.lato(
                                    color: AppColors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: 0.25,
                                  ),
                                )),
                            widget.fieldType == FieldType.text ||
                                    widget.fieldType == FieldType.numeric ||
                                    widget.fieldType == FieldType.email
                                ? TextQuestion(
                                    fieldType: widget.fieldType,
                                    answerGiven: widget.inspectionValue,
                                    parentAction: saveData)
                                : const Center(),
                          ]),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonTheme(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
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
                                  'Cancel',
                                  style: GoogleFonts.lato(
                                      color: AppColors.primaryBlue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  _submitData();
                                },
                                style: TextButton.styleFrom(
                                  // primary: Colors.white,
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  backgroundColor: AppColors.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: const BorderSide(
                                          color: AppColors.black16)),
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
                            )
                          ],
                        ))
                  ],
                ),
              )),
            )),
      ],
    );
  }
}
