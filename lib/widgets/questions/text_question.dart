import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';

class TextQuestion extends StatefulWidget {
  final String fieldType;
  final String answerGiven;
  final ValueChanged<String> parentAction;
  const TextQuestion(
      {Key? key,
      required this.fieldType,
      required this.answerGiven,
      required this.parentAction})
      : super(key: key);
  @override
  _TextQuestionState createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.answerGiven;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 15, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.black16),
        ),
        child: Focus(
          child: TextFormField(
            onEditingComplete: () {
              widget.parentAction(_textController.text);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              return;
            },
            controller: _textController,
            style: GoogleFonts.lato(fontSize: 14.0),
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: widget.fieldType == FieldType.numeric
                ? TextInputType.number
                : widget.fieldType == FieldType.email
                    ? TextInputType.emailAddress
                    : TextInputType.name,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              // border: OutlineInputBorder(
              //     borderSide: BorderSide(color: AppColors.grey16)),
              // enabledBorder: const UnderlineInputBorder(
              //   borderSide: BorderSide(color: AppColors.black16),
              // ),
              // focusedBorder: const UnderlineInputBorder(
              //   borderSide: BorderSide(color: AppColors.primaryBlue),
              // ),
              border: InputBorder.none,
              hintText: 'Type here',
              hintStyle: GoogleFonts.lato(
                  color: AppColors.black40,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: const BorderSide(
              //       color: AppColors.primaryThree, width: 1.0),
              // ),
            ),
          ),
        ));
  }
}
