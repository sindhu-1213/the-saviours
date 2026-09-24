import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_routes.dart';
import 'core/services/api_config.dart';
import 'core/services/supabase_service.dart';
import 'core/state/admin_state.dart';
import 'core/state/auth_state.dart';
import 'core/state/incident_state.dart';
import 'core/theme/app_theme.dart';

// Auth & Common
import 'features/auth/forgot_password_screen.dart';
import 'features/auth/kyc_upload_screen.dart';
import 'features/auth/language_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/onboarding_screen.dart';
import 'features/auth/otp_verification_screen.dart';
import 'features/auth/reset_password_screen.dart';
import 'features/auth/role_selection_screen.dart';
import 'features/auth/signup_basic_screen.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/verification_pending_screen.dart';
import 'features/auth/verification_rejected_screen.dart';

// Civilian Flow
import 'features/civilian/ai_verifying_screen.dart';
import 'features/civilian/civilian_analytics.dart';
import 'features/civilian/civilian_dashboard.dart';
import 'features/civilian/civilian_help_support.dart';
import 'features/civilian/civilian_notifications.dart';
import 'features/civilian/civilian_profile.dart';
import 'features/civilian/civilian_settings.dart';
import 'features/civilian/incident_rejected_screen.dart';
import 'features/civilian/incident_verified_screen.dart';
import 'features/civilian/live_incident_tracking.dart';
import 'features/civilian/my_reports_screen.dart';
import 'features/civilian/report_accident_camera.dart';

// Ambulance Driver Flow
import 'features/driver/criticality_selection.dart';
import 'features/driver/driver_analytics.dart';
import 'features/driver/driver_dashboard.dart';
import 'features/driver/driver_help_support.dart';
import 'features/driver/driver_notifications.dart';
import 'features/driver/driver_profile.dart';
import 'features/driver/driver_settings.dart';
import 'features/driver/driver_trip_history.dart';
import 'features/driver/dropoff_confirmation_screen.dart';
import 'features/driver/hospital_suggestion_screen.dart';
import 'features/driver/incident_assignment_alert.dart';
import 'features/driver/incident_details_screen.dart';
import 'features/driver/live_nav_cycle1_screen.dart';
import 'features/driver/live_nav_cycle2_screen.dart';
import 'features/driver/patient_onboard_screen.dart';
import 'features/driver/trip_summary_screen.dart';

// Traffic Police Flow
import 'features/police/active_incidents_list.dart';
import 'features/police/assigned_junction_screen.dart';
import 'features/police/clearance_history.dart';
import 'features/police/live_ambulance_map.dart';
import 'features/police/police_analytics.dart';
import 'features/police/police_dashboard.dart';
import 'features/police/police_help_support.dart';
import 'features/police/police_notifications.dart';
import 'features/police/police_profile.dart';
import 'features/police/police_settings.dart';
import 'features/police/traffic_clearance_screen.dart';

// Admin Flow
import 'features/admin/admin_dashboard.dart';
import 'features/admin/admin_help_support.dart';
import 'features/admin/admin_notifications.dart';
import 'features/admin/admin_profile.dart';
import 'features/admin/admin_settings.dart';
import 'features/admin/all_incidents_screen.dart';
import 'features/admin/incident_audit_trail.dart';
import 'features/admin/overall_analytics_screen.dart';
import 'features/admin/reports_export_screen.dart';
import 'features/admin/user_management_screen.dart';
import 'features/admin/verification_review_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.initialize();
  await SupabaseService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => IncidentState()),
        ChangeNotifierProvider(create: (_) => AdminState()),
      ],
      child: const SavioursApp(),
    ),
  );
}

class SavioursApp extends StatelessWidget {
  const SavioursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saviours',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        // Auth & Common
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.language: (_) => const LanguageScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.roleSelection: (_) => const RoleSelectionScreen(),
        AppRoutes.signupBasic: (_) => const SignupBasicScreen(),
        AppRoutes.otpVerification: (_) => const OtpVerificationScreen(),
        AppRoutes.kycUpload: (_) => const KycUploadScreen(),
        AppRoutes.verificationPending: (_) => const VerificationPendingScreen(),
        AppRoutes.verificationRejected: (_) => const VerificationRejectedScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.resetPassword: (_) => const ResetPasswordScreen(),

