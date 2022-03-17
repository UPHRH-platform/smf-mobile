import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/color_constants.dart';

class OtpInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final bool isLast;
  const OtpInputField(this.controller, this.autoFocus, this.isLast, {Key? key})
      : super(key: key);
  @override
  _OtpInputFieldState createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        width: 40,
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.logicalKey == LogicalKeyboardKey.backspace &&
                widget.controller.text == '' &&
                !widget.autoFocus) {
              if (widget.isLast && widget.controller.text == '') {
                FocusScope.of(context).previousFocus();
              } else if (!widget.isLast) {
                FocusScope.of(context).previousFocus();
              }
            }
          },
          child: TextField(
            // autofocus: widget.autoFocus,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: widget.controller,
            maxLength: 1,
            cursorColor: AppColors.black08,
            style: GoogleFonts.lato(
                color: AppColors.black40,
                fontSize: 16,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1 /*PERCENT not supported*/
                ),
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: '',
                hintStyle: TextStyle(color: AppColors.black40, fontSize: 20.0)),
            onChanged: (value) {
              if (value.length == 1) {
                if (!widget.isLast) {
                  FocusScope.of(context).nextFocus();
                } else {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                }
              }
            },
          ),
        ));
  }
}
