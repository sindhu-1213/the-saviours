import 'package:flutter/material.dart';
import '../../mock_data/mock_emergency_database.dart';

class AdminState extends ChangeNotifier {
  final List<UserModel> _allUsers = [];
  final List<KycDocument> _kycRequests = [];

  AdminState() {
    _allUsers.addAll(MockEmergencyDatabase.sampleUsers);
    // Add a few extra users for rich management list
    _allUsers.addAll([
      UserModel(
        id: 'USR-DRV-109',
        name: 'Suresh Patil',
        email: 'suresh@ambulance.saviours.org',
        phone: '+91 98451 22301',
        role: UserRole.driver,
        verificationStatus: VerificationStatus.pending,
        vehicleNumber: 'KA-04-E-1088',
      ),
      UserModel(
        id: 'USR-POL-504',
        name: 'SI Ramesh Gowda',
        email: 'ramesh.gowda@traffic.saviours.org',
        phone: '+91 97411 88902',
        role: UserRole.police,
        verificationStatus: VerificationStatus.pending,
        badgeNumber: 'BTP-SI-504',
      ),
      UserModel(
        id: 'USR-CIV-089',
        name: 'Pooja Verma',
        email: 'pooja@civilian.saviours.org',
        phone: '+91 98112 33445',
        role: UserRole.civilian,
        verificationStatus: VerificationStatus.pending,
      ),
      UserModel(
        id: 'USR-CIV-092',
        name: 'Karthik Nair',
        email: 'karthik@civilian.saviours.org',
        phone: '+91 98223 44556',
        role: UserRole.civilian,
        verificationStatus: VerificationStatus.rejected,
        rejectionReason: 'Blurred Aadhaar copy and name mismatch with registration.',
      ),
    ]);

    _kycRequests.addAll(MockEmergencyDatabase.samplePendingKycs);
  }

  List<UserModel> get allUsers => _allUsers;
  List<KycDocument> get kycRequests => _kycRequests;

  int get totalUsersCount => _allUsers.length;
  int get pendingKycCount => _kycRequests.where((k) => k.status == VerificationStatus.pending).length;
  int get verifiedUsersCount => _allUsers.where((u) => u.verificationStatus == VerificationStatus.verified).length;

  void approveKyc(String kycId) {
    final index = _kycRequests.indexWhere((k) => k.id == kycId);
    if (index != -1) {
      final doc = _kycRequests[index];
      doc.status = VerificationStatus.verified;
      
      // Update corresponding user in user list
      final userIndex = _allUsers.indexWhere((u) => u.id == doc.userId || u.name == doc.userName);
      if (userIndex != -1) {
        _allUsers[userIndex].verificationStatus = VerificationStatus.verified;
      }
      notifyListeners();
    }
  }

  void rejectKyc(String kycId, String reason) {
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
      notifyListeners();
    }
  }
}
