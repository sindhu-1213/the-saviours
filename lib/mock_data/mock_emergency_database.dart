import 'package:flutter/material.dart';

enum UserRole { civilian, driver, police, admin }
enum VerificationStatus { verified, pending, rejected }
enum IncidentCriticality { low, medium, high, critical }
enum IncidentStatus { 
  verifying, 
  verified, 
  rejected, 
  driverDispatched, 
  patientOnboard, 
  hospitalTransport, 
  completed 
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  VerificationStatus verificationStatus;
  String? rejectionReason;
  final String? badgeNumber;
  final String? vehicleNumber;
  final String? jurisdictionZone;
  final String? aadhaarMasked;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.verificationStatus = VerificationStatus.verified,
    this.rejectionReason,
    this.badgeNumber,
    this.vehicleNumber,
    this.jurisdictionZone,
    this.aadhaarMasked = 'XXXX-XXXX-8921',
    this.avatarUrl = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
  });
}

class KycDocument {
  final String id;
  final String userId;
  final String userName;
  final UserRole role;
  final String docType;
  final String docNumber;
  final DateTime uploadedAt;
  VerificationStatus status;
  final int aiAuthenticityScore;
  final bool tamperFlag;
  final String ocrExtractedName;
  final String ocrExtractedNumber;
  String? rejectionReason;

  KycDocument({
    required this.id,
    required this.userId,
    required this.userName,
    required this.role,
    required this.docType,
    required this.docNumber,
    required this.uploadedAt,
    this.status = VerificationStatus.pending,
    this.aiAuthenticityScore = 94,
    this.tamperFlag = false,
    required this.ocrExtractedName,
    required this.ocrExtractedNumber,
    this.rejectionReason,
  });
}

class AuditEntry {
  final String stage;
  final String action;
  final DateTime timestamp;
  final String actorName;
  final String actorRole;
  final String details;

  AuditEntry({
    required this.stage,
    required this.action,
    required this.timestamp,
    required this.actorName,
    required this.actorRole,
    required this.details,
  });
}

class IncidentModel {
  final String id;
  final String reporterId;
  final String reporterName;
  final String reporterPhone;
  final String locationName;
  final double latitude;
  final double longitude;
  final int aiConfidenceScore;
  IncidentStatus status;
  IncidentCriticality criticality;
  final DateTime createdAt;
  String? assignedDriverId;
  String? assignedDriverName;
  String? assignedVehicle;
  String? assignedHospitalId;
  String? assignedHospitalName;
  List<String> clearedJunctions;
  List<AuditEntry> auditLogs;
  String? rejectionReason;

  IncidentModel({
    required this.id,
    required this.reporterId,
    required this.reporterName,
    required this.reporterPhone,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.aiConfidenceScore,
    this.status = IncidentStatus.verified,
    this.criticality = IncidentCriticality.high,
    required this.createdAt,
    this.assignedDriverId,
    this.assignedDriverName,
    this.assignedVehicle,
    this.assignedHospitalId,
    this.assignedHospitalName,
    List<String>? clearedJunctions,
    List<AuditEntry>? auditLogs,
    this.rejectionReason,
  })  : clearedJunctions = clearedJunctions ?? [],
        auditLogs = auditLogs ?? [];
}

class HospitalModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final int driveTimeMinutes;
  final String specialization;
  final int availableBeds;
  final int traumaCapacity;
  final bool hasCardiacUnit;

  HospitalModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.driveTimeMinutes,
    required this.specialization,
    required this.availableBeds,
    required this.traumaCapacity,
    required this.hasCardiacUnit,
  });
}

class TripRecord {
  final String id;
  final String incidentId;
  final String driverId;
  final String location;
  final String hospitalName;
  final DateTime startTime;
  final DateTime endTime;
  final double distanceKm;
  final int totalMinutes;
  final int junctionsCleared;
  final String status;

  TripRecord({
    required this.id,
    required this.incidentId,
    required this.driverId,
    required this.location,
    required this.hospitalName,
    required this.startTime,
    required this.endTime,
    required this.distanceKm,
    required this.totalMinutes,
    required this.junctionsCleared,
    required this.status,
  });
}

class ClearanceRecord {
  final String id;
  final String incidentId;
  final String officerId;
  final String officerName;
  final String junctionName;
  final DateTime clearedAt;
  final String congestionLevel;
  final int secondsToClear;

  ClearanceRecord({
    required this.id,
    required this.incidentId,
    required this.officerId,
    required this.officerName,
    required this.junctionName,
    required this.clearedAt,
    required this.congestionLevel,
    required this.secondsToClear,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final String? deepLinkRoute;
  final IconData icon;
  final Color iconColor;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.deepLinkRoute,
    this.icon = Icons.notifications,
    this.iconColor = Colors.green,
  });
}

class MockEmergencyDatabase {
  static final List<UserModel> sampleUsers = [];

  static final List<HospitalModel> sampleHospitals = [
    HospitalModel(
      id: 'HOSP-01',
      name: 'Apollo Speciality Hospital',
      address: '154/11, Opp IIMB, Bannerghatta Rd',
      latitude: 12.8954,
      longitude: 77.5988,
      distanceKm: 3.2,
      driveTimeMinutes: 7,
      specialization: 'Level 1 Trauma & Cardiac Emergency',
      availableBeds: 18,
      traumaCapacity: 6,
      hasCardiacUnit: true,
    ),
    HospitalModel(
      id: 'HOSP-02',
      name: 'Manipal Hospital (HAL Airport Rd)',
      address: '98, HAL Old Airport Rd, Kodihalli',
      latitude: 12.9592,
      longitude: 77.6496,
      distanceKm: 4.8,
      driveTimeMinutes: 11,
      specialization: 'Multi-Speciality & Neuro ICU',
      availableBeds: 12,
      traumaCapacity: 4,
      hasCardiacUnit: true,
    ),
    HospitalModel(
      id: 'HOSP-03',
      name: 'St. John’s Medical College Hospital',
      address: 'Sarjapur Main Road, Koramangala',
      latitude: 12.9322,
      longitude: 77.6202,
      distanceKm: 5.5,
      driveTimeMinutes: 14,
      specialization: 'Advanced Emergency & Burn Care',
      availableBeds: 24,
      traumaCapacity: 8,
      hasCardiacUnit: true,
    ),
    HospitalModel(
      id: 'HOSP-04',
      name: 'Fortis Hospital Richmond Road',
      address: '14, Richmond Road, Bangalore',
      latitude: 12.9645,
      longitude: 77.6012,
      distanceKm: 6.9,
      driveTimeMinutes: 18,
      specialization: 'Orthopedic & Cardiac Emergency',
      availableBeds: 8,
      traumaCapacity: 2,
      hasCardiacUnit: true,
    ),
  ];

  static final List<KycDocument> samplePendingKycs = [];

  static final List<TripRecord> samplePastTrips = [];

  static final List<ClearanceRecord> sampleClearances = [];
}
