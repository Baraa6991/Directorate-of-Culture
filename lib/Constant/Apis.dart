class ApiConstants {
  static final baseUrl = 'http://192.168.43.94:8000/api';
   static String register() => '$baseUrl/register/send-otp';
  static String registerVerifyOTP() => '$baseUrl/register/verify-otp';
  static String registerOTPResend() => '$baseUrl/register/resend-otp';
  static String loginSendOtp() => '$baseUrl/login/send-otp';
  static String loginVerifyOtp() => '$baseUrl/login/verify-otp';
  static String resendLoginOtp() => '$baseUrl/login/resend-otp';
  static String profile() => '$baseUrl/profile';
  static String profileAvatar() => '$baseUrl/profile/avatar';
  static String ads() => '$baseUrl/ads';
  static String comingActivities() => '$baseUrl/activities/coming';
  static String finishedActivities() => '$baseUrl/activities/finished';
  static String volunteer() => '$baseUrl/volunteerings';
  static String culturalCenters() => '$baseUrl/centers';
  static String activityTypes() => '$baseUrl/activity-types';
  static String centers() => '$baseUrl/centers';
  static String culturalCenterDetails(String id) => '$baseUrl/centers/$id';
  static String venueReservations() => '$baseUrl/venue-reservations';
  static String activities() => '$baseUrl/activities/coming';

  // ✅ جديد: تفاصيل فعالية واحدة عبر GET /activities/{id}
  // (منفصل تماماً عن activities()/comingActivities() اللتين تشيران لقائمة /activities/coming)
  static String activityDetails(String id) => '$baseUrl/activities/$id';

  static String reservations() => '$baseUrl/reservations';
  static String reservationDetails(String id) => '$baseUrl/reservations/$id';
  static String cancelReservation(String id) =>
      '$baseUrl/reservations/$id/cancel';

  static String assistantAsk() => '$baseUrl/assistant/ask';
  static String aiCompare() => '$baseUrl/ai/compare';
  static String aiForYou() => '$baseUrl/ai/for-you';

  static String books = "$baseUrl/books";
  static String deviceTokens() => '$baseUrl/device-tokens';
  static String notifications() => '$baseUrl/notifications';
  static String notificationsUnreadCount() => '$baseUrl/notifications/unread-count';
  static String notificationMarkAsRead(String id) => '$baseUrl/notifications/$id/read';
  static String notificationsMarkAllAsRead() => '$baseUrl/notifications/read-all';
  static String notificationDelete(String id) => '$baseUrl/notifications/$id';
}