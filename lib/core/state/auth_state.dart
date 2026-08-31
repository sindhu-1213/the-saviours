import 'package:flutter/material.dart';
import '../../mock_data/mock_emergency_database.dart';

class AuthState extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String _selectedLanguage = 'English';
  UserRole _pendingSignupRole = UserRole.civilian;
  String? _pendingSignupPhone;
  String? _pendingSignupEmail;
  String? _pendingSignupName;

  AuthState() {
    // Start with Civilian user by default for immediate preview
    _currentUser = MockEmergencyDatabase.sampleUsers.first;
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get selectedLanguage => _selectedLanguage;
  UserRole get pendingSignupRole => _pendingSignupRole;
  String? get pendingSignupPhone => _pendingSignupPhone;
  String? get pendingSignupEmail => _pendingSignupEmail;
  String? get pendingSignupName => _pendingSignupName;

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
  }) {
    _pendingSignupName = name;
    _pendingSignupEmail = email;
    _pendingSignupPhone = phone;
    notifyListeners();
  }

  // Quick Switcher for testing and role previews
  void switchToRole(UserRole role) {
    _currentUser = MockEmergencyDatabase.sampleUsers.firstWhere(
      (u) => u.role == role,
      orElse: () => MockEmergencyDatabase.sampleUsers.first,
    );
    notifyListeners();
  }

  void setVerificationStatus(VerificationStatus status, {String? reason}) {
    if (_currentUser != null) {
      _currentUser!.verificationStatus = status;
      _currentUser!.rejectionReason = reason;
      notifyListeners();
    }
  }

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _isLoading = false;

    // Detect user role from identifier or match sample users
    final lower = identifier.toLowerCase();
    if (lower.contains('driver') || lower.contains('108') || lower.contains('rajesh')) {
      _currentUser = MockEmergencyDatabase.sampleUsers[1];
    } else if (lower.contains('police') || lower.contains('traffic') || lower.contains('vikram')) {
      _currentUser = MockEmergencyDatabase.sampleUsers[2];
    } else if (lower.contains('admin') || lower.contains('control') || lower.contains('ananya')) {
      _currentUser = MockEmergencyDatabase.sampleUsers[3];
    } else {
      // Default to Civilian or match existing
      _currentUser = MockEmergencyDatabase.sampleUsers[0];
    }

    notifyListeners();
    return true;
  }

  Future<void> submitKycDocuments({
    required String docType,
    required String docNumber,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;

    // Create a new pending user
    _currentUser = UserModel(
      id: 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      name: _pendingSignupName ?? 'New User',
      email: _pendingSignupEmail ?? 'user@saviours.org',
      phone: _pendingSignupPhone ?? '+91 99999 88888',
      role: _pendingSignupRole,
      verificationStatus: VerificationStatus.pending,
    );

    // Add to pending KYCs in database
    MockEmergencyDatabase.samplePendingKycs.insert(
      0,
      KycDocument(
        id: 'KYC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        userId: _currentUser!.id,
        userName: _currentUser!.name,
        role: _currentUser!.role,
        docType: docType,
        docNumber: docNumber,
        uploadedAt: DateTime.now(),
        ocrExtractedName: _currentUser!.name,
        ocrExtractedNumber: docNumber,
      ),
    );

    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
