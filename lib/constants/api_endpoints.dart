class ApiUrl {
  static const baseUrl = 'https://smfdev.idc.tarento.com';
  static const getOtp = '$baseUrl/api/user/requestOTP';
  static const validateOtp = '$baseUrl/api/signIn';
  static const updateUserDeviceToken =
      '$baseUrl/api/user/updateUserDeviceToken';
  static const getAllApplications = '$baseUrl/api/forms/getAllApplications';
  static const submitInspection = '$baseUrl/api/forms/submitInspection';
  static const getAllUsers = '$baseUrl/api/user/v1/getAllUser';
  static const getFormDetails = '$baseUrl/api/forms/getFormById?id=';
}
