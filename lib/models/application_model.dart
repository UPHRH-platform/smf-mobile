import 'package:intl/intl.dart';

class Application {
  final int formId;
  final String applicationId;
  final String title;
  final String email;
  final String status;
  final Map dataObject;
  final List inspectors;
  final List leadInspector;
  final Map inspectorDataObject;
  final Map inspectorSummaryDataObject;
  final String scheduledDate;
  final String createdDate;
  final String createdBy;

  const Application({
    required this.formId,
    required this.applicationId,
    required this.title,
    required this.email,
    required this.status,
    required this.dataObject,
    required this.inspectors,
    required this.leadInspector,
    required this.inspectorDataObject,
    required this.inspectorSummaryDataObject,
    required this.scheduledDate,
    required this.createdDate,
    required this.createdBy,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      formId: json['formId'],
      applicationId: json['applicationId'],
      title: json['title'],
      email: json['email'] ?? '',
      status: json['status'],
      dataObject: json['dataObject'],
      inspectors: json['inspection']['assignedTo'] ?? [],
      leadInspector: json['inspection']['leadInspector'] ?? [],
      inspectorDataObject: json['inspectorDataObject'] != null
          ? json['inspectorDataObject']['dataObject']
          : {},
      inspectorSummaryDataObject: json['inspectorSummaryDataObject'] ?? {},
      scheduledDate: json['inspection']['scheduledDate'] ?? '',
      createdDate: json['createdDate'],
      createdBy: json['createdBy'],
    );
  }

  List<Object> get props => [
        formId,
        applicationId,
        title,
        email,
        status,
        dataObject,
        inspectors,
        leadInspector,
        inspectorDataObject,
        inspectorSummaryDataObject,
        scheduledDate,
        createdDate,
        createdBy
      ];
}
