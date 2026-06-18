Here's your README:

---

# 🚑 The Saviours
### Real-Time Traffic Coordination for Intelligent Medical Emergency Response Systems

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Google%20Maps-4285F4?style=for-the-badge&logo=googlemaps&logoColor=white"/>
</p>

<p align="center">
  <b>🏆 Winner — Best Innovative Idea | BFB 24-Hour Hackathon</b>
</p>

---

## 🌟 Overview

**The Saviours** is a cross-platform mobile application that creates intelligent green corridors for ambulances in real-time. By coordinating with traffic police and leveraging live GPS tracking, the system ensures emergency vehicles reach hospitals faster — because every second counts.

---

## 🎯 Problem Statement

- 🚧 Heavy urban traffic significantly delays ambulances
- ⏱️ Each minute of delay reduces patient survival chances
- 🚦 Manual traffic control at junctions is slow and unreliable
- 📡 No real-time communication between ambulances and traffic police

---

## 💡 Solution

The Saviours bridges the gap between ambulances, traffic police, and administrators through a unified real-time platform:

- ✅ Live GPS-based ambulance tracking
- ✅ Instant alerts to traffic police ahead of the ambulance route
- ✅ Smart route optimization for fastest path to hospital
- ✅ Role-based dashboards for all stakeholders
- ✅ Admin oversight and verification system

---

## 🧠 Key Features

| Feature | Description |
|---|---|
| 🚑 Live Tracking | Real-time GPS updates of ambulance location |
| 👮 Police Alerts | Automatic notifications to traffic police at upcoming junctions |
| 📊 Admin Dashboard | Full visibility, user verification, and system control |
| 🔐 Role-based Auth | Separate secure login for Admin, Ambulance Driver, and Police |
| 🗺️ Map Integration | Google Maps for live route display and navigation |
| 🔔 Push Notifications | FCM-powered alerts across all roles |

---

## 🛠️ Tech Stack

| Technology | Usage |
|---|---|
| Flutter | Cross-platform mobile app (Android, iOS, Web) |
| Firebase Auth | Secure role-based authentication |
| Cloud Firestore | Real-time database for live tracking data |
| Firebase Cloud Messaging | Push notifications |
| Google Maps API | Live GPS tracking and route optimization |
| Dart | Programming language |

---

## 🏗️ System Architecture

```
Ambulance App
      │
      ▼
Firebase Firestore ──────────► Admin Dashboard
      │                              │
      ▼                              ▼
Police Alert System          User Verification
      │
      ▼
Traffic Signal Coordination
```

---

## 📱 App Screens

- 🔐 **Flash Screen** — Animated splash with role selection
- 👤 **Login & Sign Up** — Role-based authentication
- 🚑 **Ambulance Dashboard** — Live status and map view
- 👮 **Police Dashboard** — Incoming alerts and map
- 📊 **Admin Dashboard** — Full system overview

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Firebase account
- Google Maps API key

### 1️⃣ Clone the repository
```bash
git clone https://github.com/sindhu-1213/the-saviours.git
cd the-saviours
```

### 2️⃣ Install dependencies
```bash
flutter pub get
```

### 3️⃣ Environment Setup
Create a `.env` file in the root directory:
```
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

### 4️⃣ Run the app
```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── core/
│   └── services/
│       ├── auth_service.dart
│       └── location_service.dart
├── views/
│   ├── admin/
│   ├── ambulance/
│   ├── auth/
│   └── police/
├── firebase_options.dart
└── main.dart
```

---

## 🔮 Future Enhancements

- 🤖 AI-based traffic prediction and signal automation
- 🧠 ML-powered route optimization
- 🏙️ Integration with smart city infrastructure
- 📊 Advanced analytics and reporting dashboard
- 🚗 Vehicle-to-signal direct communication

---

## 👥 Team — The Saviours

Won the BEST INNOVATIVE AWARD at BFB 24-Hour Hackathon

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

