# SAVIOURS — App Flow Document
### Emergency Response & Traffic Coordination System (Flutter App)

---

## 1. DETAILED PROJECT OVERVIEW

**Saviours** is a Flutter-based mobile application built to reduce emergency response time for road accidents by connecting **four types of users** into one real-time coordinated pipeline: **Civilians, Ambulance Drivers, Traffic Police, and Admin (Control Room)**.

The core idea: a civilian witnesses/experiences an accident → captures live photographic evidence through the app (no gallery uploads, to prevent fraud) → an AI verification engine validates the incident and assigns a confidence score → if verified, the system instantly alerts the nearest ambulance driver and relevant traffic police officers → the ambulance is guided via live navigation to the incident spot → traffic police pre-clear junctions along the route, forming a **"green corridor"** → the ambulance picks up the patient → live navigation switches to hospital-transport mode, where the system suggests the best hospital based on distance, availability, and specialization → the patient is dropped off, closing the incident lifecycle → every step of this journey (timestamps, routes, officer actions, AI decisions) is logged for accountability, and rolled up into analytics.

**Every user role sees analytics — but scoped to their own contribution:**
- Civilians see their own report history and outcomes.
- Ambulance drivers see their own response/trip performance.
- Traffic police see their own clearance performance.
- **Admin** is the only role that sees system-wide analytics across all users, all incidents, and all zones — and is also responsible for reviewing/approving KYC verification for the other three roles.

**Core system rules carried through the whole app:**
- No user (Civilian, Ambulance Driver, Traffic Police) can access operational features until their KYC verification is approved.
- Sign-up requires OTP verification (mobile-based); day-to-day sign-in uses **Email/Phone + Password**.
- Admin accounts are not self-registered — they are provisioned separately (no public "Register as Admin" option).
- Every incident carries a single Incident ID that threads through Phases 1 → 4, tying together civilian report, ambulance trip, police clearance actions, and final analytics.

This app flow document is organized in three parts:
1. **Page Inventory** — every screen, grouped by Common/Auth and by each of the 4 roles.
2. **Navigation Flow** — how screens connect to each other (From → To) with a working description of each screen's function.

---

## 2. PAGE INVENTORY

### A. COMMON / AUTHENTICATION PAGES (shared by all users)
| # | Page Name |
|---|-----------|
| 1 | Splash Screen |
| 2 | Onboarding / Intro Slides |
| 3 | Language Selection |
| 4 | Login Page |
| 5 | Role Selection (Sign Up) |
| 6 | Sign Up – Basic Details |
| 7 | OTP Verification |
| 8 | Document / KYC Upload (role-specific fields) |
| 9 | Verification Pending Screen |
| 10 | Verification Rejected Screen |
| 11 | Forgot Password |
| 12 | Reset Password |
| 13 | Role-Based Home Redirect (routing logic, not a visible screen) |

### B. CIVILIAN PAGES
| # | Page Name |
|---|-----------|
| C1 | Civilian Home Dashboard |
| C2 | Report Accident – Camera Capture |
| C3 | Incident Submitted / AI Verifying (loading state) |
| C4 | Incident Verified Confirmation |
| C5 | Incident Rejected Screen |
| C6 | My Reports / Incident History |
| C7 | Live Incident Tracking (ambulance en route view) |
| C8 | My Analytics (personal) |
| C9 | Notifications |
| C10 | Profile / Edit Profile |
| C11 | Settings |
| C12 | Help & Support |

### C. AMBULANCE DRIVER PAGES
| # | Page Name |
|---|-----------|
| D1 | Driver Home Dashboard (On-Duty/Off-Duty toggle) |
| D2 | Incident Assignment Alert |
| D3 | Incident Details Screen |
| D4 | Criticality Selection (Low/Medium/High/Critical) |
| D5 | Live Navigation – Cycle 1 (to Incident Spot) |
| D6 | Patient Onboard Confirmation |
| D7 | Hospital Suggestion Screen |
| D8 | Live Navigation – Cycle 2 (to Hospital) |
| D9 | Drop-off Confirmation |
| D10 | Trip Summary Screen |
| D11 | Trip History |
| D12 | My Analytics (personal) |
| D13 | Notifications |
| D14 | Profile / Edit Profile |
| D15 | Settings |
| D16 | Help & Support |

### D. TRAFFIC POLICE PAGES
| # | Page Name |
|---|-----------|
| T1 | Traffic Police Home Dashboard |
| T2 | Live Ambulance Monitoring Map |
| T3 | Assigned Junction/Zone Screen (geo-fenced) |
| T4 | Traffic Clearance Action Screen ("Traffic Cleared" button) |
| T5 | Active Incident Coordination List |
| T6 | Clearance History |
| T7 | My Analytics (personal) |
| T8 | Notifications |
| T9 | Profile / Edit Profile |
| T10 | Settings |
| T11 | Help & Support |

### E. ADMIN PAGES
| # | Page Name |
|---|-----------|
| A1 | Admin Home Dashboard (system overview) |
| A2 | Overall Analytics Screen (Phase 4 system-wide metrics) |
| A3 | User Management (list of all Civilians/Drivers/Police) |
| A4 | Verification Review Screen (approve/reject pending KYC) |
| A5 | All Incidents Management List |
| A6 | Incident Detail – Full Audit Trail View |
| A7 | Reports & Export Screen |
| A8 | Notifications |
| A9 | Profile / Edit Profile |
| A10 | Settings |
| A11 | Help & Support |

