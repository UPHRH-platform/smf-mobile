import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/models/application_model.dart';
import 'package:smf_mobile/models/form_model.dart';
import 'package:smf_mobile/pages/inspection_summary.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/repositories/form_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:smf_mobile/widgets/assistant_inspector_application_field.dart';
import 'package:smf_mobile/widgets/assistant_inspector_dialog.dart';
import 'package:smf_mobile/widgets/lead_inspector_application_field.dart';
import 'package:smf_mobile/widgets/people_card.dart';
import 'package:smf_mobile/widgets/silverappbar_delegate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApplicationDetailsPage extends StatefulWidget {
  final Application application;
  const ApplicationDetailsPage({
    Key? key,
    required this.application,
  }) : super(key: key);

  @override
  _ApplicationDetailsPageState createState() => _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState extends State<ApplicationDetailsPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  late FormData _formData;
  int _activeTabIndex = 0;
  final Map _data = {};
  final Map _leadInspectorData = {};
  final Map _leadInspectorFields = {};
  final Map _fieldTypes = {};
  final Map _fieldOptions = {};
  final List<String> _tabs = [];
  final List<Map> _fields = [];
  bool _isleadInspector = false;
  bool _iDisagree = false;
  bool _iConcent = false;
  String _note = '';
  int _leadInspectorId = 0;
  final List<Map> _inspectors = [];
  String _inspectionSummary = '';

  @override
  void initState() {
    super.initState();
    widget.application.dataObject.forEach((key, value) => _tabs.add(key));
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController!.addListener(_setActiveTabIndex);
    _checkInspectorRole();
    _populateFields();
  }

  Future<void> _checkInspectorRole() async {
    String id = await Helper.getUser(Storage.userId);
    int userId = int.parse(id);
    if (widget.application.leadInspector.isNotEmpty) {
      _leadInspectorId = widget.application.leadInspector[0];
      if (widget.application.leadInspector[0] == userId) {
        setState(() {
          _isleadInspector = true;
        });
      } else if (widget.application.status ==
          InspectionStatus.inspectionCompleted) {
        _inspectionSummary =
            widget.application.inspectorSummaryDataObject['Inspection Summary'][
                widget.application
                    .inspectorSummaryDataObject['Inspection Summary'].keys
                    .elementAt(0)];
      }
    }

    _inspectors.clear();
    for (var i = 0; i < widget.application.inspectors.length; i++) {
      _inspectors.add({
        'id': widget.application.inspectors[i]['id'],
        'name':
            '${widget.application.inspectors[i]['firstName']} ${widget.application.inspectors[i]['lastName']}',
      });
      setState(() {});
    }
  }

  Future<dynamic> _getFormDetails() async {
    _validateUser();
    _formData = await Provider.of<FormRespository>(context, listen: false)
        .getFormDetails(widget.application.formId);
    // print('object');
    String _errorMessage =
        Provider.of<FormRespository>(context, listen: false).errorMessage;
    if (_errorMessage != '') {
      Helper.toastMessage(_errorMessage);
    } else {
      for (int i = 0; i < _formData.fields.length; i++) {
        if (_formData.fields[i]['fieldType'] != FieldType.heading) {
          _fieldTypes[_formData.fields[i]['name']] =
              _formData.fields[i]['fieldType'];
          _fieldOptions[_formData.fields[i]['name']] =
              _formData.fields[i]['values'];
        }
      }
    }
    // print(_fieldTypes);
    return _fieldTypes;
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController!.index;
    });
  }

  void _populateFields() async {
    Map updatedFields = {};
    widget.application.dataObject.forEach((key, value) => {
          updatedFields = {},
          value.forEach((childKey, childValue) => {
                updatedFields[childKey] = {
                  childValue: {'value': 'Correct', 'comments': ''}
                }
              }),
          _data[key] = updatedFields
        });
    _data.forEach((key, value) => _fields.add(value));
    if (!_isleadInspector) {
      updatedFields = {};
      widget.application.inspectorDataObject.forEach((key, value) => {
            updatedFields = {},
            value.forEach(
              (childKey, childValue) => {
                updatedFields[childKey] = {'value': '', 'comments': ''},
                _leadInspectorFields[childKey] = childValue,
              },
            ),
            _leadInspectorData[key] = updatedFields,
          });
      // print(_leadInspectorFields);
    }
  }

  void updateField(Map fieldData) {
    _data[_data.keys.elementAt(_activeTabIndex)].forEach((key, value) => {
          if (key == fieldData.keys.elementAt(0))
            {
              setState(() {
                _data[_data.keys.elementAt(_activeTabIndex)][key] =
                    fieldData[fieldData.keys.elementAt(0)];
                _fields[_activeTabIndex] =
                    _data[_data.keys.elementAt(_activeTabIndex)];
              })
            }
        });
    // print(fieldData);
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

  Future<void> _submitInspection() async {
    _validateUser();
    Map data = {
      'applicationId': widget.application.applicationId,
      'dataObject': _data
    };

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => InspectionSummaryPage(
              // formId: widget.formId,
              formId: 1645422297511,
              inspectors: widget.application.inspectors,
              leadInspector: widget.application.leadInspector,
              inspectionData: data,
            )));
  }

  triggerUpdate(Map data) {
    setState(() {
      _iDisagree = !data['status'] ? false : _iDisagree;
      _iConcent = !data['status'] ? false : _iConcent;
      _note = data['note'];
    });
  }

  Future _displayCommentDialog() {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return AssistantInspectorDialog(
                noteText: _note,
                parentAction: triggerUpdate,
              );
            }));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.applicationFields);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 10,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: AppColors.black60),
        title: Text(
          widget.application.title,
          style: GoogleFonts.lato(
            color: AppColors.black87,
            fontSize: 16.0,
            letterSpacing: 0.12,
            fontWeight: FontWeight.w600,
          ),
        ),
        // centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: DefaultTabController(
            length: _tabs.length,
            child: SafeArea(
                minimum: const EdgeInsets.only(top: 5),
                child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverPersistentHeader(
                          delegate: SilverAppBarDelegate(
                            TabBar(
                              isScrollable: true,
                              indicator: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.primaryBlue,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              indicatorColor: Colors.white,
                              labelPadding: const EdgeInsets.only(top: 0.0),
                              unselectedLabelColor: AppColors.black60,
                              labelColor: AppColors.black87,
                              labelStyle: GoogleFonts.lato(
                                  color: AppColors.black60,
                                  fontSize: 14,
                                  letterSpacing:
                                      0.25 /*percentages not used in flutter. defaulting to zero*/,
                                  fontWeight: FontWeight.w700,
                                  height: 1),
                              unselectedLabelStyle: const TextStyle(
                                color: Color.fromRGBO(0, 77, 89, 1),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                              tabs: [
                                for (var tabItem in _tabs)
                                  Container(
                                    height: MediaQuery.of(context).size.height,
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Tab(
                                      child: Text(
                                        tabItem,
                                      ),
                                    ),
                                  ),
                              ],
                              controller: _tabController,
                            ),
                          ),
                          pinned: true,
                          floating: false,
                        ),
                      ];
                    },
                    body: FutureBuilder(
                      future: _getFormDetails(),
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Container(
                            padding: const EdgeInsets.only(top: 20),
                            color: AppColors.scaffoldBackground,
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  for (Map field in _fields)
                                    ListView(children: [
                                      !_isleadInspector
                                          ? Wrap(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  margin: const EdgeInsets.only(
                                                      left: 20, right: 20),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(4),
                                                            topRight:
                                                                Radius.circular(
                                                                    4)),
                                                    color: AppColors
                                                        .fieldBackground,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              AppColors.black16,
                                                          offset: Offset(0, 2),
                                                          blurRadius: 2)
                                                    ],
                                                  ),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  15,
                                                                  10,
                                                                  15,
                                                                  10),
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .black08,
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .black08),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: Text(
                                                            'Status: ${Helper.getInspectionStatus(context, widget.application.status)}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: AppColors
                                                                  .positiveLight,
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Inspection completed on ${Helper.formatDate(widget.application.scheduledDate)}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: AppColors
                                                                  .black60,
                                                              fontSize: 14.0,
                                                              letterSpacing:
                                                                  0.25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.only(
                                                      top: 20,
                                                      left: 20,
                                                      right: 20),
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(4),
                                                            topRight:
                                                                Radius.circular(
                                                                    4)),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              AppColors.black16,
                                                          offset: Offset(0, 2),
                                                          blurRadius: 2)
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Text(
                                                          'Inspection Summary',
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: AppColors
                                                                .black87,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.25,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                15, 10, 15, 10),
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .black16),
                                                        ),
                                                        child: Text(
                                                          _inspectionSummary,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: AppColors
                                                                .black87,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.25,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                      _leadInspectorId != 0
                                                          ? Container(
                                                              margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                  0,
                                                                  20,
                                                                  20,
                                                                  15),
                                                              child: Text(
                                                                'Lead inspector',
                                                                style:
                                                                    GoogleFonts
                                                                        .lato(
                                                                  color: AppColors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.25,
                                                                ),
                                                              ))
                                                          : const Center(),
                                                      for (int i = 0;
                                                          i <
                                                              _inspectors
                                                                  .length;
                                                          i++)
                                                        if (_leadInspectorId ==
                                                            _inspectors[i]
                                                                ['id'])
                                                          PeopleCard(
                                                            inspector:
                                                                _inspectors[i],
                                                          ),
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0,
                                                                  10,
                                                                  20,
                                                                  15),
                                                          child: Text(
                                                            'Assisting inspectors',
                                                            style: GoogleFonts
                                                                .lato(
                                                              color: AppColors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              letterSpacing:
                                                                  0.25,
                                                            ),
                                                          )),
                                                      for (int i = 0;
                                                          i <
                                                              _inspectors
                                                                  .length;
                                                          i++)
                                                        if (_leadInspectorId !=
                                                            _inspectors[i]
                                                                ['id'])
                                                          PeopleCard(
                                                            inspector:
                                                                _inspectors[i],
                                                          ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          : const Center(),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: field.length,
                                          itemBuilder: (context, i) {
                                            return _isleadInspector
                                                ? LeadInspectorApplicationField(
                                                    fieldName:
                                                        field.keys.elementAt(i),
                                                    fieldData: field[field.keys
                                                        .elementAt(i)],
                                                    fieldType: _fieldTypes[field
                                                        .keys
                                                        .elementAt(i)],
                                                    fieldOptions: _fieldOptions[
                                                        field.keys
                                                            .elementAt(i)],
                                                    applicationStatus: widget
                                                        .application.status,
                                                    parentAction: updateField,
                                                  )
                                                : widget.application.status ==
                                                        InspectionStatus
                                                            .inspectionCompleted
                                                    ? AssistantInspectorApplicationField(
                                                        fieldName: field.keys
                                                            .elementAt(i),
                                                        fieldData: field[field
                                                            .keys
                                                            .elementAt(i)],
                                                        leadInspectorData:
                                                            _leadInspectorFields[
                                                                _leadInspectorFields
                                                                    .keys
                                                                    .elementAt(
                                                                        i)],
                                                        parentAction:
                                                            updateField,
                                                      )
                                                    : const Center();
                                          })
                                    ])
                                ]),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )))),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 20,
          child: Container(
              height: _isleadInspector ? 60 : 120,
              margin: const EdgeInsets.only(
                top: 10,
              ),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(children: [
                !_isleadInspector
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          !_iConcent
                              ? ButtonTheme(
                                  child: OutlinedButton(
                                      onPressed: () {
                                        if (!_iDisagree) {
                                          _displayCommentDialog();
                                        }
                                        setState(() {
                                          _iDisagree = !_iDisagree;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: _iDisagree
                                            ? AppColors.primaryBlue
                                            : Colors.white,
                                        side: const BorderSide(
                                            width: 1, color: AppColors.black40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        // onSurface: Colors.grey,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'I disagree',
                                            style: GoogleFonts.lato(
                                                color: _iDisagree
                                                    ? Colors.white
                                                    : AppColors.black60,
                                                fontSize: 14,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 0, 0),
                                              child: Icon(
                                                Icons.clear,
                                                color: _iDisagree
                                                    ? Colors.white
                                                    : AppColors.black60,
                                                size: 20,
                                              ))
                                        ],
                                      )),
                                )
                              : const Center(),
                          !_iDisagree
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextButton(
                                      onPressed: () {
                                        if (!_iConcent) {
                                          _displayCommentDialog();
                                        }
                                        setState(() {
                                          _iConcent = !_iConcent;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        // primary: Colors.white,
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        backgroundColor: _iConcent
                                            ? AppColors.primaryBlue
                                            : Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            side: const BorderSide(
                                                color: AppColors.black40)),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            'I concent',
                                            style: GoogleFonts.lato(
                                                color: _iConcent
                                                    ? Colors.white
                                                    : AppColors.black60,
                                                fontSize: 14,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5, 0, 0, 0),
                                              child: Icon(
                                                Icons.check,
                                                color: _iConcent
                                                    ? Colors.white
                                                    : AppColors.black60,
                                                size: 20,
                                              ))
                                        ],
                                      )),
                                )
                              : const Center(),
                        ],
                      )
                    : const Center(),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _activeTabIndex > 0
                          ? InkWell(
                              onTap: () => _tabController!.index--,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.primaryBlue,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        AppLocalizations.of(context)!.previous,
                                        style: GoogleFonts.lato(
                                          color: AppColors.primaryBlue,
                                          fontSize: 14.0,
                                          letterSpacing: 0.12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                ],
                              ))
                          : const Center(),
                      _activeTabIndex < _tabs.length - 1
                          ? InkWell(
                              onTap: () => _tabController!.index++,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        AppLocalizations.of(context)!.next,
                                        style: GoogleFonts.lato(
                                          color: AppColors.primaryBlue,
                                          fontSize: 14.0,
                                          letterSpacing: 0.12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.primaryBlue,
                                  )
                                ],
                              ))
                          : widget.application.status ==
                                  InspectionStatus.sentForInspection
                              ? TextButton(
                                  onPressed: () {
                                    _submitInspection();
                                  },
                                  style: TextButton.styleFrom(
                                    // primary: Colors.white,
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    backgroundColor: AppColors.primaryBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: const BorderSide(
                                            color: AppColors.black16)),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .inspectionCompleted,
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              : const Center(),
                    ],
                  ),
                )
              ]))),
    );
  }
}
