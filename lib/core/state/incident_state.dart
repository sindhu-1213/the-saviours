import 'dart:async';
import 'package:flutter/material.dart';
import '../../mock_data/mock_emergency_database.dart';

class IncidentState extends ChangeNotifier {
  final List<IncidentModel> _incidents = [];
  IncidentModel? _activeIncident;
  bool _isDriverOnDuty = true;
  bool _isPoliceOnDuty = true;
  bool _isAiVerifying = false;
  int _aiVerificationProgress = 0;
  
  // Navigation & Realtime Simulation
  double _ambulanceLat = 12.9716;
  double _ambulanceLng = 77.5946;
  int _estimatedArrivalMinutes = 6;
  bool _isGreenCorridorActive = false;
  Timer? _simulationTimer;

  // In-App Notifications
  final List<AppNotification> _notifications = [];

  IncidentState() {
    _initSampleData();
  }

  List<IncidentModel> get incidents => _incidents;
  IncidentModel? get activeIncident => _activeIncident;
  bool get isDriverOnDuty => _isDriverOnDuty;
  bool get isPoliceOnDuty => _isPoliceOnDuty;
  bool get isAiVerifying => _isAiVerifying;
  int get aiVerificationProgress => _aiVerificationProgress;
  double get ambulanceLat => _ambulanceLat;
  double get ambulanceLng => _ambulanceLng;
  int get estimatedArrivalMinutes => _estimatedArrivalMinutes;
  bool get isGreenCorridorActive => _isGreenCorridorActive;
  List<AppNotification> get notifications => _notifications;

  void _initSampleData() {
    // Seed initial active incident for rich experience out of the box
    final initialIncident = IncidentModel(
      id: 'INC-2026-0819',
      reporterId: 'USR-CIV-001',
      reporterName: 'Aarav Sharma',
      reporterPhone: '+91 98765 43210',
      locationName: 'Indiranagar 100ft Road, Near KFC Junction',
      latitude: 12.9784,
      longitude: 77.6408,
      aiConfidenceScore: 92,
      status: IncidentStatus.driverDispatched,
      criticality: IncidentCriticality.critical,
      createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
      assignedDriverId: 'USR-DRV-108',
      assignedDriverName: 'Rajesh Kumar',
      assignedVehicle: 'KA-01-EA-108',
      clearedJunctions: ['Trinity Circle Signal'],
      auditLogs: [
        AuditEntry(
          stage: 'Phase 1: Reporting',
          action: 'Incident captured via Camera & Geotagged',
          timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          actorName: 'Aarav Sharma',
          actorRole: 'Civilian',
          details: 'Lat: 12.9784, Lng: 77.6408, Device: SM-G998B, Tamper Check: Pass',
        ),
        AuditEntry(
          stage: 'Phase 1: AI Verification',
          action: 'Google Gemini Vision AI Validated Scene',
          timestamp: DateTime.now().subtract(const Duration(minutes: 3, seconds: 40)),
          actorName: 'Gemini AI Engine',
          actorRole: 'System AI',
          details: 'Confidence: 92%, Road Accident Confirmed, Multi-vehicle collision flagged',
        ),
        AuditEntry(
          stage: 'Phase 2: Dispatch',
          action: 'Ambulance 108 Dispatched & Police Alerted',
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          actorName: 'Saviours Dispatch Engine',
          actorRole: 'System',
          details: 'Driver Rajesh Kumar (KA-01-EA-108) assigned. 3 Geo-fenced traffic posts notified.',
        ),
      ],
    );

    _incidents.add(initialIncident);
    _activeIncident = initialIncident;

    _notifications.addAll([
      AppNotification(
        id: 'NOTIF-01',
        title: 'Emergency Alert: Critical Collision',
        message: 'Ambulance KA-01-EA-108 dispatched to Indiranagar 100ft Rd.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        icon: Icons.emergency,
        iconColor: Colors.red,
      ),
      AppNotification(
        id: 'NOTIF-02',
        title: 'Green Corridor Request',
        message: 'MG Road - Trinity Junction traffic clearance requested.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        icon: Icons.traffic,
        iconColor: Colors.orange,
      ),
    ]);
  }

  void toggleDriverDuty() {
    _isDriverOnDuty = !_isDriverOnDuty;
    notifyListeners();
  }

  void togglePoliceDuty() {
    _isPoliceOnDuty = !_isPoliceOnDuty;
    notifyListeners();
  }

