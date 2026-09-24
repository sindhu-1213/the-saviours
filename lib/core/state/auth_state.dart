import 'package:flutter/material.dart';
import '../../mock_data/mock_emergency_database.dart';
import '../services/supabase_service.dart';

class AuthState extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedLanguage = 'English';
  UserRole _pendingSignupRole = UserRole.civilian;
  String? _pendingSignupPhone;
  String? _pendingSignupEmail;
  String? _pendingSignupName;
  String? _pendingSignupPassword;
  String? _pendingVehicleNumber;
  String? _pendingBadgeNumber;
  String? _pendingJurisdictionZone;

  AuthState() {
    _initSession();
  }

  Future<void> _initSession() async {
    final client = SupabaseService().client;
    if (client != null && client.auth.currentUser != null) {
      final user = client.auth.currentUser!;
      final profile = await SupabaseService().fetchProfileById(user.id);
      if (profile != null) {
        _currentUser = profile;
        notifyListeners();
        return;
      }
    }
    _currentUser = null;
    notifyListeners();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedLanguage => _selectedLanguage;
  UserRole get pendingSignupRole => _pendingSignupRole;
  String? get pendingSignupPhone => _pendingSignupPhone;
  String? get pendingSignupEmail => _pendingSignupEmail;
  String? get pendingSignupName => _pendingSignupName;
  String? get pendingSignupPassword => _pendingSignupPassword;
  String? get pendingVehicleNumber => _pendingVehicleNumber;
  String? get pendingBadgeNumber => _pendingBadgeNumber;
  String? get pendingJurisdictionZone => _pendingJurisdictionZone;

  bool get isAuthenticated => _currentUser != null;
  bool get isVerified => _currentUser?.verificationStatus == VerificationStatus.verified;
  bool get isPending => _currentUser?.verificationStatus == VerificationStatus.pending;
  bool get isRejected => _currentUser?.verificationStatus == VerificationStatus.rejected;
  UserRole get currentRole => _currentUser?.role ?? UserRole.civilian;

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void setPendingSignupRole(UserRole role) {
    _pendingSignupRole = role;
    notifyListeners();
  }

  void setPendingSignupDetails({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? vehicleNumber,
    String? badgeNumber,
    String? jurisdictionZone,
  }) {
    _pendingSignupName = name;
    _pendingSignupEmail = email;
    _pendingSignupPhone = phone;
    _pendingSignupPassword = password;
    _pendingVehicleNumber = vehicleNumber;
    _pendingBadgeNumber = badgeNumber;
    _pendingJurisdictionZone = jurisdictionZone;
    notifyListeners();
  }

  void setVerificationStatus(VerificationStatus status, {String? reason}) {
    if (_currentUser != null) {
      _currentUser!.verificationStatus = status;
      _currentUser!.rejectionReason = reason;
      SupabaseService().upsertProfile(_currentUser!);
      notifyListeners();
    }
  }

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final supabase = SupabaseService();
    if (!supabase.isInitialized) {
      _isLoading = false;
      _errorMessage = 'Supabase connection is not available. Please check internet.';
      notifyListeners();
      return false;
    }

    final email = identifier.contains('@') ? identifier.trim() : '$identifier@saviours.org';
    final result = await supabase.signIn(
      email: email,
      password: password,
    );

    _isLoading = false;
    if (result.isSuccess && result.user != null) {
      _currentUser = result.user;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.errorMessage ?? 'Invalid email or password. Please check credentials or Register.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerAccount({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
    String? vehicleNumber,
    String? badgeNumber,
    String? jurisdictionZone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final supabase = SupabaseService();
    if (!supabase.isInitialized) {
      _isLoading = false;
      _errorMessage = 'Supabase connection is not available.';
      notifyListeners();
      return false;
    }

    final result = await supabase.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
      role: role,
    );

    if (result.isSuccess && result.user != null) {
      final user = result.user!;
      // Add optional extra profile details
      if (vehicleNumber != null || badgeNumber != null || jurisdictionZone != null) {
        final updatedUser = UserModel(
          id: user.id,
          name: user.name,
          email: user.email,
          phone: user.phone,
          role: user.role,
          verificationStatus: user.verificationStatus,
          vehicleNumber: vehicleNumber ?? user.vehicleNumber,
          badgeNumber: badgeNumber ?? user.badgeNumber,
          jurisdictionZone: jurisdictionZone ?? user.jurisdictionZone,
        );
        await supabase.upsertProfile(updatedUser);
        _currentUser = updatedUser;
      } else {
        _currentUser = user;
      }

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      _errorMessage = result.errorMessage ?? 'Registration failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitKycDocuments({
    required String docType,
    required String docNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    if (_currentUser == null) {
      _isLoading = false;
      return false;
    }

    final kycDoc = KycDocument(
      id: 'KYC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      userId: _currentUser!.id,
      userName: _currentUser!.name,
      role: _currentUser!.role,
      docType: docType,
      docNumber: docNumber,
      uploadedAt: DateTime.now(),
      ocrExtractedName: _currentUser!.name,
      ocrExtractedNumber: docNumber,
    );

    // Save to Supabase
    await SupabaseService().insertKyc(kycDoc);
    
    // Non-civilian accounts remain in Pending state
    if (_currentUser!.role != UserRole.civilian) {
      _currentUser!.verificationStatus = VerificationStatus.pending;
      await SupabaseService().upsertProfile(_currentUser!);
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await SupabaseService().signOut();
    _currentUser = null;
    notifyListeners();
  }
}