---

## 3. NAVIGATION FLOW (Page-by-Page)

### SECTION A — COMMON / AUTHENTICATION FLOW

**1. Splash Screen**
- **Redirects from:** App launch (entry point)
- **Redirects to:** Onboarding (first-time users) OR Login Page (returning users, if session expired) OR directly to Role-Based Home (if valid session exists)
- **Working description:** Shows the Saviours logo/branding while the app initializes, checks for an existing login session/token in local storage, and silently loads config. Auto-navigates after 2–3 seconds — no user interaction needed.

**2. Onboarding / Intro Slides**
- **Redirects from:** Splash Screen (first-time install only)
- **Redirects to:** Language Selection
- **Working description:** 3–4 swipeable slides explaining the app's purpose (report accidents, save lives, coordinated response). Includes a "Skip" option. Shown only once per install; a local flag prevents it from showing again.

**3. Language Selection**
- **Redirects from:** Onboarding
- **Redirects to:** Login Page
- **Working description:** Lets the user pick a preferred app language (English/regional languages). Selection is stored locally and can be changed later from Settings.

**4. Login Page**
- **Redirects from:** Language Selection, Splash (returning users), Reset Password (after successful reset), Logout action (from any role's Settings)
- **Redirects to:** Role-Based Home Redirect (on success) → correct dashboard per role; Role Selection (via "Create Account" link); Forgot Password (via "Forgot Password" link)
- **Working description:** User enters **Email or Phone Number + Password**. On submit, credentials are validated against the backend. If the account is still pending KYC verification, user is instead routed to Verification Pending Screen. If rejected, routed to Verification Rejected Screen. If valid and verified, the system reads the user's role and hands off to the Role-Based Home Redirect logic.

**5. Role Selection (Sign Up)**
- **Redirects from:** Login Page ("Create Account")
- **Redirects to:** Sign Up – Basic Details
- **Working description:** User picks one of three self-registerable roles: "Register as Civilian", "Register as Ambulance Driver", or "Register as Traffic Police". (Admin is not listed here — Admin accounts are provisioned outside the app.) The chosen role determines which document set will be requested later.

**6. Sign Up – Basic Details**
- **Redirects from:** Role Selection
- **Redirects to:** OTP Verification
- **Working description:** Collects Username, Mobile Number, and Email. Validates uniqueness of username and correct mobile format. On submit, triggers an OTP send to the entered mobile number.

**7. OTP Verification**
- **Redirects from:** Sign Up – Basic Details
- **Redirects to:** Document/KYC Upload (on correct OTP); stays on same screen with error + retry (on incorrect OTP); Sign Up – Basic Details (after 3 failed attempts, registration temporarily locked)
- **Working description:** User enters the 4–6 digit OTP sent via SMS, valid for a short window (2–5 minutes). Includes a "Resend OTP" timer. This step is used only during Sign Up — regular login uses password, not OTP.

**8. Document / KYC Upload**
- **Redirects from:** OTP Verification
- **Redirects to:** Verification Pending Screen
- **Working description:** Screen fields change based on role selected in Step 5:
  - *Civilian:* Aadhaar card upload (front/back).
  - *Ambulance Driver:* Aadhaar + Ambulance Service ID card + Driving Licence.
  - *Traffic Police:* Aadhaar + Police ID card + Department verification document.
  All uploads are encrypted on capture. Once submitted, the backend runs OCR extraction, identity matching, and AI-based tamper/fraud/authenticity checks (as per Phase 1 of the project spec). The user is not blocked in-app during this — they're moved forward to the Pending screen while verification runs server-side.

**9. Verification Pending Screen**
- **Redirects from:** Document/KYC Upload; Login Page (if user tries logging in while still pending)
- **Redirects to:** Role-Based Home Redirect (once backend marks account Verified — can be push-notified); stays on this screen otherwise
- **Working description:** Informational screen: "Your documents are under review." Explains that OTP/document verification, AI validation, and (for Admin-side) manual review may take some time. User can pull-to-refresh to check status or wait for a push notification.

**10. Verification Rejected Screen**
- **Redirects from:** Document/KYC Upload (if AI/manual review fails); Login Page (if account status = rejected)
- **Redirects to:** Document/KYC Upload (via "Re-submit Documents" button); Help & Support
- **Working description:** Shows rejection reason if available (e.g., blurry image, document mismatch, duplicate registration) and lets the user re-upload corrected documents, restarting the verification step.

**11. Forgot Password**
- **Redirects from:** Login Page
- **Redirects to:** OTP Verification (reused component, for identity confirmation) → Reset Password
- **Working description:** User enters registered Email/Phone. System sends an OTP to confirm identity before allowing a password reset.

**12. Reset Password**
- **Redirects from:** Forgot Password (after OTP confirmed)
- **Redirects to:** Login Page
- **Working description:** User sets a new password (with confirmation field + strength validation). On success, redirects to Login with a success toast.

**13. Role-Based Home Redirect** *(logic layer, not a visible UI screen)*
- **Redirects from:** Login Page, Verification Pending Screen (once approved)
- **Redirects to:** Civilian Home Dashboard (C1) / Driver Home Dashboard (D1) / Traffic Police Home Dashboard (T1) / Admin Home Dashboard (A1)
- **Working description:** Reads the authenticated user's role from the session token and routes to the correct role dashboard. This is the single fork point where the app splits into four separate journeys.

---

### SECTION B — CIVILIAN FLOW

**C1. Civilian Home Dashboard**
- **Redirects from:** Role-Based Home Redirect
- **Redirects to:** Report Accident (C2), My Reports (C6), My Analytics (C8), Notifications (C9), Profile (C10)
- **Working description:** Landing screen for civilians. Prominent "Report Accident" button (primary CTA), quick view of any currently active/tracked incident, and bottom navigation to History, Analytics, Notifications, Profile.

**C2. Report Accident – Camera Capture**
- **Redirects from:** C1 Home Dashboard
- **Redirects to:** C3 Incident Submitted / AI Verifying
- **Working description:** Opens the device camera directly inside the app (gallery upload disabled by design to prevent fraud). User captures a live photo of the accident. On capture, the app automatically attaches GPS coordinates, server-synced timestamp, device ID, and network metadata, then uploads the package.

**C3. Incident Submitted / AI Verifying**
- **Redirects from:** C2 Report Accident
- **Redirects to:** C4 Incident Verified Confirmation (if AI confidence score ≥ threshold) OR C5 Incident Rejected Screen (if below threshold)
- **Working description:** A short loading/processing state while the backend AI pipeline runs image analysis, tampering detection, and context validation, producing a confidence score (0–100). User sees a simple "Verifying your report…" indicator.

**C4. Incident Verified Confirmation**
- **Redirects from:** C3 (on success)
- **Redirects to:** C7 Live Incident Tracking
- **Working description:** Confirms the incident is verified, displays the generated Incident ID, and states that 108 Control Room, local police, and traffic police have been alerted. Auto-navigates (or offers a button) to live tracking.

**C5. Incident Rejected Screen**
- **Redirects from:** C3 (on failure)
- **Redirects to:** C1 Home Dashboard; C2 Report Accident (to retry with a new capture)
- **Working description:** Informs the user the report couldn't be verified (e.g., low confidence score) and that no authorities were notified. May show a soft warning if the user has multiple rejected reports, to discourage repeated false reporting.

**C6. My Reports / Incident History**
- **Redirects from:** C1 Home Dashboard
- **Redirects to:** C7 Live Incident Tracking (for active ones) or a read-only detail view (for completed/rejected ones)
- **Working description:** Chronological list of all incidents the civilian has reported, each tagged Verified / Rejected / Completed, with date, time, and status.

**C7. Live Incident Tracking**
- **Redirects from:** C4 Incident Verified Confirmation, C6 My Reports
- **Redirects to:** C1 Home Dashboard (back navigation); auto-updates to "Completed" state once Phase 3 finishes
- **Working description:** Shows a live map view of the assigned ambulance approaching, current phase (En Route to You / Patient Onboard / En Route to Hospital / Completed), and ETA — giving the reporting civilian visibility into what happened after their report.

**C8. My Analytics (personal)**
- **Redirects from:** C1 Home Dashboard
- **Redirects to:** — (leaf screen)
- **Working description:** Personal-only analytics: total reports submitted, verified vs rejected ratio, average AI verification time, and outcomes of incidents they reported. No system-wide data is visible here.

**C9. Notifications**
- **Redirects from:** C1 Home Dashboard (bell icon)
- **Redirects to:** Relevant deep-link (e.g., tapping an "Incident Verified" notification opens C7)
- **Working description:** List of push notifications: verification results, ambulance status updates, system announcements.

**C10. Profile / Edit Profile**
- **Redirects from:** C1 Home Dashboard
- **Redirects to:** C11 Settings
- **Working description:** Displays verified identity details (name, masked Aadhaar, mobile, email) and allows editing of non-KYC fields (profile photo, email, emergency contact). Core KYC-linked fields are locked post-verification.

**C11. Settings**
- **Redirects from:** C10 Profile
- **Redirects to:** C12 Help & Support; Login Page (via Logout)
- **Working description:** App preferences — language, notification toggles, change password, logout, delete account request.

**C12. Help & Support**
- **Redirects from:** C11 Settings
- **Redirects to:** — (leaf screen)
- **Working description:** FAQs, contact support, report a bug/issue.

---

### SECTION C — AMBULANCE DRIVER FLOW

**D1. Driver Home Dashboard**
- **Redirects from:** Role-Based Home Redirect
- **Redirects to:** D2 Incident Assignment Alert (auto, on new dispatch); D11 Trip History; D12 My Analytics; D13 Notifications; D14 Profile
- **Working description:** Shows On-Duty/Off-Duty toggle. When On-Duty and idle, driver waits here for an incident assignment push. Displays current status and quick stats (today's trips).

**D2. Incident Assignment Alert**
- **Redirects from:** D1 (pushed automatically by system when an incident is routed to this driver)
- **Redirects to:** D3 Incident Details Screen
- **Working description:** Full-screen alert (similar to a ride-request screen) showing Incident ID, location, and severity level, with Accept/(time-boxed) options. Sound/vibration alert to grab attention immediately.

**D3. Incident Details Screen**
- **Redirects from:** D2 Incident Assignment Alert
- **Redirects to:** D4 Criticality Selection
- **Working description:** Shows the auto-loaded incident location on a mini-map, allows the driver to confirm or manually adjust the route/destination pin before starting navigation.

**D4. Criticality Selection**
- **Redirects from:** D3 Incident Details
- **Redirects to:** D5 Live Navigation – Cycle 1
- **Working description:** Driver selects severity: Low / Medium / High / Critical. This selection feeds routing priority and how urgently traffic clearance requests go out to police.

**D5. Live Navigation – Cycle 1 (to Incident Spot)**
- **Redirects from:** D4 Criticality Selection
- **Redirects to:** D6 Patient Onboard Confirmation (once driver arrives and confirms pickup)
- **Working description:** Turn-by-turn navigation to the incident location. Displays dynamic route coloring (blue = normal, green = cleared corridor), continuously updated ETA, and voice prompts ("Traffic cleared ahead", "Proceed through green corridor") as traffic police clear junctions in real time.

**D6. Patient Onboard Confirmation**
- **Redirects from:** D5 Live Navigation – Cycle 1
- **Redirects to:** D7 Hospital Suggestion Screen
- **Working description:** Single-action confirmation screen — driver taps "Patient Onboard" once the patient is in the ambulance. This updates the incident status system-wide and closes Phase 2, opening Phase 3.

**D7. Hospital Suggestion Screen**
- **Redirects from:** D6 Patient Onboard Confirmation
- **Redirects to:** D8 Live Navigation – Cycle 2
- **Working description:** Exclusive Phase-3 feature. Lists nearby hospitals ranked by distance, availability, and specialization (trauma, cardiac, etc.), each showing estimated arrival time. Driver can accept the top suggestion or manually pick an alternate hospital.

**D8. Live Navigation – Cycle 2 (to Hospital)**
- **Redirects from:** D7 Hospital Suggestion Screen
- **Redirects to:** D9 Drop-off Confirmation
- **Working description:** Same navigation engine as Cycle 1, re-targeted to the selected hospital. Continues green-corridor coordination, real-time ETA updates, and dynamic rerouting if new congestion appears.

**D9. Drop-off Confirmation**
- **Redirects from:** D8 Live Navigation – Cycle 2
- **Redirects to:** D10 Trip Summary Screen
- **Working description:** Driver confirms hand-off of the patient to hospital emergency staff. Records the drop-off timestamp and marks the incident "Completed Transport Cycle," closing Phase 3.

**D10. Trip Summary Screen**
- **Redirects from:** D9 Drop-off Confirmation
- **Redirects to:** D1 Driver Home Dashboard
- **Working description:** Post-trip recap: total time, distance, junctions cleared en route, incident outcome. Driver returns to On-Duty status afterward.

**D11. Trip History**
- **Redirects from:** D1 Home Dashboard
- **Redirects to:** Individual Trip Summary (read-only) view
- **Working description:** Chronological log of all past trips with status and key timestamps.

**D12. My Analytics (personal)**
- **Redirects from:** D1 Home Dashboard
- **Redirects to:** — (leaf screen)
- **Working description:** Personal performance metrics only: average response time, average pickup-to-hospital time, total trips, junctions passed through with clearance.

**D13. Notifications**
- **Redirects from:** D1 Home Dashboard
- **Redirects to:** Deep-links into relevant trip/incident screen
- **Working description:** Assignment alerts, system messages, status change confirmations.

**D14. Profile / Edit Profile**
- **Redirects from:** D1 Home Dashboard
- **Redirects to:** D15 Settings
- **Working description:** Shows verified identity + licence/service ID details (locked), editable contact info and photo.

**D15. Settings**
- **Redirects from:** D14 Profile
- **Redirects to:** D16 Help & Support; Login Page (via Logout)
- **Working description:** Preferences, notification toggles, change password, logout.

**D16. Help & Support**
- **Redirects from:** D15 Settings
- **Redirects to:** — (leaf screen)
- **Working description:** FAQs, contact support, issue reporting.

---

### SECTION D — TRAFFIC POLICE FLOW

**T1. Traffic Police Home Dashboard**
- **Redirects from:** Role-Based Home Redirect
- **Redirects to:** T2 Live Ambulance Monitoring Map; T5 Active Incident Coordination List; T7 My Analytics; T8 Notifications; T9 Profile
- **Working description:** Landing screen showing on-duty status and a summary of any active incidents relevant to the officer's assigned zone.

**T2. Live Ambulance Monitoring Map**
- **Redirects from:** T1 Home Dashboard
- **Redirects to:** T3 Assigned Junction/Zone Screen
- **Working description:** Real-time map showing ambulance movement broadcast to traffic police, control room, and system dashboard. Officer sees which ambulances are approaching their jurisdiction.

**T3. Assigned Junction/Zone Screen**
- **Redirects from:** T2 Live Ambulance Monitoring Map (auto-triggered via geo-fencing when an ambulance enters the officer's defined radius)
- **Redirects to:** T4 Traffic Clearance Action Screen
- **Working description:** Displays the geo-fenced zone/junction automatically assigned to this officer, along with the ambulance's ETA and required clearance points, per the system's geo-fencing and alert distribution logic.

**T4. Traffic Clearance Action Screen**
- **Redirects from:** T3 Assigned Junction/Zone Screen
- **Redirects to:** T1 Home Dashboard (after confirmation); T6 Clearance History (logged automatically)
- **Working description:** Officer evaluates congestion at the junction, takes pre-clearance action (redirecting vehicles, opening emergency lanes), then presses the **"Traffic Cleared"** button. System logs the exact timestamp and location of this action, which directly updates the ambulance driver's route (blue → green corridor).

**T5. Active Incident Coordination List**
- **Redirects from:** T1 Home Dashboard
- **Redirects to:** T3 Assigned Junction/Zone Screen (for a specific incident)
- **Working description:** List of all incidents currently active within the officer's jurisdiction, so they can track multiple simultaneous emergencies if needed.

**T6. Clearance History**
- **Redirects from:** T1 Home Dashboard
- **Redirects to:** — (leaf screen)
- **Working description:** Historical log of past clearance actions this officer has taken, with timestamps and incident references.

**T7. My Analytics (personal)**
- **Redirects from:** T1 Home Dashboard
- **Redirects to:** — (leaf screen)
- **Working description:** Personal-only metrics: number of junctions cleared, average clearance response time, incidents coordinated.

**T8. Notifications**
- **Redirects from:** T1 Home Dashboard
- **Redirects to:** Deep-links into T3/T4 for the relevant incident
- **Working description:** Geo-fence trigger alerts, ETA updates, system messages.

**T9. Profile / Edit Profile**
- **Redirects from:** T1 Home Dashboard
- **Redirects to:** T10 Settings
- **Working description:** Verified badge/ID and jurisdiction details (locked), editable contact info.

**T10. Settings**
- **Redirects from:** T9 Profile
- **Redirects to:** T11 Help & Support; Login Page (via Logout)
- **Working description:** Preferences, notification toggles, change password, logout.

**T11. Help & Support**
- **Redirects from:** T10 Settings
- **Redirects to:** — (leaf screen)
- **Working description:** FAQs, contact support, issue reporting.

---

### SECTION E — ADMIN FLOW

**A1. Admin Home Dashboard**
- **Redirects from:** Role-Based Home Redirect
- **Redirects to:** A2 Overall Analytics; A3 User Management; A5 All Incidents Management; A8 Notifications; A9 Profile
- **Working description:** Command-center style overview: total active incidents, total verified users by role, pending verifications count, and quick system health indicators.

**A2. Overall Analytics Screen**
- **Redirects from:** A1 Home Dashboard
- **Redirects to:** A7 Reports & Export Screen
- **Working description:** Full Phase-4 system-wide analytics: average ambulance response time, average pickup-to-hospital time, traffic clearance efficiency per officer, incident density heatmaps, zone-wise emergency frequency, peak time windows, hospital load distribution, route efficiency comparisons, and AI verification accuracy rate. This is the only role with visibility across all users and zones.

**A3. User Management**
- **Redirects from:** A1 Home Dashboard
- **Redirects to:** A4 Verification Review Screen; individual user detail view
- **Working description:** Searchable/filterable list of all Civilians, Ambulance Drivers, and Traffic Police, with verification status (Verified / Pending / Rejected) for each.

**A4. Verification Review Screen**
- **Redirects from:** A3 User Management
- **Redirects to:** A3 User Management (after decision is made)
- **Working description:** Shows a pending user's uploaded documents, AI-flagged concerns (tampering, mismatch, duplicate), and OCR-extracted data side-by-side with entered details. Admin approves or rejects, optionally with a reason — driving the Verification Pending/Rejected screens on the user's side.

**A5. All Incidents Management List**
- **Redirects from:** A1 Home Dashboard
- **Redirects to:** A6 Incident Detail – Full Audit Trail
- **Working description:** Master list of every incident in the system (Verified, Rejected, In Progress, Completed) with filters by status, zone, and date.

**A6. Incident Detail – Full Audit Trail View**
- **Redirects from:** A5 All Incidents Management List
- **Redirects to:** A5 (back navigation)
- **Working description:** Complete record per Phase 4's data model: incident ID, civilian report metadata, AI verification results, media logs, ambulance/driver ID, full GPS route trace, phase timestamps, traffic officer IDs and clearance timestamps, ETA history, hospital selection, drop-off time, and final status. Used for audit and legal evidence support.

**A7. Reports & Export Screen**
- **Redirects from:** A2 Overall Analytics
- **Redirects to:** — (leaf screen)
- **Working description:** Lets Admin generate/export periodic reports (daily/weekly/monthly) for government reporting, compliance, and internal performance benchmarking.

**A8. Notifications**
- **Redirects from:** A1 Home Dashboard
- **Redirects to:** Deep-links into relevant incident/user record
- **Working description:** System alerts — new pending verifications, flagged incidents, anomaly alerts from AI fraud detection.

**A9. Profile / Edit Profile**
- **Redirects from:** A1 Home Dashboard
- **Redirects to:** A10 Settings
- **Working description:** Admin account details, editable contact info.

**A10. Settings**
- **Redirects from:** A9 Profile
- **Redirects to:** A11 Help & Support; Login Page (via Logout)
- **Working description:** Preferences, notification toggles, change password, logout, manage sub-admin access (if applicable).

**A11. Help & Support**
- **Redirects from:** A10 Settings
- **Redirects to:** — (leaf screen)
- **Working description:** Internal support/documentation reference.

---

## 4. HIGH-LEVEL FLOW SUMMARY

```
Splash → Onboarding → Language → Login/Sign-Up
                                     │
                        ┌────────────┼────────────┬───────────────┐
                        ▼            ▼             ▼               ▼
                    Civilian    Ambulance      Traffic          Admin
                     Home        Driver        Police           Home
                        │         Home          Home              │
                        │           │             │                │
              Report Accident  Incident      Live Ambulance   User Mgmt /
                → AI Verify   Assignment    → Junction Zone    Verification
                → Alerts Sent   → Cycle 1        → Clear         Review
                        │      Navigation      Traffic              │
              Live Tracking  → Patient          Button          Overall
                of Ambulance   Onboard            │             Analytics
                        │           │              │                │
                        └──> Hospital Suggestion ──┘          All Incidents
                             → Cycle 2 Navigation              Audit Trail
                             → Drop-off → Trip Summary               │
                                     │                          Reports/Export
                              Analytics (per-role, personal)
```

---

## 5. TECH STACK & BACKEND ARCHITECTURE

**Frontend:** Flutter (single codebase, Android + iOS)
**UI Direction:** Spotify-inspired — see Section 9 for the full design system.

### 5.1 Backend Stack (Hybrid: Supabase + Firebase)

| Layer | Service | Why |
|---|---|---|
| Database | **Supabase (Postgres)** | Relational data (users, incidents, KYC, trips, clearances) benefits from real foreign keys/joins, which Postgres does natively and Firestore doesn't. |
| Auth | **Supabase Auth** | Email/Phone + Password login, with OTP (email or SMS) used only during sign-up verification, exactly as scoped. Row Level Security (RLS) policies enforce that a Civilian can only read their own reports, a Driver only their own trips, etc. |
| Realtime | **Supabase Realtime** | Postgres changes (new incident row, ambulance location update, clearance action) are broadcast over WebSockets to subscribed clients — powers Live Incident Tracking, Live Ambulance Monitoring Map, and Assignment Alerts. |
| File Storage | **Supabase Storage** | KYC documents (Aadhaar, licence, ID cards) and accident photos, stored in private buckets with signed URLs — never public. |
| Serverless Logic | **Supabase Edge Functions** (Deno/TypeScript) | Hosts the AI verification call, hospital-suggestion ranking logic, and notification-dispatch logic — anything that must run server-side with secret keys. |
| Push Notifications | **Firebase Cloud Messaging (FCM)** | Best-in-class, free, cross-platform push delivery for Flutter — used for Incident Assignment Alerts, geo-fence triggers, verification results. |
| Crash/Analytics (optional) | **Firebase Crashlytics + Analytics** | "Latest features" — crash reporting and product analytics, independent of the Supabase data model. |
| Maps & Navigation | **Google Maps Platform** | See Section 7. |
| AI Verification | **Google Gemini API (Flash model)** | See Section 8. |

> **Why not pick one or the other?** Supabase gives you a real relational schema + built-in realtime + auth + storage in one box — ideal for the incident/user data model. Firebase remains best-in-class specifically for push notifications (FCM) and optional crash/analytics tooling. Splitting them this way avoids forcing Postgres-shaped data into Firestore documents, while still getting Firebase's push infrastructure for free.

### 5.2 Core Database Tables (Supabase/Postgres)

| Table | Key Columns | Notes |
|---|---|---|
| `users` | id, role (civilian/driver/police/admin), name, email, phone, password_hash (managed by Supabase Auth), verification_status | One table, role column drives app routing |
| `kyc_documents` | id, user_id, doc_type, file_url, status, rejection_reason | Linked to Storage bucket |
| `incidents` | id, reporter_id, image_url, lat, lng, ai_confidence_score, status, criticality, created_at | Central object threading Phases 1–4 |
| `trips` | id, incident_id, driver_id, hospital_id, pickup_time, dropoff_time, status | Cycle 1 + Cycle 2 data |
| `clearances` | id, incident_id, officer_id, junction_name, cleared_at | Traffic police action log |
| `hospitals` | id, name, lat, lng, specialization, capacity_flag | Feeds Hospital Suggestion screen |
| `notifications` | id, user_id, title, body, deep_link, read_at | Mirrors FCM sends for in-app Notifications list |

### 5.3 Environment / Config Files Flutter Needs

- `.env` (loaded via `flutter_dotenv`, **never committed to git**) — Supabase URL, Supabase anon key, Google Maps API key, Gemini API key reference (server-side only, see 6.2)
- `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) — Firebase config, downloaded from Firebase Console
- `android/app/src/main/AndroidManifest.xml` — Google Maps API key injected via manifest placeholder, restricted by SHA-1 + package name
- `ios/Runner/AppDelegate.swift` — Google Maps API key initialization for iOS

---

## 6. API REFERENCE & ENVIRONMENT KEYS

### 6.1 Key Inventory — What Each Key Is For, Where It Lives

| Key / Credential | Used For | Where It Lives | Exposure Risk |
|---|---|---|---|
| `SUPABASE_URL` | Base URL for all Supabase calls | `.env` → Flutter client | Safe to expose (public) |
| `SUPABASE_ANON_KEY` | Client-side Supabase access, gated by RLS policies | `.env` → Flutter client | Safe to expose — RLS is the real security layer |
| `SUPABASE_SERVICE_ROLE_KEY` | Admin-level DB access (bypasses RLS) | **Server-side only** — Supabase Edge Functions env | **Never** ship in the Flutter app |
| `GOOGLE_MAPS_API_KEY` | Maps SDK, Directions, Places, Roads, Geocoding | `.env` + native manifest files | Restrict by Android SHA-1/package name and iOS Bundle ID in Google Cloud Console; also restrict by API (enable only the 4 APIs actually used) |
| `GEMINI_API_KEY` | AI accident-image verification | **Server-side only** — Supabase Edge Function env | Never in the Flutter app — all AI calls proxied through your own Edge Function |
| `FCM_SERVER_KEY` / Firebase service account | Sending push notifications from backend | **Server-side only** — Edge Function or Cloud Function env | Never in the Flutter app |
| Firebase client config (`google-services.json` / `.plist`) | Initializes Firebase SDK (FCM, Crashlytics) in-app | Bundled in app (this one is meant to be client-side) | Low risk — it's an app identifier, not a secret |

**Golden rule:** any key that can *cost money per call* or *grant write/delete access* (Gemini key, Supabase service role key, FCM server key) stays server-side in an Edge Function. The Flutter app only ever talks to your own backend or to keys explicitly designed to be public + restricted (Supabase anon key, Maps key with platform restrictions).

### 6.2 Core API Endpoints (Supabase Edge Functions)

| Endpoint | Method | Called From | Purpose |
|---|---|---|---|
| `/functions/v1/verify-incident` | POST | C2 → C3 (Report Accident) | Receives image + GPS + timestamp, calls Gemini internally, writes `ai_confidence_score` to `incidents`, returns verified/rejected |
| `/functions/v1/dispatch-incident` | POST | Triggered server-side after verify-incident succeeds | Finds nearest available driver, creates `trips` row, sends FCM push to Driver (D2) and geo-fenced Traffic Police (T3) |
| `/functions/v1/suggest-hospitals` | POST | D6 → D7 (Hospital Suggestion) | Queries `hospitals` table, ranks by distance (via Maps Distance Matrix) + specialization + capacity flag |
| `/functions/v1/clear-junction` | POST | T4 Traffic Clearance Action | Writes `clearances` row, updates the related `trips`/`incidents` row so the driver's route recolors green |
| `/functions/v1/review-kyc` | POST | A4 Verification Review (Admin) | Admin approves/rejects a `kyc_documents` row; triggers status-change push to the user |
| `/functions/v1/analytics-summary` | GET | C8 / D12 / T7 (personal) and A2 (system-wide) | Same endpoint, scoped by RLS + a `?scope=self|all` param — `all` only permitted for Admin role |

Direct Supabase client calls (no Edge Function needed) handle simple CRUD: reading `notifications`, updating `profile` fields, reading `trips`/`incidents` history — RLS policies keep these safe without custom backend code.

---

## 7. MAPS, LOCATION & REAL-TIME TRACKING (Google Maps Platform)

### 7.1 APIs to Enable in Google Cloud Console

| API | Used For |
|---|---|
| **Maps SDK for Android/iOS** | Rendering the live map in Flutter (`google_maps_flutter` package) |
| **Directions API** | Turn-by-turn route + polyline for Live Navigation (D5, D8) |
| **Places API** | Hospital search/autocomplete groundwork for Hospital Suggestion (D7) |
| **Geocoding API** | Converting lat/lng ↔ human-readable addresses (incident location display) |
| **Roads API** | Snap-to-road correction so the ambulance marker doesn't drift off-route on live tracking |
| **Distance Matrix API** | Ranking hospitals/ambulances by real drive-time, not straight-line distance |

### 7.2 Recommended Flutter Packages

- `google_maps_flutter` — core map rendering
- `geolocator` — device GPS stream, permission handling
- `flutter_polyline_points` — decodes Directions API polyline for route drawing
- `geoflutterfire2` (or a raw PostGIS query via Supabase) — geo-fencing / "nearest driver or officer" queries

### 7.3 Geo-Fencing Approach (Traffic Police auto-assignment, T3)

Traffic Police don't manually pick a zone — the system assigns it. Each officer's profile stores a home-junction `lat/lng` + radius (e.g., 500m). When an incident's live route enters that radius (checked server-side via a Postgres/PostGIS `ST_DWithin` query, run on each location update), the `dispatch-incident` (or a `check-geofence`) function pushes an alert to that officer — this is what drives Assigned Junction/Zone Screen (T3) appearing automatically.

### 7.4 Live Location Update Flow

1. Driver's app streams GPS via `geolocator` every 3–5 seconds while a trip is active.
2. Each update is written to a `driver_locations` realtime-enabled table (or broadcast via a Supabase Realtime channel, not persisted every tick to avoid bloating the DB).
3. Civilian's Live Tracking screen (C7) and Traffic Police's Live Ambulance Map (T2) both subscribe to that channel and move the marker smoothly (animate between points rather than snapping).
4. Route polyline is fetched once per navigation cycle (Cycle 1 / Cycle 2) from Directions API, then re-fetched only if the driver deviates significantly (to control API cost).

### 7.5 Cost Note

Google Maps Platform gives a recurring monthly credit; Directions/Distance Matrix/Places calls are the ones to watch at scale. Cache route polylines per trip rather than re-requesting on every location tick, and only re-call Directions on meaningful deviation (e.g., >100m off-route) rather than on a timer.

---

## 8. AI ACCIDENT VERIFICATION — API CONTRACT

**Recommended provider:** Google Gemini API (Flash / Flash-Lite model) — see the reasoning above. This section is written as a clean contract so the Flutter/UI side, the Edge Function, and the eventual model choice can all be built independently.

**Request** (Flutter → `verify-incident` Edge Function):
```json
{
  "image_base64": "<captured photo>",
  "lat": 12.9716,
  "lng": 77.5946,
  "timestamp": "2026-08-26T10:15:00Z",
  "reporter_id": "uuid"
}
```

**What the Edge Function does internally:**
1. Uploads image to Supabase Storage, gets a signed URL.
2. Sends the image + a structured prompt to Gemini Flash asking it to assess: is this genuinely a road accident scene, does anything suggest staging/tampering, and how confident is it (0–100)?
3. Parses Gemini's structured JSON response.
4. Writes the result to the `incidents` row.

**Response** (Edge Function → Flutter):
```json
{
  "incident_id": "uuid",
  "verified": true,
  "confidence_score": 87,
  "flags": [],
  "message": "Incident verified. Authorities have been alerted."
}
```

If `verified: false`, the app routes to Incident Rejected (C5) with the `message` shown to the user. The Flutter side never needs to know which AI model produced this — only this contract.

---

## 9. UI/UX DESIGN SYSTEM — SPOTIFY-INSPIRED

Saviours borrows Spotify's *visual language* — dark canvas, bold oversized type, generous rounded cards, confident single-accent color, bottom tab navigation, smooth motion — while adapting the color semantics for an emergency context (Spotify's UI is optimized for browsing; ours needs to stay legible and unambiguous in high-stress moments).

### 9.1 Color Palette

| Token | Hex | Usage |
|---|---|---|
| Background (base) | `#121212` | Primary app background, matches Spotify's near-black canvas |
| Surface (cards) | `#1E1E1E` | Cards, sheets, bottom nav bar |
| Surface Elevated | `#282828` | Pressed/hover state, modals |
| Primary Accent | `#1DB954` (Spotify green) | Primary CTAs, success states, "Verified", "Cleared", "Completed" |
| Critical/Alert | `#E53935` | Report Accident button, Critical severity tag, Rejected states — must stand out from the green accent, never rely on green alone for status |
| Warning/Pending | `#F2A93B` | Pending verification, medium severity |
| Text Primary | `#FFFFFF` | Headlines, primary labels |
| Text Secondary | `#B3B3B3` | Captions, timestamps, secondary metadata |
| Divider | `#2A2A2A` | Hairlines between list rows |

### 9.2 Typography

- **Font family:** A geometric/grotesque sans-serif (e.g., Inter, Circular, or Gotham-alike) — bold, confident, high x-height, mirroring Spotify's type feel.
- **Scale:** Large display headlines for dashboard greetings ("Good morning" / status banners) at 28–32sp bold; section titles 20sp bold; body 14–16sp regular; captions 12sp at Text Secondary color.
- Numbers (ETA, confidence score, analytics figures) get extra-bold weight and slightly larger size to read at a glance under stress.

### 9.3 Layout & Components

- **Bottom Tab Navigation** — persistent across each role's home area (mirrors Spotify's Home/Search/Library bar), 4–5 icons max per role (e.g., Civilian: Home, Reports, Analytics, Profile).
- **Hero Card Pattern** — Spotify's "big image + gradient overlay + title" card style is reused for: the active incident card on Civilian Home, the current trip card on Driver Home, and the assigned zone card on Traffic Police Home — large map thumbnail or icon, gradient fade to a dark base, bold title, status pill.
- **Rounded Cards** — 12–16px corner radius throughout (report history rows, trip history, hospital suggestion cards), consistent with Spotify's playlist-card rounding.
- **Status Pills** — small rounded-full tags (Verified / Pending / Rejected / Cleared) using the accent colors from 9.1, placed top-right of cards, echoing Spotify's "Explicit"/badge tags.
- **Bottom Sheets** — used for OTP entry, hospital selection, and criticality selection, sliding up over a dimmed background, matching Spotify's now-playing/queue sheet pattern.
- **Motion** — smooth 200–300ms ease transitions between screens, marker animation on maps (no hard snapping), subtle scale-down on button press — Spotify-style tactile feedback, not flashy.

### 9.4 Where the Emergency Context Overrides Spotify Norms

- The **Report Accident** button (C2 entry point) is never styled in the green accent — it uses the Critical/Alert red, full-width, impossible to miss, breaking from Spotify's usual single-accent restraint intentionally.
- Live Navigation screens (D5/D8) and the Traffic Clearance Action screen (T4) use higher-contrast, larger touch targets than a typical Spotify list screen — these are used while driving or standing at a junction, not lounging with a phone.
- No dark-pattern "keep scrolling" feeds — every operational screen (Assignment Alert, Clearance Action, Report Accident) has one obvious primary action, not a browsing feed.

---

## 10. COMPLETE FEATURE MATRIX

| Feature | Civilian | Ambulance Driver | Traffic Police | Admin |
|---|:---:|:---:|:---:|:---:|
| Email/Phone + Password login | ✅ | ✅ | ✅ | ✅ |
| OTP-verified sign-up + KYC upload | ✅ | ✅ | ✅ | — (provisioned) |
| Camera-only accident capture + AI verification | ✅ | — | — | — |
| Real-time incident dispatch | triggers | receives | receives (geo-fenced) | views all |
| Live map tracking | view only | navigate | monitor | view all |
| Green-corridor routing | — | consumes | creates | — |
| Hospital suggestion engine | — | ✅ | — | configures `hospitals` table |
| Push notifications (FCM) | ✅ | ✅ | ✅ | ✅ |
| Personal analytics (scoped) | ✅ | ✅ | ✅ | — |
| System-wide analytics | — | — | — | ✅ |
| User verification approval | — | — | — | ✅ |
| Full incident audit trail | — | — | — | ✅ |
| Report export | — | — | — | ✅ |

---

*End of App Flow Document.*
