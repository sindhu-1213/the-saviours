import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/api_config.dart';
import '../../mock_data/mock_emergency_database.dart';

class AuthResult {
  final UserModel? user;
  final String? errorMessage;
  final bool isAlreadyRegistered;

  const AuthResult({
    this.user,
    this.errorMessage,
    this.isAlreadyRegistered = false,
  });

  bool get isSuccess => user != null;
}

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  SupabaseClient? get client {
    if (!_isInitialized) return null;
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  Future<bool> initialize() async {
    if (!ApiConfig.hasValidSupabaseKey) {
      debugPrint('[SupabaseService] No valid Supabase credentials configured, using local fallback.');
      return false;
    }

    try {
      await Supabase.initialize(
        url: ApiConfig.supabaseUrl,
        anonKey: ApiConfig.supabaseAnonKey,
      );
      _isInitialized = true;
      debugPrint('[SupabaseService] Connected successfully to ${ApiConfig.supabaseUrl}');
      
      // Auto seed initial data if needed
      await _autoSeedIfEmpty();
      return true;
    } catch (e) {
      debugPrint('[SupabaseService] Connection failed: $e. Falling back to local offline mode.');
      _isInitialized = false;
      return false;
    }
  }

  Future<void> _autoSeedIfEmpty() async {
    if (!_isInitialized || client == null) return;
    try {
      final res = await client!.from('hospitals').select('id').limit(1);
      if ((res as List).isEmpty) {
        debugPrint('[SupabaseService] Seeding default emergency hospitals...');
        for (final h in MockEmergencyDatabase.sampleHospitals) {
          await client!.from('hospitals').insert({
            'id': h.id,
            'name': h.name,
            'address': h.address,
            'latitude': h.latitude,
            'longitude': h.longitude,
            'distance_km': h.distanceKm,
            'drive_time_minutes': h.driveTimeMinutes,
            'specialization': h.specialization,
            'available_beds': h.availableBeds,
            'trauma_capacity': h.traumaCapacity,
            'has_cardiac_unit': h.hasCardiacUnit,
          });
        }
      }
    } catch (e) {
      debugPrint('[SupabaseService] Auto-seed check: $e');
    }
  }

  // ==========================================
  // --- Authentication ---
  // ==========================================

  Future<AuthResult> signIn({required String email, required String password}) async {
    if (!_isInitialized || client == null) {
      return const AuthResult(errorMessage: 'Supabase is not connected. Please check internet.');
    }
    try {
      final response = await client!.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      if (user != null) {
        debugPrint('[SupabaseService] Auth Sign In successful for ${user.email} (ID: ${user.id})');
        
        // Fetch or create corresponding profile row
        final profile = await fetchProfileById(user.id);
        if (profile != null) return AuthResult(user: profile);

        // Create new profile record if none exists yet
        final newProfile = UserModel(
          id: user.id,
          name: user.userMetadata?['name'] ?? email.split('@').first,
          email: user.email ?? email,
          phone: user.userMetadata?['phone'] ?? user.phone ?? '+91 98765 43210',
          role: _parseRole(user.userMetadata?['role']),
          verificationStatus: VerificationStatus.verified,
        );
        await upsertProfile(newProfile);
        return AuthResult(user: newProfile);
      }
      return const AuthResult(errorMessage: 'Sign in failed. No user returned.');
    } on AuthException catch (e) {
      dev.log('[SupabaseService] Sign In AuthException: ${e.message}');
      return AuthResult(errorMessage: e.message);
    } catch (e) {
      dev.log('[SupabaseService] Sign In Exception: $e');
      return AuthResult(errorMessage: e.toString());
    }
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    if (!_isInitialized || client == null) {
      return const AuthResult(errorMessage: 'Supabase is not connected. Please check internet.');
    }
    try {
      final response = await client!.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'name': name,
          'phone': phone,
          'role': role.name,
        },
      );

      final user = response.user;
      if (user != null) {
        // In Supabase, if email confirmations are enabled and the user is already registered,
        // identities list is returned empty to prevent user enumeration.
        if (user.identities != null && user.identities!.isEmpty) {
          return AuthResult(
            errorMessage: 'An account with $email is already registered. Please go back to Sign In.',
            isAlreadyRegistered: true,
          );
        }

        final profile = UserModel(
          id: user.id,
          name: name,
          email: email.trim(),
          phone: phone,
          role: role,
          verificationStatus: role == UserRole.civilian ? VerificationStatus.verified : VerificationStatus.pending,
        );
        await upsertProfile(profile);
        return AuthResult(user: profile);
      }
      return const AuthResult(errorMessage: 'Registration failed. No user was created.');
    } on AuthException catch (e) {
      dev.log('[SupabaseService] Sign Up AuthException: ${e.message}');
      final msg = e.message;
      final isAlready = msg.toLowerCase().contains('already') || msg.toLowerCase().contains('registered') || msg.toLowerCase().contains('exists');
      return AuthResult(
        errorMessage: isAlready 
            ? 'Account already exists for $email. Please use Sign In with your password, or use a new email address.'
            : msg,
        isAlreadyRegistered: isAlready,
      );
    } catch (e) {
      dev.log('[SupabaseService] Sign Up Exception: $e');
      return AuthResult(errorMessage: 'Sign up error: $e');
    }
  }

  Future<void> signOut() async {
    if (!_isInitialized || client == null) return;
    try {
      await client!.auth.signOut();
      debugPrint('[SupabaseService] User signed out successfully.');
    } catch (e) {
      dev.log('[SupabaseService] Sign Out Exception: $e');
    }
  }

  // ==========================================
  // --- Profiles & Users ---
  // ==========================================

  Future<UserModel?> fetchProfileById(String id) async {
    if (!_isInitialized || client == null) return null;
    try {
      final data = await client!.from('profiles').select().eq('id', id).maybeSingle();
      if (data != null) {
        return UserModel(
          id: data['id'] ?? id,
          name: data['name'] ?? 'User',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          role: _parseRole(data['role']),
          verificationStatus: _parseVerificationStatus(data['verification_status']),
          rejectionReason: data['rejection_reason'],
          badgeNumber: data['badge_number'],
          vehicleNumber: data['vehicle_number'],
          jurisdictionZone: data['jurisdiction_zone'],
          aadhaarMasked: data['aadhaar_masked'] ?? 'XXXX-XXXX-8921',
          avatarUrl: data['avatar_url'] ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
        );
      }
    } catch (e) {
      dev.log('[SupabaseService] Error fetching profile by ID: $e');
    }
    return null;
  }

  Future<List<UserModel>> fetchProfiles() async {
    if (!_isInitialized || client == null) return [];
    try {
      final data = await client!.from('profiles').select();
      if ((data as List).isEmpty) {
        return [];
      }
      return data.map((row) {
        return UserModel(
          id: row['id'] ?? 'USR-000',
          name: row['name'] ?? 'Unknown User',
          email: row['email'] ?? '',
          phone: row['phone'] ?? '',
          role: _parseRole(row['role']),
          verificationStatus: _parseVerificationStatus(row['verification_status']),
          rejectionReason: row['rejection_reason'],
          badgeNumber: row['badge_number'],
          vehicleNumber: row['vehicle_number'],
          jurisdictionZone: row['jurisdiction_zone'],
          aadhaarMasked: row['aadhaar_masked'] ?? 'XXXX-XXXX-8921',
          avatarUrl: row['avatar_url'] ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
        );
      }).toList();
    } catch (e) {
      dev.log('Error fetching profiles from Supabase: $e');
      return [];
    }
  }

  Future<bool> upsertProfile(UserModel user) async {
    if (!_isInitialized || client == null) return true;
    try {
      await client!.from('profiles').upsert({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
        'role': user.role.name,
        'verification_status': user.verificationStatus.name,
        'rejection_reason': user.rejectionReason,
        'badge_number': user.badgeNumber,
        'vehicle_number': user.vehicleNumber,
        'jurisdiction_zone': user.jurisdictionZone,
        'aadhaar_masked': user.aadhaarMasked,
        'avatar_url': user.avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });
      debugPrint('[SupabaseService] Profile upserted in Supabase for ${user.email}');
      return true;
    } catch (e) {
      dev.log('Error upserting profile in Supabase: $e');
      return false;
    }
  }

  // ==========================================
  // --- Hospitals ---
  // ==========================================

  Future<List<HospitalModel>> fetchHospitals() async {
    if (!_isInitialized || client == null) return MockEmergencyDatabase.sampleHospitals;
    try {
      final data = await client!.from('hospitals').select();
      if ((data as List).isEmpty) return MockEmergencyDatabase.sampleHospitals;
      return data.map((row) {
        return HospitalModel(
          id: row['id'] ?? 'HOSP-00',
          name: row['name'] ?? '',
          address: row['address'] ?? '',
          latitude: (row['latitude'] as num?)?.toDouble() ?? 12.9716,
          longitude: (row['longitude'] as num?)?.toDouble() ?? 77.5946,
          distanceKm: (row['distance_km'] as num?)?.toDouble() ?? 3.0,
          driveTimeMinutes: (row['drive_time_minutes'] as num?)?.toInt() ?? 10,
          specialization: row['specialization'] ?? 'General Emergency',
          availableBeds: (row['available_beds'] as num?)?.toInt() ?? 10,
          traumaCapacity: (row['trauma_capacity'] as num?)?.toInt() ?? 4,
          hasCardiacUnit: row['has_cardiac_unit'] ?? true,
        );
      }).toList();
    } catch (e) {
      dev.log('Error fetching hospitals from Supabase: $e');
      return MockEmergencyDatabase.sampleHospitals;
    }
  }

  // ==========================================
  // --- Incidents ---
  // ==========================================

  Future<List<IncidentModel>> fetchIncidents() async {
    if (!_isInitialized || client == null) return [];
    try {
      final data = await client!.from('incidents').select().order('created_at', ascending: false);
      return (data as List).map((row) {
        List<String> clearedJunctions = [];
        if (row['cleared_junctions'] is List) {
          clearedJunctions = (row['cleared_junctions'] as List).map((j) => j.toString()).toList();
        }

        List<AuditEntry> auditLogs = [];
        if (row['audit_logs'] is List) {
          auditLogs = (row['audit_logs'] as List).map((a) {
            return AuditEntry(
              stage: a['stage'] ?? '',
              action: a['action'] ?? '',
              timestamp: DateTime.tryParse(a['timestamp'] ?? '') ?? DateTime.now(),
              actorName: a['actorName'] ?? '',
              actorRole: a['actorRole'] ?? '',
              details: a['details'] ?? '',
            );
          }).toList();
        }

        return IncidentModel(
          id: row['id'] ?? 'INC-000',
          reporterId: row['reporter_id'] ?? '',
          reporterName: row['reporter_name'] ?? 'Civilian Reporter',
          reporterPhone: row['reporter_phone'] ?? '',
          locationName: row['location_name'] ?? 'Accident Site',
          latitude: (row['latitude'] as num?)?.toDouble() ?? 12.9716,
          longitude: (row['longitude'] as num?)?.toDouble() ?? 77.5946,
          aiConfidenceScore: (row['ai_confidence_score'] as num?)?.toInt() ?? 90,
          status: _parseIncidentStatus(row['status']),
          criticality: _parseIncidentCriticality(row['criticality']),
          createdAt: DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
          assignedDriverId: row['assigned_driver_id'],
          assignedDriverName: row['assigned_driver_name'],
          assignedVehicle: row['assigned_vehicle'],
          assignedHospitalId: row['assigned_hospital_id'],
          assignedHospitalName: row['assigned_hospital_name'],
          clearedJunctions: clearedJunctions,
          auditLogs: auditLogs,
          rejectionReason: row['rejection_reason'],
        );
      }).toList();
    } catch (e) {
      dev.log('Error fetching incidents from Supabase: $e');
      return [];
    }
  }

  Future<bool> insertIncident(IncidentModel incident) async {
    if (!_isInitialized || client == null) return true;
    try {
      await client!.from('incidents').insert({
        'id': incident.id,
        'reporter_id': incident.reporterId,
        'reporter_name': incident.reporterName,
        'reporter_phone': incident.reporterPhone,
        'location_name': incident.locationName,
        'latitude': incident.latitude,
        'longitude': incident.longitude,
        'ai_confidence_score': incident.aiConfidenceScore,
        'status': incident.status.name,
        'criticality': incident.criticality.name,
        'created_at': incident.createdAt.toIso8601String(),
        'assigned_driver_id': incident.assignedDriverId,
        'assigned_driver_name': incident.assignedDriverName,
        'assigned_vehicle': incident.assignedVehicle,
        'assigned_hospital_id': incident.assignedHospitalId,
        'assigned_hospital_name': incident.assignedHospitalName,
        'cleared_junctions': incident.clearedJunctions,
        'audit_logs': incident.auditLogs.map((a) => {
          'stage': a.stage,
          'action': a.action,
          'timestamp': a.timestamp.toIso8601String(),
          'actorName': a.actorName,
          'actorRole': a.actorRole,
          'details': a.details,
        }).toList(),
      });
      debugPrint('[SupabaseService] Incident ${incident.id} inserted successfully into Supabase!');
      return true;
    } catch (e) {
      dev.log('Error inserting incident in Supabase: $e');
      debugPrint('Error inserting incident in Supabase: $e');
      return false;
    }
  }

  Future<bool> updateIncident(IncidentModel incident) async {
    if (!_isInitialized || client == null) return true;
    try {
      await client!.from('incidents').update({
        'status': incident.status.name,
        'criticality': incident.criticality.name,
        'assigned_driver_id': incident.assignedDriverId,
        'assigned_driver_name': incident.assignedDriverName,
        'assigned_vehicle': incident.assignedVehicle,
        'assigned_hospital_id': incident.assignedHospitalId,
        'assigned_hospital_name': incident.assignedHospitalName,
        'cleared_junctions': incident.clearedJunctions,
        'audit_logs': incident.auditLogs.map((a) => {
          'stage': a.stage,
          'action': a.action,
          'timestamp': a.timestamp.toIso8601String(),
          'actorName': a.actorName,
          'actorRole': a.actorRole,
          'details': a.details,
        }).toList(),
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', incident.id);
      debugPrint('[SupabaseService] Incident ${incident.id} updated in Supabase');
      return true;
    } catch (e) {
      dev.log('Error updating incident in Supabase: $e');
      return false;
    }
  }

  // ==========================================
  // --- KYC Documents ---
  // ==========================================

  Future<List<KycDocument>> fetchKycs() async {
    if (!_isInitialized || client == null) return [];
    try {
      final data = await client!.from('kyc_documents').select().order('uploaded_at', ascending: false);
      if ((data as List).isEmpty) return [];
      return data.map((row) {
        return KycDocument(
          id: row['id'] ?? 'KYC-000',
          userId: row['user_id'] ?? '',
          userName: row['user_name'] ?? '',
          role: _parseRole(row['role']),
          docType: row['doc_type'] ?? '',
          docNumber: row['doc_number'] ?? '',
          uploadedAt: DateTime.tryParse(row['uploaded_at'] ?? '') ?? DateTime.now(),
          status: _parseVerificationStatus(row['status']),
          aiAuthenticityScore: (row['ai_authenticity_score'] as num?)?.toInt() ?? 94,
          tamperFlag: row['tamper_flag'] ?? false,
          ocrExtractedName: row['ocr_extracted_name'] ?? '',
          ocrExtractedNumber: row['ocr_extracted_number'] ?? '',
          rejectionReason: row['rejection_reason'],
        );
      }).toList();
    } catch (e) {
      dev.log('Error fetching KYC documents: $e');
      return [];
    }
  }

  Future<bool> insertKyc(KycDocument kyc) async {
    if (!_isInitialized || client == null) return true;
    try {
      await client!.from('kyc_documents').insert({
        'id': kyc.id,
        'user_id': kyc.userId,
        'user_name': kyc.userName,
        'role': kyc.role.name,
        'doc_type': kyc.docType,
        'doc_number': kyc.docNumber,
        'uploaded_at': kyc.uploadedAt.toIso8601String(),
        'status': kyc.status.name,
        'ai_authenticity_score': kyc.aiAuthenticityScore,
        'tamper_flag': kyc.tamperFlag,
        'ocr_extracted_name': kyc.ocrExtractedName,
        'ocr_extracted_number': kyc.ocrExtractedNumber,
      });
      debugPrint('[SupabaseService] KYC ${kyc.id} uploaded to Supabase');
      return true;
    } catch (e) {
      dev.log('Error inserting KYC: $e');
      return false;
    }
  }

  Future<bool> updateKycStatus(String kycId, String userId, VerificationStatus status, {String? reason}) async {
    if (!_isInitialized || client == null) return true;
    try {
      await client!.from('kyc_documents').update({
        'status': status.name,
        'rejection_reason': reason,
      }).eq('id', kycId);

      await client!.from('profiles').update({
        'verification_status': status.name,
        'rejection_reason': reason,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      debugPrint('[SupabaseService] KYC $kycId and User $userId status updated to ${status.name}');
      return true;
    } catch (e) {
      dev.log('Error updating KYC status: $e');
      return false;
    }
  }

  // ==========================================
  // --- Clearances & Trips ---
  // ==========================================

  Future<List<ClearanceRecord>> fetchClearances() async {
    if (!_isInitialized || client == null) return [];
    try {
      final data = await client!.from('clearance_records').select().order('cleared_at', ascending: false);
      if ((data as List).isEmpty) return [];
      return data.map((row) {
        return ClearanceRecord(
          id: row['id'] ?? 'CLR-000',
          incidentId: row['incident_id'] ?? '',
          officerId: row['officer_id'] ?? '',
          officerName: row['officer_name'] ?? 'Police Officer',
          junctionName: row['junction_name'] ?? 'Junction',
          clearedAt: DateTime.tryParse(row['cleared_at'] ?? '') ?? DateTime.now(),
          congestionLevel: row['congestion_level'] ?? 'High Congestion Cleared',
          secondsToClear: (row['seconds_to_clear'] as num?)?.toInt() ?? 30,
        );
      }).toList();
    } catch (e) {
      dev.log('Error fetching clearance records from Supabase: $e');
      return [];
    }
  }

  Future<bool> insertClearance(ClearanceRecord clearance) async {
    if (!_isInitialized || client == null) return true;
    try {
      await client!.from('clearance_records').insert({
        'id': clearance.id,
        'incident_id': clearance.incidentId,
        'officer_id': clearance.officerId,
        'officer_name': clearance.officerName,
        'junction_name': clearance.junctionName,
        'cleared_at': clearance.clearedAt.toIso8601String(),
        'congestion_level': clearance.congestionLevel,
        'seconds_to_clear': clearance.secondsToClear,
      });
      return true;
    } catch (e) {
      dev.log('Error inserting clearance in Supabase: $e');
      return false;
    }
  }

  Future<List<TripRecord>> fetchTrips() async {
    if (!_isInitialized || client == null) return [];
    try {
      final data = await client!.from('trip_records').select().order('start_time', ascending: false);
      if ((data as List).isEmpty) return [];
      return data.map((row) {
        return TripRecord(
          id: row['id'] ?? 'TRIP-000',
          incidentId: row['incident_id'] ?? '',
          driverId: row['driver_id'] ?? '',
          location: row['location'] ?? 'Accident Location',
          hospitalName: row['hospital_name'] ?? 'Hospital',
          startTime: DateTime.tryParse(row['start_time'] ?? '') ?? DateTime.now(),
          endTime: DateTime.tryParse(row['end_time'] ?? '') ?? DateTime.now(),
          distanceKm: (row['distance_km'] as num?)?.toDouble() ?? 4.0,
          totalMinutes: (row['total_minutes'] as num?)?.toInt() ?? 12,
          junctionsCleared: (row['junctions_cleared'] as num?)?.toInt() ?? 3,
          status: row['status'] ?? 'Completed',
        );
      }).toList();
    } catch (e) {
      dev.log('Error fetching trip records from Supabase: $e');
      return [];
    }
  }

  Future<bool> insertTrip(TripRecord trip) async {
    if (!_isInitialized || client == null) return true;
    try {
      await client!.from('trip_records').insert({
        'id': trip.id,
        'incident_id': trip.incidentId,
        'driver_id': trip.driverId,
        'location': trip.location,
        'hospital_name': trip.hospitalName,
        'start_time': trip.startTime.toIso8601String(),
        'end_time': trip.endTime.toIso8601String(),
        'distance_km': trip.distanceKm,
        'total_minutes': trip.totalMinutes,
        'junctions_cleared': trip.junctionsCleared,
        'status': trip.status,
      });
      return true;
    } catch (e) {
      dev.log('Error inserting trip in Supabase: $e');
      return false;
    }
  }

  // ==========================================
  // --- Helper Parsers ---
  // ==========================================

  UserRole _parseRole(String? roleStr) {
    switch (roleStr?.toLowerCase()) {
      case 'driver':
        return UserRole.driver;
      case 'police':
        return UserRole.police;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.civilian;
    }
  }

  VerificationStatus _parseVerificationStatus(String? statusStr) {
    switch (statusStr?.toLowerCase()) {
      case 'pending':
        return VerificationStatus.pending;
      case 'rejected':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.verified;
    }
  }

  IncidentStatus _parseIncidentStatus(String? statusStr) {
    switch (statusStr?.toLowerCase()) {
      case 'verifying':
        return IncidentStatus.verifying;
      case 'rejected':
        return IncidentStatus.rejected;
      case 'driverdispatched':
        return IncidentStatus.driverDispatched;
      case 'patientonboard':
        return IncidentStatus.patientOnboard;
      case 'hospitaltransport':
        return IncidentStatus.hospitalTransport;
      case 'completed':
        return IncidentStatus.completed;
      default:
        return IncidentStatus.verified;
    }
  }

  IncidentCriticality _parseIncidentCriticality(String? critStr) {
    switch (critStr?.toLowerCase()) {
      case 'low':
        return IncidentCriticality.low;
      case 'medium':
        return IncidentCriticality.medium;
      case 'high':
        return IncidentCriticality.high;
      default:
        return IncidentCriticality.critical;
    }
  }
}