        // Civilian
        AppRoutes.civilianHome: (_) => const CivilianDashboard(),
        AppRoutes.civilianReportCamera: (_) => const ReportAccidentCamera(),
        AppRoutes.civilianAiVerifying: (_) => const AiVerifyingScreen(),
        AppRoutes.civilianIncidentVerified: (_) => const IncidentVerifiedScreen(),
        AppRoutes.civilianIncidentRejected: (_) => const IncidentRejectedScreen(),
        AppRoutes.civilianMyReports: (_) => const MyReportsScreen(),
        AppRoutes.civilianLiveTracking: (_) => const LiveIncidentTracking(),
        AppRoutes.civilianAnalytics: (_) => const CivilianAnalytics(),
        AppRoutes.civilianNotifications: (_) => const CivilianNotifications(),
        AppRoutes.civilianProfile: (_) => const CivilianProfile(),
        AppRoutes.civilianSettings: (_) => const CivilianSettings(),
        AppRoutes.civilianHelp: (_) => const CivilianHelpSupport(),

        // Ambulance Driver
        AppRoutes.driverHome: (_) => const DriverDashboard(),
        AppRoutes.driverAssignmentAlert: (_) => const IncidentAssignmentAlert(),
        AppRoutes.driverIncidentDetails: (_) => const IncidentDetailsScreen(),
        AppRoutes.driverCriticalitySelection: (_) => const CriticalitySelection(),
        AppRoutes.driverNavCycle1: (_) => const LiveNavCycle1Screen(),
        AppRoutes.driverPatientOnboard: (_) => const PatientOnboardScreen(),
        AppRoutes.driverHospitalSuggestion: (_) => const HospitalSuggestionScreen(),
        AppRoutes.driverNavCycle2: (_) => const LiveNavCycle2Screen(),
        AppRoutes.driverDropoffConfirmation: (_) => const DropoffConfirmationScreen(),
        AppRoutes.driverTripSummary: (_) => const TripSummaryScreen(),
        AppRoutes.driverTripHistory: (_) => const DriverTripHistory(),
        AppRoutes.driverAnalytics: (_) => const DriverAnalytics(),
        AppRoutes.driverNotifications: (_) => const DriverNotifications(),
        AppRoutes.driverProfile: (_) => const DriverProfile(),
        AppRoutes.driverSettings: (_) => const DriverSettings(),
        AppRoutes.driverHelp: (_) => const DriverHelpSupport(),

        // Traffic Police
        AppRoutes.policeHome: (_) => const PoliceDashboard(),
        AppRoutes.policeLiveMap: (_) => const LiveAmbulanceMap(),
        AppRoutes.policeAssignedJunction: (_) => const AssignedJunctionScreen(),
        AppRoutes.policeTrafficClearance: (_) => const TrafficClearanceScreen(),
        AppRoutes.policeActiveIncidents: (_) => const ActiveIncidentsList(),
        AppRoutes.policeClearanceHistory: (_) => const ClearanceHistory(),
        AppRoutes.policeAnalytics: (_) => const PoliceAnalytics(),
        AppRoutes.policeNotifications: (_) => const PoliceNotifications(),
        AppRoutes.policeProfile: (_) => const PoliceProfile(),
        AppRoutes.policeSettings: (_) => const PoliceSettings(),
        AppRoutes.policeHelp: (_) => const PoliceHelpSupport(),

        // Admin
        AppRoutes.adminHome: (_) => const AdminDashboard(),
        AppRoutes.adminOverallAnalytics: (_) => const OverallAnalyticsScreen(),
        AppRoutes.adminUserManagement: (_) => const UserManagementScreen(),
        AppRoutes.adminVerificationReview: (_) => const VerificationReviewScreen(),
        AppRoutes.adminAllIncidents: (_) => const AllIncidentsScreen(),
        AppRoutes.adminIncidentAuditTrail: (_) => const IncidentAuditTrail(),
        AppRoutes.adminReportsExport: (_) => const ReportsExportScreen(),
        AppRoutes.adminNotifications: (_) => const AdminNotifications(),
        AppRoutes.adminProfile: (_) => const AdminProfile(),
        AppRoutes.adminSettings: (_) => const AdminSettings(),
        AppRoutes.adminHelp: (_) => const AdminHelpSupport(),
      },
    );
  }
}
