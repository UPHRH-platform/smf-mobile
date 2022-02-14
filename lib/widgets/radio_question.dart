import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';
// import './../../constants.dart';

class RadioQuestion extends StatefulWidget {
  final String question;
  final int currentIndex;
  final String answerGiven;
  const RadioQuestion({
    Key? key,
    required this.question,
    required this.currentIndex,
    required this.answerGiven,
  }) : super(key: key);
  @override
  _RadioQuestionState createState() => _RadioQuestionState();
}

class _RadioQuestionState extends State<RadioQuestion> {
  int _radioValue = 0;
  final List<String> _options = ['Correct', 'Incorrect'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   _radioValue = widget.answerGiven;
    // });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.question,
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
                Container(
                    padding: const EdgeInsets.only(right: 15),
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: _radioValue == 1
                          ? AppColors.radioSelected
                          : Colors.transparent,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(
                        color: _radioValue == 1
                            ? AppColors.primaryBlue
                            : AppColors.black16,
                      ),
                    ),
                    child: Row(children: [
                      Radio(
                        value: 1,
                        groupValue: _radioValue,
                        activeColor: AppColors.primaryBlue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (val) {
                          setState(() {
                            _radioValue = 1;
                          });
                        },
                      ),
                      Text(
                        'Correct',
                        style: GoogleFonts.lato(
                          color: AppColors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ])),
                Container(
                    padding: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                        color: _radioValue == 0
                            ? AppColors.radioSelected
                            : Colors.transparent,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        border: Border.all(
                          color: _radioValue == 0
                              ? AppColors.primaryBlue
                              : AppColors.black16,
                        )),
                    child: Row(children: [
                      Radio(
                        value: 0,
                        groupValue: _radioValue,
                        activeColor: AppColors.primaryBlue,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (val) {
                          setState(() {
                            _radioValue = 0;
                          });
                        },
                      ),
                      Text(
                        'Incorrect',
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
                    onPressed: () => print('hello'),
                    icon: const Icon(
                      Icons.message,
                      color: AppColors.black40,
                    ),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
