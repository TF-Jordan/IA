/// Single source of truth for every API endpoint the app communicates with.
///
/// Usage:
/// ```dart
/// final url = Uri.parse(ApiRoutes.login);
/// ```
///
/// When the backend team updates a route, only THIS file changes.
class ApiRoutes {
  ApiRoutes._();

  // ──────────────────────────────────────────────
  //  BASE
  // ──────────────────────────────────────────────
  static const String _baseUrl = 'https://api.chf-app.com';
  static const String _apiVersion = '/api/v1';
  static const String _base = '$_baseUrl$_apiVersion';

  // ──────────────────────────────────────────────
  //  AUTHENTICATION
  // ──────────────────────────────────────────────
  static const String login = '$_base/auth/login';
  static const String register = '$_base/auth/register';
  static const String logout = '$_base/auth/logout';
  static const String refreshToken = '$_base/auth/refresh-token';
  static const String forgotPassword = '$_base/auth/forgot-password';
  static const String resetPassword = '$_base/auth/reset-password';
  static const String verifyEmail = '$_base/auth/verify-email';
  static const String changePassword = '$_base/auth/change-password';

  // ──────────────────────────────────────────────
  //  MEMBERS
  // ──────────────────────────────────────────────
  static const String members = '$_base/members';
  static String memberById(String id) => '$_base/members/$id';
  static String memberProfile(String id) => '$_base/members/$id/profile';
  static String memberAttendance(String id) => '$_base/members/$id/attendance';
  static String memberStats(String id) => '$_base/members/$id/stats';

  // ──────────────────────────────────────────────
  //  CLUBS
  // ──────────────────────────────────────────────
  static const String clubs = '$_base/clubs';
  static String clubById(String id) => '$_base/clubs/$id';
  static String clubMembers(String id) => '$_base/clubs/$id/members';
  static String clubStats(String id) => '$_base/clubs/$id/stats';

  // ──────────────────────────────────────────────
  //  EVENTS
  // ──────────────────────────────────────────────
  static const String events = '$_base/events';
  static String eventById(String id) => '$_base/events/$id';
  static String eventRegister(String id) => '$_base/events/$id/register';
  static String eventAttendance(String id) => '$_base/events/$id/attendance';
  static String eventClose(String id) => '$_base/events/$id/close';

  // ──────────────────────────────────────────────
  //  REPORTS
  // ──────────────────────────────────────────────
  static const String reports = '$_base/reports';
  static String reportById(String id) => '$_base/reports/$id';
  static String reportValidate(String id) => '$_base/reports/$id/validate';
  static String reportReject(String id) => '$_base/reports/$id/reject';
  static const String reportsSummary = '$_base/reports/summary';
  static const String dashboard = '$_base/reports/dashboard';

  // ──────────────────────────────────────────────
  //  INTERCESSION & PRAYER
  // ──────────────────────────────────────────────
  static const String prayerSessions = '$_base/prayer/sessions';
  static String prayerSessionById(String id) => '$_base/prayer/sessions/$id';
  static const String prayerChains = '$_base/prayer/chains';
  static String prayerChainById(String id) => '$_base/prayer/chains/$id';

  // ──────────────────────────────────────────────
  //  EVANGELISM
  // ──────────────────────────────────────────────
  static const String campaigns = '$_base/evangelism/campaigns';
  static String campaignById(String id) => '$_base/evangelism/campaigns/$id';
  static String campaignResults(String id) =>
      '$_base/evangelism/campaigns/$id/results';
  static const String evangelismStats = '$_base/evangelism/stats';
  static const String converts = '$_base/evangelism/converts';
  static String convertFollowUp(String id) =>
      '$_base/evangelism/converts/$id/follow-up';

  // ──────────────────────────────────────────────
  //  DISCIPLESHIP
  // ──────────────────────────────────────────────
  static const String discipleshipGroups = '$_base/discipleship/groups';
  static String discipleshipGroupById(String id) =>
      '$_base/discipleship/groups/$id';
  static const String discipleshipSessions = '$_base/discipleship/sessions';
  static const String dailyAccounts = '$_base/discipleship/accounts/daily';
  static const String monthlyAccounts = '$_base/discipleship/accounts/monthly';
  static String discipleProgress(String id) =>
      '$_base/discipleship/disciples/$id/progress';
  static String discipleEvaluate(String id) =>
      '$_base/discipleship/disciples/$id/evaluate';
  static String discipleCertificate(String id) =>
      '$_base/discipleship/disciples/$id/certificate';

  // ──────────────────────────────────────────────
  //  ADMINISTRATION
  // ──────────────────────────────────────────────
  static const String users = '$_base/admin/users';
  static String userById(String id) => '$_base/admin/users/$id';
  static const String roles = '$_base/admin/roles';
  static const String permissions = '$_base/admin/permissions';
  static const String schoolYearReset = '$_base/admin/school-year/reset';
  static const String objectives = '$_base/admin/objectives';
  static const String backups = '$_base/admin/backups';
  static const String logs = '$_base/admin/logs';

  // ──────────────────────────────────────────────
  //  PUBLICATIONS
  // ──────────────────────────────────────────────
  static const String dailyVerse = '$_base/publications/daily-verse';
  static const String announcements = '$_base/publications/announcements';

  // ──────────────────────────────────────────────
  //  SCHOOLS (for registration dropdown)
  // ──────────────────────────────────────────────
  static const String schools = '$_base/schools';
}
