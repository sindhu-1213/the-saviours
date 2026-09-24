import 'dart:async';
import 'package:flutter/material.dart';
import '../../mock_data/mock_emergency_database.dart';
import '../services/supabase_service.dart';

class IncidentState extends ChangeNotifier {
  final List<IncidentModel> _incidents = [];
  final List<ClearanceRecord> _clearances = [];
  final List<TripRecord> _trips = [];
  final List<HospitalModel> _hospitals = [];
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
    _initData();
  }

  List<IncidentModel> get incidents => _incidents;
  List<ClearanceRecord> get clearances => _clearances;
  List<TripRecord> get trips => _trips;
  List<HospitalModel> get hospitals => _hospitals;
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

  Future<void> _initData() async {
    final supabase = SupabaseService();
    if (supabase.isInitialized) {
      final remoteIncidents = await supabase.fetchIncidents();
      final remoteClearances = await supabase.fetchClearances();
      final remoteTrips = await supabase.fetchTrips();
      final remoteHospitals = await supabase.fetchHospitals();

      if (remoteIncidents.isNotEmpty) {
        _incidents.clear();
        _incidents.addAll(remoteIncidents);
        _activeIncident = _incidents.firstWhere(
          (inc) => inc.status != IncidentStatus.completed && inc.status != IncidentStatus.rejected,
          orElse: () => _incidents.first,
        );
      }
      if (remoteClearances.isNotEmpty) {
        _clearances.clear();
        _clearances.addAll(remoteClearances);
      }
      if (remoteTrips.isNotEmpty) {
        _trips.clear();
        _trips.addAll(remoteTrips);
      }
      if (remoteHospitals.isNotEmpty) {
        _hospitals.clear();
        _hospitals.addAll(remoteHospitals);
      }
      notifyListeners();
    }
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

    // Save to Supabase
    await SupabaseService().insertIncident(newIncident);

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
      SupabaseService().updateIncident(_activeIncident!);
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
      SupabaseService().updateIncident(_activeIncident!);
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

      final clearance = ClearanceRecord(
        id: 'CLR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        incidentId: _activeIncident!.id,
        officerId: officerId,
        officerName: officerName,
        junctionName: junctionName,
        clearedAt: DateTime.now(),
        congestionLevel: 'High Congestion Cleared',
        secondsToClear: 38,
      );

      _clearances.insert(0, clearance);
      MockEmergencyDatabase.sampleClearances.insert(0, clearance);

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

      SupabaseService().insertClearance(clearance);
      SupabaseService().updateIncident(_activeIncident!);

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
      SupabaseService().updateIncident(_activeIncident!);
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

      SupabaseService().updateIncident(_activeIncident!);
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

      final trip = TripRecord(
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
      );

      _trips.insert(0, trip);
      MockEmergencyDatabase.samplePastTrips.insert(0, trip);

      SupabaseService().insertTrip(trip);
      SupabaseService().updateIncident(_activeIncident!);

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
