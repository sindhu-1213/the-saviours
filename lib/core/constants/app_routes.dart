class AppRoutes {
  // Auth & Common
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String language = '/language';
  static const String login = '/login';
  static const String roleSelection = '/role_selection';
  static const String signupBasic = '/signup_basic';
  static const String otpVerification = '/otp_verification';
  static const String kycUpload = '/kyc_upload';
  static const String verificationPending = '/verification_pending';
  static const String verificationRejected = '/verification_rejected';
  static const String forgotPassword = '/forgot_password';
  static const String resetPassword = '/reset_password';
  static const String roleRedirect = '/role_redirect';

  // Civilian
  static const String civilianHome = '/civilian_home';
  static const String civilianReportCamera = '/civilian_report_camera';
  static const String civilianAiVerifying = '/civilian_ai_verifying';
  static const String civilianIncidentVerified = '/civilian_incident_verified';
  static const String civilianIncidentRejected = '/civilian_incident_rejected';
  static const String civilianMyReports = '/civilian_my_reports';
  static const String civilianLiveTracking = '/civilian_live_tracking';
  static const String civilianAnalytics = '/civilian_analytics';
  static const String civilianNotifications = '/civilian_notifications';
  static const String civilianProfile = '/civilian_profile';
  static const String civilianSettings = '/civilian_settings';
  static const String civilianHelp = '/civilian_help';

  // Ambulance Driver
  static const String driverHome = '/driver_home';
  static const String driverAssignmentAlert = '/driver_assignment_alert';
  static const String driverIncidentDetails = '/driver_incident_details';
  static const String driverCriticalitySelection = '/driver_criticality_selection';
  static const String driverNavCycle1 = '/driver_nav_cycle1';
  static const String driverPatientOnboard = '/driver_patient_onboard';
  static const String driverHospitalSuggestion = '/driver_hospital_suggestion';
  static const String driverNavCycle2 = '/driver_nav_cycle2';
  static const String driverDropoffConfirmation = '/driver_dropoff_confirmation';
  static const String driverTripSummary = '/driver_trip_summary';
  static const String driverTripHistory = '/driver_trip_history';
  static const String driverAnalytics = '/driver_analytics';
  static const String driverNotifications = '/driver_notifications';
  static const String driverProfile = '/driver_profile';
  static const String driverSettings = '/driver_settings';
  static const String driverHelp = '/driver_help';

  // Traffic Police
  static const String policeHome = '/police_home';
  static const String policeLiveMap = '/police_live_map';
  static const String policeAssignedJunction = '/police_assigned_junction';
  static const String policeTrafficClearance = '/police_traffic_clearance';
  static const String policeActiveIncidents = '/police_active_incidents';
  static const String policeClearanceHistory = '/police_clearance_history';
  static const String policeAnalytics = '/police_analytics';
  static const String policeNotifications = '/police_notifications';
  static const String policeProfile = '/police_profile';
  static const String policeSettings = '/police_settings';
  static const String policeHelp = '/police_help';

  // Admin
  static const String adminHome = '/admin_home';
  static const String adminOverallAnalytics = '/admin_overall_analytics';
  static const String adminUserManagement = '/admin_user_management';
  static const String adminVerificationReview = '/admin_verification_review';
  static const String adminAllIncidents = '/admin_all_incidents';
  static const String adminIncidentAuditTrail = '/admin_incident_audit_trail';
  static const String adminReportsExport = '/admin_reports_export';
  static const String adminNotifications = '/admin_notifications';
  static const String adminProfile = '/admin_profile';
  static const String adminSettings = '/admin_settings';
  static const String adminHelp = '/admin_help';
}
