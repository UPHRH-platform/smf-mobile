import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/pages/create_pin_page.dart';
import 'package:smf_mobile/pages/home_page.dart';
import 'package:smf_mobile/pages/login_otp_page.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smf_mobile/widgets/otp_input_field.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'dart:async';
import 'package:email_validator/email_validator.dart';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:smf_mobile/util/connectivity_helper.dart';

class LoginEmailPage extends StatefulWidget {
  static const route = AppUrl.loginEmailPage;

  const LoginEmailPage({Key? key}) : super(key: key);
  @override
  _LoginEmailPageState createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Map _source = {ConnectivityResult.none: false};
  // final MyConnectivity _connectivity = MyConnectivity.instance;
  String _errorMessage = '';
  late Locale locale;
  late String _identifier;

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  String _oldPin = '';

  @override
  void initState() {
    super.initState();
    // _connectivity.initialise();
    // _connectivity.myStream.listen((source) {
    //   if (mounted) {
    //     setState(() {
    //       _source = source;
    //     });
    //   }
    // });
    _fieldOne.addListener(_validatePin);
    _fieldTwo.addListener(_validatePin);
    _fieldThree.addListener(_validatePin);
    _fieldFour.addListener(_validatePin);
    initUniqueIdentifierState();
  }

  Future<void> initUniqueIdentifierState() async {
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier!;
    });
  }

  Future<void> _generateOtp() async {
    final email = _emailController.text.trim();
    if (email == '') {
      Helper.toastMessage(AppLocalizations.of(context)!.pleaseEnterEmail);
      return;
    }
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      final responseCode =
          await Provider.of<LoginRespository>(context, listen: false)
              .getOtp(email.trim());
      if (responseCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginOtpPage(username: email),
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

  Future<void> _validatePin() async {
    String pin =
        '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}';
    // print(_oldPin + ", " + pin);
    if (pin.length == 4 && pin != _oldPin) {
      _oldPin = pin;
      bool isInternetConnected = await Helper.isInternetConnected();
      // await Future.delayed(const Duration(milliseconds: 10));
      try {
        Map pinDetails = await OfflineModel.getPinDetails(pin);
        // print(pinDetails);
        if (isInternetConnected && pinDetails['username'] != null) {
          final responseCode = await Provider.of<LoginRespository>(context,
                  listen: false)
              .validateOtp(
                  context, pinDetails['username'], '', _identifier, pin, false);
          if (responseCode == 200) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
          } else {
            _errorMessage =
                Provider.of<LoginRespository>(context, listen: false)
                    .errorMessage;
            Helper.toastMessage(_errorMessage);
          }
        } else if (pinDetails['username'] != null) {
          Helper.setUser(Storage.username, pinDetails['username']);
          Helper.setUser(Storage.authtoken, '');
          Helper.toastMessage(AppLocalizations.of(context)!.youAreOffline);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        } else {
          _fieldOne.text = '';
          _fieldTwo.text = '';
          _fieldThree.text = '';
          _fieldFour.text = '';
          Helper.toastMessage(AppLocalizations.of(context)!.inValidPin);
        }
      } catch (err) {
        throw Exception(err);
      }
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
    // _connectivity.disposeStream();
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
                                    AppLocalizations.of(context)!.login,
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
                            padding: const EdgeInsets.only(bottom: 10),
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
                                                .getOtp,
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
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.orEnterPin,
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
                            // alignment: Alignment.centerLeft,
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
                                OtpInputField(_fieldOne, true, false),
                                OtpInputField(_fieldTwo, false, false),
                                OtpInputField(_fieldThree, false, false),
                                OtpInputField(_fieldFour, false, true)
                              ],
                            ),
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
                                              const CreatePinPage(),
                                        )),
                                    child: Text(
                                      AppLocalizations.of(context)!.createPin,
                                      style: GoogleFonts.lato(
                                          color: AppColors.primaryBlue,
                                          fontSize: 14,
                                          letterSpacing:
                                              0.5 /*percentages not used in flutter. defaulting to zero*/,
                                          fontWeight: FontWeight.w700,
                                          height: 1.4),
                                    ))),
                          )
                        ]),
                  )
                ],
              )),
        ));
  }
}
