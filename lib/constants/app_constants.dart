const String appVersion = '1.0';
const String appName = 'UP SMF';
const int inspectorRoleId = 2093;

class FieldType {
  static const String text = "text";
  static const String date = "date";
  static const String email = "email";
  static const String numeric = "numeric";
  static const String textarea = "textarea";
  static const String dropdown = "dropdown";
  static const String multiselect = "multiselect";
  static const String checkbox = "checkbox";
  static const String radio = "radio";
  static const String boolean = "boolean";
  static const String file = "file";
  static const String heading = 'heading';
}

class InspectionStatus {
  static const String sentForInspection = 'SENTFORINS';
  static const String inspectionCompleted = 'INSCOMPLETED';
}
