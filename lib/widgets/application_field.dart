import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';
// import './../../constants.dart';

class ApplicationField extends StatefulWidget {
  final String fieldName;
  final String fieldValue;
  const ApplicationField({
    Key? key,
    required this.fieldName,
    required this.fieldValue,
  }) : super(key: key);
  @override
  _ApplicationFieldState createState() => _ApplicationFieldState();
}

class _ApplicationFieldState extends State<ApplicationField> {
  String _radioValue = 'Correct';
  final List<String> _options = ['Correct', 'Incorrect'];
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future _displayCommentDialog() {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Stack(
                children: [
                  Align(
                    alignment: FractionalOffset.topCenter,
                    child: Container(
                        margin: const EdgeInsets.only(top: 150),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        height: 285,
                        width: MediaQuery.of(context).size.width - 40,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      controller: _noteController,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.multiline,
                                      minLines:
                                          8, //Normal textInputField will be displayed
                                      maxLines: 8, // wh
                                      // controller: notesController,
                                      style: const TextStyle(
                                          color: AppColors.black87,
                                          fontSize: 14),
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
                                                width: 1,
                                                color: AppColors.primaryBlue),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          style: TextButton.styleFrom(
                                            // primary: Colors.white,
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            backgroundColor:
                                                AppColors.primaryBlue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
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
                  ),
                ],
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.field);
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
                            widget.fieldValue,
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
                        color: AppColors.scaffoldBackground,
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
                                    'Is the given information found correct?',
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
                                        Container(
                                            padding: const EdgeInsets.only(
                                                right: 15),
                                            margin: const EdgeInsets.only(
                                                right: 15),
                                            decoration: BoxDecoration(
                                              color: _radioValue == _options[i]
                                                  ? AppColors.radioSelected
                                                  : Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4.0)),
                                              border: Border.all(
                                                color:
                                                    _radioValue == _options[i]
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
                                                  setState(() {
                                                    _radioValue = _options[i];
                                                  });
                                                  if (_options[i] ==
                                                      'Incorrect') {
                                                    _displayCommentDialog();
                                                  }
                                                },
                                              ),
                                              Text(
                                                _options[i],
                                                style: GoogleFonts.lato(
                                                  color: AppColors.black87,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.25,
                                                ),
                                              ),
                                            ])),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: IconButton(
                                          onPressed: () =>
                                              _displayCommentDialog(),
                                          icon: const Icon(
                                            Icons.message,
                                            color: AppColors.black40,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              _noteController.text.isNotEmpty
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
                                        _noteController.text,
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
