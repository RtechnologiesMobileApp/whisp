class ApiEndpoints {
   static const String baseUrl = "https://whisp-backend-production-1880.up.railway.app";  

 
  static const String login = "/api/auth/login";
  static const String signUp = "/api/auth/register";
  static const String forgotPassword = "$baseUrl/api/auth/forgot-password";
  static const String verifyOtp = "$baseUrl/api/auth/verify-reset-otp";
 
 static const String updateProfile = "$baseUrl/api/auth/profile";
 
 static const String resetPassword = "$baseUrl/api/auth/reset-password";  
 static const String checkEmailExists = "$baseUrl/api/auth/check-email";
 
}
 