class ApiUrl {
  static const baseUrl = 'https://smfdev.idc.tarento.com';
  static const getOtp = '$baseUrl/api/user/requestOTP';
  static const validateOtp = '$baseUrl/api/signIn';
  static const generatePin = '$baseUrl/api/user/generatePin';
  static const updateUserDeviceToken =
      '$baseUrl/api/user/updateUserDeviceToken';
  static const getAllApplications = '$baseUrl/api/forms/getAllApplications';
  static const submitInspection = '$baseUrl/api/forms/submitInspection';
  static const submitBulkInspection = '$baseUrl/api/forms/submitBulkInspection';
  static const getAllUsers = '$baseUrl/api/user/v1/getAllUser';
  static const getFormDetails = '$baseUrl/api/forms/getFormById?id=';
  static const submitConcent = '$baseUrl/api/forms/consentApplication';
  static const submitBulkConcent = '$baseUrl/api/forms/consentBulkApplication';
  static const getAllForms = '$baseUrl/api/forms/getAllForms?isDetail=true';
  static const fileUpload = '$baseUrl/api/forms/fileUpload';
  static const deleteFile = '$baseUrl/api/forms/deleteCloudFile';
  static const deleteDeviceToken =
      '$baseUrl/api/user/deleteDeviceToken?deviceId=';
}
