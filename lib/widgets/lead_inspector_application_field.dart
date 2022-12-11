import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smf_mobile/constants/app_constants.dart';
import 'package:smf_mobile/constants/color_constants.dart';
import 'package:smf_mobile/database/offline_model.dart';
import 'package:smf_mobile/pages/attachment_viewer.dart';
import 'package:smf_mobile/pages/file_viewer.dart';
import 'package:smf_mobile/services/application_service.dart';
import 'package:smf_mobile/util/helper.dart';
import 'package:smf_mobile/widgets/lead_inspector_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class LeadInspectorApplicationField extends StatefulWidget {
  final String applicationId;
  final String fieldName;
  final Map fieldData;
  final String fieldType;
  final List fieldOptions;
  final String applicationStatus;
  final ValueChanged<Map> parentAction;
  const LeadInspectorApplicationField({
    Key? key,
    required this.applicationId,
    required this.fieldName,
    required this.fieldData,
    required this.fieldType,
    required this.fieldOptions,
    required this.applicationStatus,
    required this.parentAction,
  }) : super(key: key);
  @override
  _LeadInspectorApplicationFieldState createState() =>
      _LeadInspectorApplicationFieldState();
}

class _LeadInspectorApplicationFieldState
    extends State<LeadInspectorApplicationField> {
  late Map _data;
  late String _radioValue;
  String _inspectionValue = '';
  String _attachment = '';
  String _summaryText = '';
  final List<String> _options = [FieldValue.correct, FieldValue.inCorrect];
  final _picker = ImagePicker();
  final List<String> _imageExtensions = [
    'apng',
    'png',
    'jpg',
    'jpeg',
    'avif',
    'gif',
    'svg'
  ];

  @override
  void initState() {
    super.initState();

    _data = widget.fieldData[widget.fieldData.keys.elementAt(0)];
    // print('Field: ' + _data.toString());
    _radioValue = _data[_data.keys.elementAt(0)] ?? "";
    _summaryText = _data[_data.keys.elementAt(1)] ?? "";
    try {
      _inspectionValue = _data[_data.keys.elementAt(2)] ?? "";
      _attachment = _data[_data.keys.elementAt(3)] ?? "";
    } catch (_) {
      return;
    }
  }

  triggerUpdate(Map dialogData) {
    Map data = {};
    if (dialogData['cancelStatus'] != null) {
      if (dialogData['cancelStatus'] &&
          (dialogData['summaryText'] == '' ||
              dialogData['inspectionValue'] == '')) {
        setState(() {
          _radioValue = FieldValue.correct;
        });
        data = {
          widget.fieldName: {
            widget.fieldData.keys.elementAt(0): {
              'value': FieldValue.correct,
              'comments': '',
              'inspectionValue': '',
              'attachment': _attachment
            }
          }
        };
      } else {
        data = {
          widget.fieldName: {
            widget.fieldData.keys.elementAt(0): {
              'value': _radioValue,
              'comments': dialogData['summaryText'],
              'inspectionValue': dialogData['inspectionValue'],
              'attachment': _attachment
            }
          }
        };
      }
    } else {
      data = {
        widget.fieldName: {
          widget.fieldData.keys.elementAt(0): {
            'value': _radioValue,
            'comments': dialogData['summaryText'],
            'inspectionValue': dialogData['inspectionValue'],
            'attachment': _attachment
          }
        }
      };
    }
    // print(data);
    setState(() {
      _summaryText = dialogData['summaryText'];
      _inspectionValue = dialogData['inspectionValue'];
    });
    widget.parentAction(data);
  }

  _triggerAttachmentUpdate(String attachment) {
    Map data = {
      widget.fieldName: {
        widget.fieldData.keys.elementAt(0): {
          'value': _radioValue,
          'comments': _summaryText,
          'inspectionValue': _inspectionValue,
          'attachment': attachment
        }
      }
    };
    // print(data);
    setState(() {
      _attachment = attachment;
    });
    widget.parentAction(data);
  }

  Future _displayCommentDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return LeadInspectorDialog(
                summaryText: _summaryText,
                inspectionValue: _inspectionValue,
                fieldType: widget.fieldType,
                fieldOptions: widget.fieldOptions,
                parentAction: triggerUpdate,
              );
            }));
  }

  Future<dynamic> _photoOptions(contextMain) {
    return showDialog(
        context: context,
        builder: (context) => Stack(
              children: [
                Positioned(
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          height: 120.0,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                    _getImage(ImageSource.camera);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.photo_camera,
                                        color: AppColors.primaryBlue,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Take a picture',
                                          style: GoogleFonts.montserrat(
                                              decoration: TextDecoration.none,
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                    _getImage(ImageSource.gallery);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.photo),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Go to files',
                                          style: GoogleFonts.montserrat(
                                              decoration: TextDecoration.none,
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )))
              ],
            ));
  }

  Future<dynamic> _getImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      try {
        CroppedFile? cropped = await ImageCropper().cropImage(
            sourcePath: image.path,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            uiSettings: [
              AndroidUiSettings(
                toolbarColor: AppColors.primaryBlue,
                toolbarTitle: 'Crop image',
                toolbarWidgetColor: Colors.white,
                statusBarColor: Colors.grey.shade900,
                backgroundColor: Colors.white,
              )
            ]);

        String fileUrl = '';
        bool isInternetConnected = await Helper.isInternetConnected();
        if (isInternetConnected) {
          fileUrl = await ApplicationService.uploadImage(cropped!.path);
        } else {
          fileUrl = cropped!.path;
          Map<String, Object> data = {
            'application_id': widget.applicationId,
            'attachment': fileUrl
          };
          await OfflineModel.saveAttachment(data);
          // List<Map> attachments =
          //     await OfflineModel.getAttachments(widget.applicationId);
          // print(attachments);
        }
        _triggerAttachmentUpdate(fileUrl);
      } catch (e) {
        // print(e);
        return;
      }
    }
  }

  Future<void> _deleteAttachment(String attachment) async {
    bool isInternetConnected = await Helper.isInternetConnected();
    if (isInternetConnected) {
      List data = [attachment];
      await ApplicationService.deleteImage(data);
    }

    Helper.toastMessage('Attachment removed');
    setState(() {
      _attachment = '';
    });
  }

  void _viewFile(String fileUrl) {
    String extension = fileUrl.split('.').last.toLowerCase();
    if (_imageExtensions.contains(extension) || extension == FieldType.pdf) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FileViewer(
                  fileType: extension == FieldType.pdf
                      ? FieldType.pdf
                      : FieldType.image,
                  fileUrl: fileUrl,
                )),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FileViewer(
                  fileType: '',
                  fileUrl: fileUrl,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        reverse: true,
        child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.black16,
                            offset: Offset(0, 2),
                            blurRadius: 2)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.fieldName,
                            style: GoogleFonts.lato(
                              color: AppColors.black87,
                              fontSize: 14.0,
                              letterSpacing: 0.25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: widget.fieldType == FieldType.file
                                ? const EdgeInsets.fromLTRB(10, 10, 10, 10)
                                : const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.black16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.fieldData.keys.elementAt(0),
                                  style: GoogleFonts.lato(
                                    color: AppColors.black87,
                                    fontSize: 14.0,
                                    letterSpacing: 0.25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                widget.fieldType == FieldType.file
                                    ? InkWell(
                                        onTap: () => _viewFile(
                                            widget.fieldData.keys.elementAt(0)),
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .preview,
                                              style: GoogleFonts.lato(
                                                color: AppColors.primaryBlue,
                                                fontSize: 14.0,
                                                letterSpacing: 0.25,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )))
                                    : const Center(),
                              ],
                            ))
                      ],
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4)),
                        color: AppColors.fieldBackground,
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.black16,
                              offset: Offset(0, 2),
                              blurRadius: 2)
                        ],
                      ),
                      child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .isGivenInformationCorrect,
                                    style: GoogleFonts.lato(
                                      color: AppColors.black60,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                      letterSpacing: 0.25,
                                    ),
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(bottom: 0),
                                  child: Row(
                                    // alignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      for (int i = 0; i < _options.length; i++)
                                        InkWell(
                                            onTap: () {
                                              // print(_options[i]);
                                              // if (widget.applicationStatus !=
                                              //     InspectionStatus
                                              //         .inspectionCompleted) {
                                              setState(() {
                                                _radioValue = _options[i];
                                              });
                                              if (_options[i] ==
                                                  FieldValue.inCorrect) {
                                                _displayCommentDialog();
                                              }
                                              Map data = {
                                                'summaryText': _summaryText,
                                                'inspectionValue':
                                                    _inspectionValue
                                              };
                                              triggerUpdate(data);
                                              // }
                                            },
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  color: _radioValue
                                                              .toLowerCase() ==
                                                          _options[i]
                                                              .toLowerCase()
                                                      ? AppColors.radioSelected
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                  border: Border.all(
                                                    color: _radioValue
                                                                .toLowerCase() ==
                                                            _options[i]
                                                                .toLowerCase()
                                                        ? AppColors.primaryBlue
                                                        : AppColors.black16,
                                                  ),
                                                ),
                                                child: Row(children: [
                                                  Radio(
                                                    value: _options[i],
                                                    visualDensity:
                                                        const VisualDensity(
                                                            horizontal: -2.5),
                                                    // dense: true,
                                                    groupValue: _radioValue,
                                                    activeColor:
                                                        AppColors.primaryBlue,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    onChanged: (val) {
                                                      if (widget
                                                              .applicationStatus !=
                                                          InspectionStatus
                                                              .inspectionCompleted) {
                                                        setState(() {
                                                          _radioValue =
                                                              _options[i];
                                                        });
                                                        Map data = {
                                                          'summaryText':
                                                              _summaryText,
                                                          'inspectionValue':
                                                              _inspectionValue
                                                        };
                                                        triggerUpdate(data);
                                                        if (_options[i] ==
                                                            FieldValue
                                                                .inCorrect) {
                                                          _displayCommentDialog();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    _options[i],
                                                    style: GoogleFonts.lato(
                                                      color: AppColors.black87,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13.0,
                                                      letterSpacing: 0.25,
                                                    ),
                                                  ),
                                                ]))),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: IconButton(
                                          onPressed: () {
                                            if (widget.applicationStatus !=
                                                    InspectionStatus
                                                        .inspectionCompleted &&
                                                _radioValue.toLowerCase() ==
                                                    FieldValue.inCorrect
                                                        .toLowerCase()) {
                                              _displayCommentDialog();
                                            }
                                          },
                                          icon: _radioValue.toLowerCase() ==
                                                      FieldValue.inCorrect
                                                          .toLowerCase() &&
                                                  widget.applicationStatus !=
                                                      InspectionStatus
                                                          .inspectionCompleted &&
                                                  widget.applicationStatus !=
                                                      InspectionStatus.approved
                                              ? const Icon(
                                                  Icons.edit,
                                                  color: AppColors.black40,
                                                )
                                              : const Icon(
                                                  Icons.message,
                                                  color: AppColors.black40,
                                                ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: IconButton(
                                          onPressed: () {
                                            if (widget.applicationStatus !=
                                                    InspectionStatus
                                                        .inspectionCompleted &&
                                                _radioValue.toLowerCase() !=
                                                    FieldValue.correct
                                                        .toLowerCase()) {
                                              _photoOptions(context);
                                            }
                                          },
                                          icon: _radioValue.toLowerCase() !=
                                                  FieldValue.correct
                                                      .toLowerCase()
                                              ? const Icon(
                                                  Icons.camera_alt,
                                                  color: AppColors.black40,
                                                )
                                              : const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: AppColors.black40,
                                                ),
                                        ),
                                      )
                                    ],
                                  )),
                              _radioValue.toLowerCase() !=
                                          FieldValue.correct.toLowerCase() &&
                                      _summaryText != ''
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .reasonForIncorrectSelection,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                        ),
                                      ))
                                  : const Center(),
                              _radioValue.toLowerCase() !=
                                          FieldValue.correct.toLowerCase() &&
                                      _summaryText != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColors.black16),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _summaryText,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : const Center(),
                              _radioValue.toLowerCase() !=
                                          FieldValue.correct.toLowerCase() &&
                                      _inspectionValue != ''
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .actualValue,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                        ),
                                      ))
                                  : const Center(),
                              _radioValue.toLowerCase() !=
                                          FieldValue.correct.toLowerCase() &&
                                      _inspectionValue != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 10, 15, 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColors.black16),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        _inspectionValue,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    )
                                  : const Center(),
                              _radioValue.toLowerCase() !=
                                          FieldValue.correct.toLowerCase() &&
                                      _attachment != ''
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .attachment,
                                        style: GoogleFonts.lato(
                                          color: AppColors.black60,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14.0,
                                          letterSpacing: 0.25,
                                        ),
                                      ))
                                  : const Center(),
                              _radioValue.toLowerCase() !=
                                          FieldValue.correct.toLowerCase() &&
                                      _attachment != ''
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColors.black16),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _attachment,
                                              style: GoogleFonts.lato(
                                                color: AppColors.black87,
                                                fontSize: 14.0,
                                                letterSpacing: 0.25,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                    onTap: () async {
                                                      bool isInternetConnected =
                                                          await Helper
                                                              .isInternetConnected();
                                                      if (isInternetConnected) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        FileViewer(
                                                                          fileType:
                                                                              FieldType.image,
                                                                          fileUrl:
                                                                              _attachment,
                                                                        )));
                                                      } else {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AttachmentViewer(
                                                                          fileUrl:
                                                                              _attachment,
                                                                        )));
                                                      }
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 10),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .preview,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: AppColors
                                                                .primaryBlue,
                                                            fontSize: 14.0,
                                                            letterSpacing: 0.25,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ))),
                                                const Spacer(),
                                                widget.applicationStatus !=
                                                        InspectionStatus
                                                            .inspectionCompleted
                                                    ? InkWell(
                                                        onTap: () =>
                                                            _deleteAttachment(
                                                                _attachment),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10),
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .remove,
                                                              style: GoogleFonts
                                                                  .lato(
                                                                color: AppColors
                                                                    .sentForIns,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            )))
                                                    : const Center(),
                                              ],
                                            ),
                                          ]))
                                  : const Center(),
                            ],
                          ))),
                ])));
  }
}
