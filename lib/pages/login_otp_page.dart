import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginOtpPage extends StatefulWidget {
  static const route = AppUrl.loginOtpPage;

  const LoginOtpPage({Key? key}) : super(key: key);
  @override
  _LoginOtpPageState createState() => _LoginOtpPageState();
}

class _LoginOtpPageState extends State<LoginOtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage = '';
  String _otp = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _validateOtp() async {
    String otp = _otp;
    // if (otp.length != 6) {
    //   Fluttertoast.showToast(
    //       msg: 'Please enter 6 digits.',
    //       // toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 2,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //   return;
    // }

    try {
      final responseCode =
          await Provider.of<LoginRespository>(context, listen: false)
              .validateOtp(otp);
      if (responseCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePage(),
        ));
      } else {
        _errorMessage =
            Provider.of<LoginRespository>(context, listen: false).errorMessage;
        Fluttertoast.showToast(
            msg: _errorMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // print(_errorMessage);
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          reverse: true,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 100, bottom: 100),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        // width: 50.0,
                        // height: 50.0,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                    margin: const EdgeInsets.only(left: 20, right: 20),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Login',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                        color: AppColors.black87,
                                        fontSize: 20,
                                        letterSpacing:
                                            0.25 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4),
                                  ))),
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 50,
                              ),
                              child: Text(
                                'Enter OTP',
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    color: AppColors.black87,
                                    fontSize: 16,
                                    letterSpacing:
                                        0.25 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4),
                              )),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              top: 0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10.0),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 40.0,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      // border:
                                      //     Border.all(color: AppColors.black16),
                                      color: Colors.white,
                                    ),
                                    child: OTPTextField(
                                      length: 6,
                                      width: MediaQuery.of(context).size.width,
                                      fieldWidth: 38,
                                      style: const TextStyle(fontSize: 14),
                                      textFieldAlignment:
                                          MainAxisAlignment.spaceAround,
                                      fieldStyle: FieldStyle.underline,
                                      onCompleted: (pin) {
                                        setState(() {
                                          _otp = pin;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Text(
                              'Enter the 6 digit OTP sent to your email address.',
                              style: GoogleFonts.lato(
                                  color: AppColors.black60,
                                  fontSize: 12,
                                  letterSpacing:
                                      0.25 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                                // ignore: avoid_print
                                onTap: () => _validateOtp(),
                                child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    height: 50,
                                    child: Stack(children: <Widget>[
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryBlue,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ))),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'SIGN IN',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                color: Colors.white,
                                                fontSize: 17,
                                                letterSpacing:
                                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                                fontWeight: FontWeight.normal,
                                                height:
                                                    1.5 /*PERCENT not supported*/
                                                ),
                                          )),
                                    ]))),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const LoginEmailPage(),
                            )),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: double.infinity,
                              child: Text(
                                'Go back, re-enter the email',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    color: AppColors.primaryBlue,
                                    fontSize: 14,
                                    letterSpacing:
                                        0.25 /*percentages not used in flutter. defaulting to zero*/,
                                    fontWeight: FontWeight.w700,
                                    height: 1.4),
                              ),
                            ),
                          ),
                        ]),
                  )
                ],
              )),
        ));
  }
}