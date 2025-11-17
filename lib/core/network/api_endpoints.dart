class ApiEndpoints {

 //static const String baseUrl = "https://whisp-backend-production-1880.up.railway.app";  
   static const String baseUrl = "https://29c0bf1e0447.ngrok-free.app";  

 
   
  static const String login = "/api/auth/login";
  static const String signUp = "/api/auth/register";
  static const String forgotPassword = "$baseUrl/api/auth/forgot-password";
  static const String verifyOtp = "$baseUrl/api/auth/verify-reset-otp";
  static const String updateProfile = "$baseUrl/api/auth/profile";
  static const String resetPassword = "$baseUrl/api/auth/reset-password";  
  static const String checkEmailExists = "$baseUrl/api/auth/check-account";
  static const String getFriends = "$baseUrl/api/friend/list";
  static const String getFriendRequests = "$baseUrl/api/friend/incoming-requests";
  static const String unfriend="$baseUrl/api/friend/unfriend";   ///api/friend/unfriend/<userId>
  static const String getFriendChatHistory = "$baseUrl/api/chat/history/";  ///api/chat/history/userID   ( friends id whose history you want to see )
  static const String getFreindChatList="$baseUrl/api/friend/chat-list";
 static const String blockUser="$baseUrl/api/moderation/block";  
  static const String unblockUser="$baseUrl/api/moderation/block";
  static const String reportUser="$baseUrl/api/moderation/report"; // /api/moderation/block/{{targetUserId}}
  static const String getBlockedUsers="$baseUrl/api/moderation/block";
  static const String setPreferences="$baseUrl/api/auth/preferences";
  static const String sendVoiceMessage="$baseUrl/api/chat/voice-note/"; ///api/chat/voice-note/<user id> ( user id to whom send the msg)
}
 