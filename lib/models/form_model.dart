class FormData {
  final int id;
  final int version;
  final String title;
  final String description;
  final List<dynamic> fields;
  final List<dynamic> inspectionFields;
  final int updatedDate;

  const FormData({
    required this.id,
    required this.version,
    required this.title,
    required this.description,
    required this.fields,
    required this.inspectionFields,
    required this.updatedDate,
  });

  factory FormData.fromJson(Map<String, dynamic> json) {
    return FormData(
        id: json['id'],
        version: json['version'],
        title: json['title'],
        description: json['description'],
        fields: json['fields'],
        inspectionFields: json['inspectionFields'] ?? [],
        updatedDate: json['updatedDate']);
  }

  List<Object> get props => [
        id,
        version,
        title,
        description,
        fields,
        inspectionFields,
        updatedDate,
      ];
}
