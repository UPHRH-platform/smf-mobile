import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssistantInspectorDialog extends StatefulWidget {
  final String noteText;
  final String status;
  final ValueChanged<Map> parentAction;
  const AssistantInspectorDialog({
    Key? key,
    required this.noteText,
    required this.status,
    required this.parentAction,
  }) : super(key: key);

  @override
  _AssistantInspectorDialogState createState() =>
      _AssistantInspectorDialogState();
}

class _AssistantInspectorDialogState extends State<AssistantInspectorDialog> {
  final TextEditingController _noteController = TextEditingController();
  bool inspectionUpdated = false;
  Map data = {};
  @override
  void initState() {
    super.initState();
    _noteController.text = widget.noteText;
  }

  _saveData(bool status) {
    Map data = {'status': status, 'note': _noteController.text};
    widget.parentAction(data);
  }

  saveNoteText(String text) {}

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
              constraints: const BoxConstraints(minHeight: 290, maxHeight: 290),
              width: MediaQuery.of(context).size.width - 40,
              child: Material(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 185,
                      child: ListView(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  'Add note',
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
                                    // autofocus: true,
                                    enabled: widget.status ==
                                            InspectionStatus.inspectionCompleted
                                        ? false
                                        : true,
                                    controller: _noteController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    minLines:
                                        8, //Normal textInputField will be displayed
                                    maxLines: 8, // wh
                                    onEditingComplete: () {
                                      SystemChannels.textInput
                                          .invokeMethod('TextInput.hide');
                                      return;
                                    },
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
                          ]),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ButtonTheme(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  if (widget.status !=
                                      InspectionStatus.inspectionCompleted) {
                                    _saveData(false);
                                  }
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
                            const Spacer(),
                            ButtonTheme(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  if (widget.status !=
                                      InspectionStatus.inspectionCompleted) {
                                    _saveData(true);
                                  }
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
                                  'Skip',
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
                                  if (widget.status !=
                                      InspectionStatus.inspectionCompleted) {
                                    _saveData(true);
                                  }
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
