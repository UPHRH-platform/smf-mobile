import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/repositories/login_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smf_mobile/widgets/otp_input_field.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:flutter/services.dart';

class LoginOtpPage extends StatefulWidget {
  static const route = AppUrl.loginOtpPage;

  final String username;
  final String pin;
  final bool loginRequest;

  const LoginOtpPage({
    Key? key,
    required this.username,
    this.pin = '',
    this.loginRequest = true,
  }) : super(key: key);
  @override
  _LoginOtpPageState createState() => _LoginOtpPageState();
}

class _LoginOtpPageState extends State<LoginOtpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _errorMessage = '';
  late String _identifier;

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _fieldOne.addListener(_setOtp);
    _fieldTwo.addListener(_setOtp);
    _fieldThree.addListener(_setOtp);
    _fieldFour.addListener(_setOtp);
    _fieldFive.addListener(_setOtp);
    _fieldSix.addListener(_setOtp);
    initUniqueIdentifierState();
  }

  void _setOtp() {
    setState(() {
      _otp =
          '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}${_fieldFive.text}${_fieldSix.text}';
    });
  }

  Future<void> initUniqueIdentifierState() async {
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = AppLocalizations.of(context)!.failedToGetUniqueIdentifier;
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier!;
    });
  }

  Future<void> _validateOtp() async {
    try {
      if (_otp == '') {
        Helper.toastMessage(AppLocalizations.of(context)!.pleaseEnterOtp);
        return;
      }
      if (widget.loginRequest) {
        final responseCode = await Provider.of<LoginRespository>(context,
                listen: false)
            .validateOtp(context, widget.username, _otp, _identifier, '', true);
        if (responseCode == 200) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        } else {
          _fieldOne.text = '';
          _fieldTwo.text = '';
          _fieldThree.text = '';
          _fieldFour.text = '';
          _fieldFive.text = '';
          _fieldSix.text = '';
          _otp = '';
          _errorMessage = Provider.of<LoginRespository>(context, listen: false)
              .errorMessage;
          Helper.toastMessage(_errorMessage);
        }
      } else {
        final responseData =
            await Provider.of<LoginRespository>(context, listen: false)
                .generatePin(widget.username, widget.pin, _otp);
        if (responseData) {
          Helper.toastMessage(
              AppLocalizations.of(context)!.pinGeneratedMessage);
          await OfflineModel.deletePin(widget.username);
          Map<String, Object> data = {
            'username': widget.username,
            'pin': widget.pin
          };
          await OfflineModel.savePin(data);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginEmailPage(),
          ));
        } else {
          _fieldOne.text = '';
          _fieldTwo.text = '';
          _fieldThree.text = '';
          _fieldFour.text = '';
          _fieldFive.text = '';
          _fieldSix.text = '';
          _otp = '';
          _errorMessage = Provider.of<LoginRespository>(context, listen: false)
              .errorMessage;
          Helper.toastMessage(_errorMessage);
        }
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
                                AppLocalizations.of(context)!.enterOtp,
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        OtpInputField(_fieldOne, true, false),
                                        OtpInputField(_fieldTwo, false, false),
                                        OtpInputField(
                                            _fieldThree, false, false),
                                        OtpInputField(_fieldFour, false, false),
                                        OtpInputField(_fieldFive, false, false),
                                        OtpInputField(_fieldSix, false, true)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: Text(
                              AppLocalizations.of(context)!.otpFieldDescription,
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
                                            widget.loginRequest
                                                ? AppLocalizations.of(context)!
                                                    .signIn
                                                : AppLocalizations.of(context)!
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
                          InkWell(
                            onTap: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const LoginEmailPage(),
                            )),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              width: double.infinity,
                              child: Text(
                                AppLocalizations.of(context)!.goBackText,
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