  // Phase 1: Civilian Reports Accident
  Future<IncidentModel> reportAccident({
    required String reporterId,
    required String reporterName,
    required String locationName,
    required double lat,
    required double lng,
  }) async {
    _isAiVerifying = true;
    _aiVerificationProgress = 10;
    notifyListeners();

    // Simulate AI pipeline progression
    for (int p = 25; p <= 100; p += 25) {
      await Future.delayed(const Duration(milliseconds: 400));
      _aiVerificationProgress = p;
      notifyListeners();
    }

    _isAiVerifying = false;

    final newIncident = IncidentModel(
      id: 'INC-2026-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      reporterId: reporterId,
      reporterName: reporterName,
      reporterPhone: '+91 98765 43210',
      locationName: locationName,
      latitude: lat,
      longitude: lng,
      aiConfidenceScore: 94,
      status: IncidentStatus.verified,
      criticality: IncidentCriticality.critical,
      createdAt: DateTime.now(),
      auditLogs: [
        AuditEntry(
          stage: 'Phase 1: Capture',
          action: 'Camera Photo & Device Metadata Logged',
          timestamp: DateTime.now(),
          actorName: reporterName,
          actorRole: 'Civilian',
          details: 'Live capture validated (No gallery upload permitted). Location: $locationName',
        ),
        AuditEntry(
          stage: 'Phase 1: AI Verification',
          action: 'Gemini AI Vision Confidence 94%',
          timestamp: DateTime.now(),
          actorName: 'Gemini AI Engine',
          actorRole: 'System AI',
          details: 'Accident verified. Tamper Score: 0/100. High severity impact detected.',
        ),
      ],
    );

    _incidents.insert(0, newIncident);
    _activeIncident = newIncident;

    // Trigger notification
    _notifications.insert(
      0,
      AppNotification(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Accident Report Verified',
        message: 'Incident #${newIncident.id} verified. Ambulance & Police dispatched.',
        timestamp: DateTime.now(),
        icon: Icons.check_circle,
        iconColor: Colors.green,
      ),
    );

    notifyListeners();
    return newIncident;
  }

  // Phase 2: Driver Acceptance & Criticality
  void acceptIncidentAssignment(String incidentId, String driverId, String driverName, String vehicle) {
    if (_activeIncident != null && _activeIncident!.id == incidentId) {
      _activeIncident!.assignedDriverId = driverId;
      _activeIncident!.assignedDriverName = driverName;
      _activeIncident!.assignedVehicle = vehicle;
      _activeIncident!.status = IncidentStatus.driverDispatched;
      
      _activeIncident!.auditLogs.add(
        AuditEntry(
          stage: 'Phase 2: Assignment Accepted',
          action: 'Ambulance Driver Accepted Dispatch',
          timestamp: DateTime.now(),
          actorName: driverName,
          actorRole: 'Ambulance Driver',
          details: 'Vehicle $vehicle en route to incident location.',
        ),
      );

      _startAmbulanceSimulation();
      notifyListeners();
    }
  }

  void setIncidentCriticality(IncidentCriticality criticality) {
    if (_activeIncident != null) {
      _activeIncident!.criticality = criticality;
      _activeIncident!.auditLogs.add(
        AuditEntry(
          stage: 'Phase 2: Severity Triage',
          action: 'Criticality Set to ${criticality.name.toUpperCase()}',
          timestamp: DateTime.now(),
          actorName: _activeIncident!.assignedDriverName ?? 'Driver',
          actorRole: 'Ambulance Driver',
          details: 'Traffic priority escalated to highest tier.',
        ),
      );
      notifyListeners();
    }
  }

  // Phase 2 / Green Corridor: Traffic Police Clearance
  void clearTrafficJunction(String junctionName, String officerName, String officerId) {
    if (_activeIncident != null) {
      if (!_activeIncident!.clearedJunctions.contains(junctionName)) {
        _activeIncident!.clearedJunctions.add(junctionName);
      }
      _isGreenCorridorActive = true;

      _activeIncident!.auditLogs.add(
        AuditEntry(
          stage: 'Phase 2: Green Corridor Clearance',
          action: 'Junction Cleared: $junctionName',
          timestamp: DateTime.now(),
          actorName: officerName,
          actorRole: 'Traffic Police',
          details: 'Traffic redirected. Corridor status switched to ACTIVE GREEN.',
        ),
      );

      MockEmergencyDatabase.sampleClearances.insert(
        0,
        ClearanceRecord(
          id: 'CLR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          incidentId: _activeIncident!.id,
          officerId: officerId,
          officerName: officerName,
          junctionName: junctionName,
          clearedAt: DateTime.now(),
          congestionLevel: 'High Congestion Cleared',
          secondsToClear: 38,
        ),
      );

      _notifications.insert(
        0,
        AppNotification(
          id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Green Corridor Cleared!',
          message: '$junctionName cleared by $officerName. Ambulance priority confirmed.',
          timestamp: DateTime.now(),
          icon: Icons.traffic,
          iconColor: Colors.green,
        ),
      );

      notifyListeners();
    }
  }

