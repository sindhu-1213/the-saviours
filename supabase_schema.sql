-- ==============================================================================
-- SAVIOURS EMERGENCY PLATFORM - SUPABASE DATABASE SCHEMA
-- Run this in your Supabase SQL Editor (Dashboard -> SQL Editor -> New Query)
-- ==============================================================================

-- 1. Profiles Table (Linked with Supabase Auth users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'civilian', -- 'civilian', 'driver', 'police', 'admin'
    verification_status TEXT NOT NULL DEFAULT 'verified', -- 'verified', 'pending', 'rejected'
    rejection_reason TEXT,
    badge_number TEXT,
    vehicle_number TEXT,
    jurisdiction_zone TEXT,
    aadhaar_masked TEXT DEFAULT 'XXXX-XXXX-8921',
    avatar_url TEXT DEFAULT 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Hospitals Table
CREATE TABLE IF NOT EXISTS public.hospitals (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    distance_km DOUBLE PRECISION DEFAULT 3.0,
    drive_time_minutes INT DEFAULT 10,
    specialization TEXT DEFAULT 'Level 1 Trauma & Emergency',
    available_beds INT DEFAULT 12,
    trauma_capacity INT DEFAULT 4,
    has_cardiac_unit BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Incidents Table
CREATE TABLE IF NOT EXISTS public.incidents (
    id TEXT PRIMARY KEY,
    reporter_id TEXT NOT NULL,
    reporter_name TEXT NOT NULL,
    reporter_phone TEXT NOT NULL,
    location_name TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    ai_confidence_score INT DEFAULT 90,
    status TEXT NOT NULL DEFAULT 'verified', -- 'verifying', 'verified', 'rejected', 'driverDispatched', 'patientOnboard', 'hospitalTransport', 'completed'
    criticality TEXT NOT NULL DEFAULT 'critical', -- 'low', 'medium', 'high', 'critical'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    assigned_driver_id TEXT,
    assigned_driver_name TEXT,
    assigned_vehicle TEXT,
    assigned_hospital_id TEXT,
    assigned_hospital_name TEXT,
    cleared_junctions JSONB DEFAULT '[]'::jsonb,
    audit_logs JSONB DEFAULT '[]'::jsonb,
    rejection_reason TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. KYC Documents Table
CREATE TABLE IF NOT EXISTS public.kyc_documents (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    user_name TEXT NOT NULL,
    role TEXT NOT NULL,
    doc_type TEXT NOT NULL,
    doc_number TEXT NOT NULL,
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'verified', 'rejected'
    ai_authenticity_score INT DEFAULT 95,
    tamper_flag BOOLEAN DEFAULT FALSE,
    ocr_extracted_name TEXT,
    ocr_extracted_number TEXT,
    rejection_reason TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Traffic Clearances Table
CREATE TABLE IF NOT EXISTS public.clearance_records (
    id TEXT PRIMARY KEY,
    incident_id TEXT NOT NULL,
    officer_id TEXT NOT NULL,
    officer_name TEXT NOT NULL,
    junction_name TEXT NOT NULL,
    cleared_at TIMESTAMPTZ DEFAULT NOW(),
    congestion_level TEXT DEFAULT 'High Congestion Cleared',
    seconds_to_clear INT DEFAULT 35
);

-- 6. Trip History Table
CREATE TABLE IF NOT EXISTS public.trip_records (
    id TEXT PRIMARY KEY,
    incident_id TEXT NOT NULL,
    driver_id TEXT NOT NULL,
    location TEXT NOT NULL,
    hospital_name TEXT NOT NULL,
    start_time TIMESTAMPTZ DEFAULT NOW(),
    end_time TIMESTAMPTZ DEFAULT NOW(),
    distance_km DOUBLE PRECISION DEFAULT 4.5,
    total_minutes INT DEFAULT 15,
    junctions_cleared INT DEFAULT 3,
    status TEXT DEFAULT 'Completed (Saved)'
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.hospitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kyc_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clearance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trip_records ENABLE ROW LEVEL SECURITY;

-- Permissive policies for full interactive demo access (anon + authenticated)
DROP POLICY IF EXISTS "Allow public read access on profiles" ON public.profiles;
CREATE POLICY "Allow public read access on profiles" ON public.profiles FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow public insert/update on profiles" ON public.profiles;
CREATE POLICY "Allow public insert/update on profiles" ON public.profiles FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public read access on hospitals" ON public.hospitals;
CREATE POLICY "Allow public read access on hospitals" ON public.hospitals FOR SELECT USING (true);

DROP POLICY IF EXISTS "Allow public write access on hospitals" ON public.hospitals;
CREATE POLICY "Allow public write access on hospitals" ON public.hospitals FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all access on incidents" ON public.incidents;
CREATE POLICY "Allow all access on incidents" ON public.incidents FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all access on kyc_documents" ON public.kyc_documents;
CREATE POLICY "Allow all access on kyc_documents" ON public.kyc_documents FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all access on clearance_records" ON public.clearance_records;
CREATE POLICY "Allow all access on clearance_records" ON public.clearance_records FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Allow all access on trip_records" ON public.trip_records;
CREATE POLICY "Allow all access on trip_records" ON public.trip_records FOR ALL USING (true) WITH CHECK (true);

-- Enable Realtime on Incidents table
ALTER PUBLICATION supabase_realtime ADD TABLE public.incidents;
ALTER PUBLICATION supabase_realtime ADD TABLE public.clearance_records;
ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;

-- Seed Default Hospitals
INSERT INTO public.hospitals (id, name, address, latitude, longitude, distance_km, drive_time_minutes, specialization, available_beds, trauma_capacity, has_cardiac_unit)
VALUES
  ('HOSP-01', 'Apollo Speciality Hospital', '154/11, Opp IIMB, Bannerghatta Rd', 12.8954, 77.5988, 3.2, 7, 'Level 1 Trauma & Cardiac Emergency', 18, 6, true),
  ('HOSP-02', 'Manipal Hospital (HAL Airport Rd)', '98, HAL Old Airport Rd, Kodihalli', 12.9592, 77.6496, 4.8, 11, 'Multi-Speciality & Neuro ICU', 12, 4, true),
  ('HOSP-03', 'St. John’s Medical College Hospital', 'Sarjapur Main Road, Koramangala', 12.9322, 77.6202, 5.5, 14, 'Advanced Emergency & Burn Care', 24, 8, true),
  ('HOSP-04', 'Fortis Hospital Richmond Road', '14, Richmond Road, Bangalore', 12.9645, 77.6012, 6.9, 18, 'Orthopedic & Cardiac Emergency', 8, 2, true)
ON CONFLICT (id) DO NOTHING;
