import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/pages/inspection_summary.dart';
import 'package:smf_mobile/pages/login_email_page.dart';
import 'package:smf_mobile/repositories/application_repository.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:smf_mobile/widgets/application_field.dart';
import 'package:smf_mobile/widgets/silverappbar_delegate.dart';

class ApplicationDetailsPage extends StatefulWidget {
  final String applicationId;
  final String applicationTitle;
  final Map applicationFields;
  final List applicationInspectors;
  const ApplicationDetailsPage({
    Key? key,
    required this.applicationId,
    required this.applicationTitle,
    required this.applicationFields,
    required this.applicationInspectors,
  }) : super(key: key);

  @override
  _ApplicationDetailsPageState createState() => _ApplicationDetailsPageState();
}

class _ApplicationDetailsPageState extends State<ApplicationDetailsPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? _tabController;
  int _activeTabIndex = 0;
  final Map _data = {};
  final List<String> _tabs = [];
  final List<Map> _fields = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    widget.applicationFields.forEach((key, value) => _tabs.add(key));
    _tabController = TabController(vsync: this, length: _tabs.length);
    _tabController!.addListener(_setActiveTabIndex);
    _populateFields();
  }

  void _setActiveTabIndex() {
    setState(() {
      _activeTabIndex = _tabController!.index;
    });
  }

  void _populateFields() {
    Map updatedFields = {};
    widget.applicationFields.forEach((key, value) => {
          updatedFields = {},
          value.forEach((childKey, childValue) => {
                updatedFields[childKey] = {
                  childValue: {'value': 'Correct', 'comments': ''}
                }
              }),
          _data[key] = updatedFields
        });
    _data.forEach((key, value) => _fields.add(value));
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
  }

  void _validateUser() async {
    bool tokenExpired = await Helper.isTokenExpired();
    if (tokenExpired) {
      Helper.toastMessage('Your session has expired.');
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginEmailPage(),
      ));
    }
  }

  Future<void> _submitInspection() async {
    _validateUser();
    Map data = {'applicationId': widget.applicationId, 'dataObject': _data};
    try {
      final responseCode =
          await Provider.of<ApplicationRespository>(context, listen: false)
              .submitInspection(data);
      if (responseCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => InspectionSummaryPage(
                inspectors: widget.applicationInspectors)));
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
          widget.applicationTitle,
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
                    body: Container(
                        padding: const EdgeInsets.only(top: 20),
                        color: AppColors.scaffoldBackground,
                        child:
                            TabBarView(controller: _tabController, children: [
                          for (Map field in _fields)
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: field.length,
                                itemBuilder: (context, i) {
                                  return ApplicationField(
                                    fieldName: field.keys.elementAt(i),
                                    fieldData: field[field.keys.elementAt(i)],
                                    parentAction: updateField,
                                  );
                                })
                        ]))))),
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 20,
          child: Container(
            height: 60,
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _activeTabIndex > 0
                    ? InkWell(
                        onTap: () => _tabController!.index--,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Icon(
                              Icons.arrow_back,
                              color: AppColors.primaryBlue,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Previous',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  'Next',
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
                    : TextButton(
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
                          'Inspection completed',
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ],
            ),
          )),
    );
  }
}
