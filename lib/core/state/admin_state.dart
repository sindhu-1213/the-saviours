import 'package:flutter/material.dart';
import '../../mock_data/mock_emergency_database.dart';
import '../services/supabase_service.dart';

class AdminState extends ChangeNotifier {
  final List<UserModel> _allUsers = [];
  final List<KycDocument> _kycRequests = [];
  bool _isLoading = false;

  AdminState() {
    _initData();
  }

  List<UserModel> get allUsers => _allUsers;
  List<KycDocument> get kycRequests => _kycRequests;
  bool get isLoading => _isLoading;

  int get totalUsersCount => _allUsers.length;
  int get pendingKycCount => _kycRequests.where((k) => k.status == VerificationStatus.pending).length;
  int get verifiedUsersCount => _allUsers.where((u) => u.verificationStatus == VerificationStatus.verified).length;

  Future<void> _initData() async {
    _isLoading = true;
    notifyListeners();

    final supabase = SupabaseService();
    if (supabase.isInitialized) {
      final remoteUsers = await supabase.fetchProfiles();
      final remoteKycs = await supabase.fetchKycs();

      if (remoteUsers.isNotEmpty) {
        _allUsers.clear();
        _allUsers.addAll(remoteUsers);
      }
      if (remoteKycs.isNotEmpty) {
        _kycRequests.clear();
        _kycRequests.addAll(remoteKycs);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> approveKyc(String kycId) async {
    final index = _kycRequests.indexWhere((k) => k.id == kycId);
    if (index != -1) {
      final doc = _kycRequests[index];
      doc.status = VerificationStatus.verified;
      
      final userIndex = _allUsers.indexWhere((u) => u.id == doc.userId || u.name == doc.userName);
      if (userIndex != -1) {
        _allUsers[userIndex].verificationStatus = VerificationStatus.verified;
      }

      await SupabaseService().updateKycStatus(kycId, doc.userId, VerificationStatus.verified);
      notifyListeners();
    }
  }

  Future<void> rejectKyc(String kycId, String reason) async {
    final index = _kycRequests.indexWhere((k) => k.id == kycId);
    if (index != -1) {
      final doc = _kycRequests[index];
      doc.status = VerificationStatus.rejected;
      doc.rejectionReason = reason;

      final userIndex = _allUsers.indexWhere((u) => u.id == doc.userId || u.name == doc.userName);
      if (userIndex != -1) {
        _allUsers[userIndex].verificationStatus = VerificationStatus.rejected;
        _allUsers[userIndex].rejectionReason = reason;
      }

      await SupabaseService().updateKycStatus(kycId, doc.userId, VerificationStatus.rejected, reason: reason);
      notifyListeners();
    }
  }
}