  // Phase 3: Patient Onboard & Hospital Selection
  void confirmPatientOnboard() {
    if (_activeIncident != null) {
      _activeIncident!.status = IncidentStatus.patientOnboard;
      _activeIncident!.auditLogs.add(
        AuditEntry(
          stage: 'Phase 3: Patient Onboard',
          action: 'Patient Secured in Ambulance',
          timestamp: DateTime.now(),
          actorName: _activeIncident!.assignedDriverName ?? 'Driver',
          actorRole: 'Ambulance Driver',
          details: 'Vitals stabilized. Hospital suggestion engine activated.',
        ),
      );
      notifyListeners();
    }
  }

  void selectHospital(HospitalModel hospital) {
    if (_activeIncident != null) {
      _activeIncident!.assignedHospitalId = hospital.id;
      _activeIncident!.assignedHospitalName = hospital.name;
      _activeIncident!.status = IncidentStatus.hospitalTransport;
      
      _activeIncident!.auditLogs.add(
        AuditEntry(
          stage: 'Phase 3: Hospital Selected',
          action: 'Transport to ${hospital.name}',
          timestamp: DateTime.now(),
          actorName: _activeIncident!.assignedDriverName ?? 'Driver',
          actorRole: 'Ambulance Driver',
          details: 'Selected based on Distance (${hospital.distanceKm} km), Trauma Beds (${hospital.availableBeds}), and Specialization.',
        ),
      );

      _notifications.insert(
        0,
        AppNotification(
          id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Hospital Transport En Route',
          message: 'Ambulance routing to ${hospital.name} with Green Corridor priority.',
          timestamp: DateTime.now(),
          icon: Icons.local_hospital,
          iconColor: Colors.blue,
        ),
      );

      notifyListeners();
    }
  }

  // Phase 3 & 4: Drop-off & Incident Completion
  void confirmDropoff() {
    if (_activeIncident != null) {
      _activeIncident!.status = IncidentStatus.completed;
      final completedTime = DateTime.now();

      _activeIncident!.auditLogs.add(
        AuditEntry(
          stage: 'Phase 4: Drop-off & Handover',
          action: 'Patient Successfully Handed Over to Emergency Staff',
          timestamp: completedTime,
          actorName: _activeIncident!.assignedDriverName ?? 'Driver',
          actorRole: 'Ambulance Driver',
          details: 'Handover complete at ${_activeIncident!.assignedHospitalName ?? 'Hospital Emergency'}. Trip closed.',
        ),
      );

      // Save to past trips
      MockEmergencyDatabase.samplePastTrips.insert(
        0,
        TripRecord(
          id: 'TRIP-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          incidentId: _activeIncident!.id,
          driverId: _activeIncident!.assignedDriverId ?? 'USR-DRV-108',
          location: _activeIncident!.locationName,
          hospitalName: _activeIncident!.assignedHospitalName ?? 'Emergency Care Center',
          startTime: _activeIncident!.createdAt,
          endTime: completedTime,
          distanceKm: 4.6,
          totalMinutes: completedTime.difference(_activeIncident!.createdAt).inMinutes.clamp(8, 45),
          junctionsCleared: _activeIncident!.clearedJunctions.length.clamp(2, 6),
          status: 'Completed (Saved)',
        ),
      );

      _simulationTimer?.cancel();
      notifyListeners();
    }
  }

  void _startAmbulanceSimulation() {
    _simulationTimer?.cancel();
    _estimatedArrivalMinutes = 6;
    _simulationTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_estimatedArrivalMinutes > 1) {
        _estimatedArrivalMinutes--;
        _ambulanceLat += 0.0008;
        _ambulanceLng += 0.0006;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
