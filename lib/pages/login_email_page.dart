import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/pages/login_otp_page.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smf_mobile/util/helper.dart';

class LoginEmailPage extends StatefulWidget {
  static const route = AppUrl.loginEmailPage;

  const LoginEmailPage({Key? key}) : super(key: key);
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _generateOtp() async {
    final email = _emailController.text;
    if (email == '') {
      Helper.toastMessage('Please enter email.');
      return;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      final responseCode =
          await Provider.of<LoginRespository>(context, listen: false)
              .getOtp(email);
      if (responseCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginOtpPage(),
        ));
      } else {
        _errorMessage =
            Provider.of<LoginRespository>(context, listen: false).errorMessage;
        Helper.toastMessage(_errorMessage);
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
                                'Email Id',
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
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10.0),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border:
                                          Border.all(color: AppColors.black16),
                                      color: Colors.white,
                                    ),
                                    child: Focus(
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.none,
                                        textInputAction: TextInputAction.done,
                                        controller: _emailController,
                                        style: GoogleFonts.lato(
                                            color: AppColors.black40,
                                            fontSize: 16,
                                            letterSpacing:
                                                0 /*percentages not used in flutter. defaulting to zero*/,
                                            fontWeight: FontWeight.normal,
                                            height:
                                                1.5 /*PERCENT not supported*/
                                            ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 0.0, 20.0, 0.0),
                                          border: InputBorder.none,
                                          hintText: 'Enter here',
                                          hintStyle: TextStyle(
                                              color: AppColors.black40,
                                              fontSize: 14,
                                              letterSpacing:
                                                  0 /*percentages not used in flutter. defaulting to zero*/,
                                              fontWeight: FontWeight.normal,
                                              height:
                                                  1.5 /*PERCENT not supported*/
                                              ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: InkWell(
                                // ignore: avoid_print
                                onTap: () => _generateOtp(),
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
                                            'GET OTP',
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
                        ]),
                  )
                ],
              )),
        ));
  }
}
