class Application {
  final int formId;
  final String applicationId;
  final String title;
  final String email;
  final String status;
  final Map dataObject;
  final String createdDate;
  final String createdBy;

  const Application({
    required this.formId,
    required this.applicationId,
    required this.title,
    required this.email,
    required this.status,
    required this.dataObject,
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
        createdDate,
        createdBy
      ];
}
