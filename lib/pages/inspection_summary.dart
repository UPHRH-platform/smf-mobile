import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/app_urls.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/models/form_model.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/repositories/form_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:smf_mobile/widgets/people_card.dart';
import 'inspection_completed.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smf_mobile/util/connectivity_helper.dart';

class InspectionSummaryPage extends StatefulWidget {
  static const route = AppUrl.inspectionSummary;
  final int formId;
  final List inspectors;
  final List leadInspector;
  final Map inspectionData;

  const InspectionSummaryPage(
      {Key? key,
      required this.formId,
      required this.inspectors,
      required this.leadInspector,
      required this.inspectionData})
      : super(key: key);
  @override
  _InspectionSummaryPageState createState() => _InspectionSummaryPageState();
}

class _InspectionSummaryPageState extends State<InspectionSummaryPage> {
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  final TextEditingController _summaryController = TextEditingController();
  final List<Map> _inspectors = [];
  int _leadInspectorId = 0;
  bool _iAgree = false;
  late FormData _formData;
  String _errorMessage = '';
  late Map _summaryField;
  late Map _termsField;

  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    _populateApplicationInspectors();
  }

  // @override
  // void dispose() {
  //   // _connectivity.disposeStream();
  //   super.dispose();
  // }

  Future<void> _populateApplicationInspectors() async {
    if (widget.leadInspector.isNotEmpty) {
      _leadInspectorId = widget.leadInspector[0];
    }
    _inspectors.clear();
    for (var i = 0; i < widget.inspectors.length; i++) {
      _inspectors.add({
        'id': widget.inspectors[i]['id'],
        'name':
            '${widget.inspectors[i]['firstName']} ${widget.inspectors[i]['lastName']}',
      });
      setState(() {});
    }
  }

  void _validateUser() async {
    bool tokenExpired = await Helper.isTokenExpired();
    if (tokenExpired) {
      Helper.toastMessage(AppLocalizations.of(context)!.sessionExpiredMessage);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginEmailPage(),
      ));
    }
  }

  Future<dynamic> _getFormDetails(context) async {
    _validateUser();
    _formData = await Provider.of<FormRespository>(context, listen: false)
        .getFormDetails(widget.formId);
    // print('object');
    String _errorMessage =
        Provider.of<FormRespository>(context, listen: false).errorMessage;
    if (_errorMessage != '') {
      Helper.toastMessage(_errorMessage);
    } else {
      for (int i = 0; i < _formData.inspectionFields.length; i++) {
        if (_formData.inspectionFields[i]['fieldType'] == FieldType.heading) {
          _summaryField = _formData.inspectionFields[i];
        } else if (_formData.inspectionFields[i]['fieldType'] ==
            FieldType.checkbox) {
          _termsField = _formData.inspectionFields[i];
        }
      }
    }
    return _formData;
  }

  Future<void> _submitInspection() async {
    _validateUser();
    if (!_iAgree) {
      Helper.toastMessage('Please accept terms and conditions');
      return;
    }
    try {
      Map data = widget.inspectionData;
      data['inspectorSummaryDataObject'] = {
        'Inspection Summary': {
          'Enter the summary of this inspection': _summaryController.text
        }
      };
      final responseCode =
          await Provider.of<ApplicationRespository>(context, listen: false)
              .submitInspection(Helper.isInternetConnected(_source), data);
      if (responseCode != 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const InspectionCompletedPage()));
      } else {
        _errorMessage =
            Provider.of<ApplicationRespository>(context, listen: false)
                .errorMessage;
        Helper.toastMessage(_errorMessage);
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 0,
          titleSpacing: 20,
          backgroundColor: Colors.white,
          title: Text(
            'Inspection Summary',
            style: GoogleFonts.lato(
              color: AppColors.black87,
              fontSize: 16.0,
              letterSpacing: 0.12,
              fontWeight: FontWeight.w600,
            ),
          ),
          // centerTitle: true,
        ),
        // Tab controller
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 200),
            margin: const EdgeInsets.all(20),
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
            child: FutureBuilder(
              future: _getFormDetails(context),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                          child: Text(
                            _summaryField['values'][0]['heading'] ?? '',
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.25,
                            ),
                          )),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.black16),
                        ),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          minLines: 10,
                          maxLines: 15,
                          controller: _summaryController,
                          style: const TextStyle(
                              color: AppColors.black87, fontSize: 14),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type here',
                            hintStyle: TextStyle(
                                fontSize: 14.0, color: AppColors.black60),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      _leadInspectorId != 0
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                              child: Text(
                                'Lead inspector',
                                style: GoogleFonts.lato(
                                  color: AppColors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.25,
                                ),
                              ))
                          : const Center(),
                      for (int i = 0; i < _inspectors.length; i++)
                        if (_leadInspectorId == _inspectors[i]['id'])
                          Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: PeopleCard(
                                inspector: _inspectors[i],
                              )),
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                          child: Text(
                            'Assisting inspectors',
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.25,
                            ),
                          )),
                      for (int i = 0; i < _inspectors.length; i++)
                        if (_leadInspectorId != _inspectors[i]['id'])
                          Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: PeopleCard(
                                inspector: _inspectors[i],
                              )),
                      const Divider(),
                      Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Text(
                            'Terms and conditions',
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.25,
                            ),
                          )),
                      Container(
                        padding: const EdgeInsets.only(left: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                                value: _iAgree,
                                activeColor: AppColors.primaryBlue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _iAgree = newValue!;
                                  });
                                }),
                            Container(
                                padding: const EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width - 120,
                                child: Text(
                                  _termsField['values'][0]
                                          ['additionalProperties'][
                                      _termsField['values'][0]
                                              ['additionalProperties']
                                          .keys
                                          .elementAt(0)],
                                  style: GoogleFonts.lato(
                                    color: AppColors.black87,
                                    fontSize: 12.0,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Container(
              margin: const EdgeInsets.only(right: 20, bottom: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    _submitInspection();
                  },
                  style: TextButton.styleFrom(
                    // primary: Colors.white,
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(color: AppColors.black16)),
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
              ))
        ])));
  }
}
