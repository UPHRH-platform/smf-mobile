import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/pages/login_otp_page.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smf_mobile/widgets/otp_input_field.dart';

class CreatePinPage extends StatefulWidget {
  static const route = AppUrl.loginEmailPage;

  const CreatePinPage({Key? key}) : super(key: key);
  @override
  _CreatePinPageState createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage = '';
  late Locale locale;

  final TextEditingController _pinOneFieldOne = TextEditingController();
  final TextEditingController _pinOneFieldTwo = TextEditingController();
  final TextEditingController _pinOneFieldThree = TextEditingController();
  final TextEditingController _pinOneFieldFour = TextEditingController();
  final TextEditingController _pinTwoFieldOne = TextEditingController();
  final TextEditingController _pinTwoFieldTwo = TextEditingController();
  final TextEditingController _pinTwoFieldThree = TextEditingController();
  final TextEditingController _pinTwoFieldFour = TextEditingController();
  String _pin1 = '', _pin2 = '';

  @override
  void initState() {
    super.initState();
    _pinOneFieldOne.addListener(_setPin);
    _pinOneFieldTwo.addListener(_setPin);
    _pinOneFieldThree.addListener(_setPin);
    _pinOneFieldFour.addListener(_setPin);
    _pinTwoFieldOne.addListener(_setPin);
    _pinTwoFieldTwo.addListener(_setPin);
    _pinTwoFieldThree.addListener(_setPin);
    _pinTwoFieldFour.addListener(_setPin);
  }

  void _setPin() {
    setState(() {
      _pin1 =
          '${_pinOneFieldOne.text}${_pinOneFieldTwo.text}${_pinOneFieldThree.text}${_pinOneFieldFour.text}';
      _pin2 =
          '${_pinTwoFieldOne.text}${_pinTwoFieldTwo.text}${_pinTwoFieldThree.text}${_pinTwoFieldFour.text}';
    });
  }

  Future<void> _generateOtp() async {
    final email = _emailController.text.trim();
    if (email == '') {
      Helper.toastMessage(AppLocalizations.of(context)!.pleaseEnterEmail);
      return;
    }
    if (_pin1 == '' || _pin2 == '') {
      Helper.toastMessage(AppLocalizations.of(context)!.pleaseEnterPin);
      return;
    }
    if (_pin1.length < 4 || _pin2.length < 4) {
      Helper.toastMessage(AppLocalizations.of(context)!.pleaseEnterValidPin);
      return;
    }
    if (_pin1 != _pin2) {
      Helper.toastMessage(AppLocalizations.of(context)!.pleaseMatchPin);
      return;
    }
    if (_pin1 == _pin2 && _pin1.length == 4) {
      Map pinDetails = await OfflineModel.getPinDetails(_pin1);
      if (pinDetails['username'] != null) {
        Helper.toastMessage(AppLocalizations.of(context)!.pinAlreadyExists);
        return;
      }
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      final responseCode =
          await Provider.of<LoginRespository>(context, listen: false)
              .getOtp(email.trim());
      if (responseCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginOtpPage(
            username: email,
            pin: _pin1,
            loginRequest: false,
          ),
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

  _validateEmail() {
    String email = _emailController.text;
    final bool isValid = EmailValidator.validate(email);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (!isValid) {
      _emailController.text = '';
      Helper.toastMessage(AppLocalizations.of(context)!.inValidEmailId);
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
                    padding: const EdgeInsets.only(top: 60, bottom: 60),
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
                                    AppLocalizations.of(context)!.createPin,
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
                                AppLocalizations.of(context)!.emailId,
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
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
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
                                        onEditingComplete: () =>
                                            _validateEmail(),
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
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.enterPin,
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
                            alignment: Alignment.centerLeft,
                            height: 45.0,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              // border:
                              //     Border.all(color: AppColors.black16),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OtpInputField(_pinOneFieldOne, true, false),
                                OtpInputField(_pinOneFieldTwo, false, false),
                                OtpInputField(_pinOneFieldThree, false, false),
                                OtpInputField(_pinOneFieldFour, false, true)
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.confirmPin,
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
                            alignment: Alignment.centerLeft,
                            height: 45.0,
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              // border:
                              //     Border.all(color: AppColors.black16),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OtpInputField(_pinTwoFieldOne, true, false),
                                OtpInputField(_pinTwoFieldTwo, false, false),
                                OtpInputField(_pinTwoFieldThree, false, false),
                                OtpInputField(_pinTwoFieldFour, false, true)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
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
                                            AppLocalizations.of(context)!
                                                .submit,
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
                          const Padding(
                              padding: EdgeInsets.only(
                                top: 20,
                              ),
                              child: Divider(
                                color: AppColors.black16,
                              )),
                          Center(
                              child: Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: InkWell(
                                onTap: () => Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginEmailPage(),
                                    )),
                                child: Text(
                                  AppLocalizations.of(context)!.goBack,
                                  // textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                      color: AppColors.primaryBlue,
                                      fontSize: 14,
                                      letterSpacing:
                                          0.5 /*percentages not used in flutter. defaulting to zero*/,
                                      fontWeight: FontWeight.w700,
                                      height: 1.4),
                                )),
                          ))
                        ]),
                  )
                ],
              )),
        ));
  }
}
