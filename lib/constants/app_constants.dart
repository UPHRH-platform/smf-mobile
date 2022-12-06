const String appVersion = '1.3';
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
  static const String image = "image";
  static const String pdf = "pdf";
  static const String heading = 'heading';
}

class InspectionStatus {
  static const String newInspection = 'NEW';
  static const String sentForInspection = 'SENTFORINS';
  static const String inspectionCompleted = 'INSCOMPLETED';
  static const String leadInspectorCompleted = 'LEADINSCOMPLETED';
  static const String inspectionPending = 'PENDING';
  static const String returned = 'RETURNED';
  static const String approved = 'APPROVED';
  static const String rejected = 'REJECTED';
}

class FieldValue {
  static const String correct = 'Correct';
  static const String inCorrect = 'Incorrect';
}

class AppDatabase {
  static const String name = 'smf_db';
  static const String applicationsTable = 'applications';
  static const String formsTable = 'forms';
  static const String inspectionTable = 'inspections';
  static const String loginPinsTable = 'login_pins';
  static const String attachmentsTable = 'attachments';
}

class Storage {
  static const String userId = 'smf_user_id';
  static const String username = 'smf_user_username';
  static const String email = 'smf_user_email';
  static const String firstname = 'smf_user_first_name';
  static const String lastname = 'smf_user_last_name';
  static const String authtoken = 'smf_user_auth_token';
  static const String applicationId = 'smf_application_id';
  static const String deviceIdentifier = 'smf_device_identifier';
}

class Inspector {
  static const String leadInspector = 'lead_inspector';
  static const String assistantInspector = 'assistant_inspector';
}

class AssessmentSummary {
  static const String inspectionSummary = "Inspection Summary";
  static const String assessmentSummary = "Assessment Summary";
}
