# CarePulse — Telemedicine & Digital Healthcare Mobile App

A modern, production-grade cross-platform mobile application built with **Flutter & Dart**, architected with **Clean Architecture & Repository Pattern**, and optimized for **telemedicine, digital health records, prescription management, and secure doctor-patient communications**.

---

## 🌟 Key Features Implemented

### 1. 🔐 Authentication & Biometrics
- **Email / Password Sign-In:** Form validation with toggleable password visibility and pre-configured demo patient credentials.
- **Biometric Security Simulation:** Fast login via simulated Face ID / Fingerprint hardware scan with haptic/visual pulse animation.
- **HIPAA & GDPR Compliance:** Emphasizes Protected Health Information (PHI) encryption in transit and at rest.

### 2. 👨‍⚕️ Doctor Discovery & Telehealth Booking
- **Specialty Filter Chips:** Filter clinicians across Cardiology, Dermatology, Neurology, General Medicine, and Pediatrics.
- **Live Search:** Search by doctor name, medical specialty, or affiliated hospital.
- **Doctor Profiles:** Detailed credentials, board certifications, patient ratings, review counts, experience years, and consultation fee.
- **Interactive Booking Engine:**
  - Dynamic 7-day calendar selector.
  - Morning, afternoon, and evening slot picker.
  - Mode toggle: **HD Video Consultation** vs. **In-Clinic Visit**.
  - Reason for visit input field and instant confirmation receipt.

### 3. 💊 E-Prescriptions & Refill Ordering
- **Prescription List:** Real-time status badges (`Active`, `Refill in Process`, `Course Completed`).
- **Digital Rx Document (PDF-Style):**
  - Official clinic branding and Rx symbol.
  - Patient demographics (Pranjal Bajaj, Blood Group O+).
  - Prescribing clinician details, registration number, and digital signature.
  - Comprehensive drug table: generic name, dosage, frequency, course duration, and refills remaining.
- **One-Tap Refill Ordering:** Transmits refill requests directly to partner pharmacies with automated feedback.

### 4. 💬 Secure Telemedicine Messaging
- **Encrypted Doctor Threads:** Active direct chat channels with attending clinicians.
- **Online Indicators & Unread Badging:** Real-time availability status for each physician.
- **Interactive Clinical Quick-Replies:** One-tap suggestion chips for fast symptom updates and vital sharing.
- **Clinician Auto-Reply Simulation:** Simulates responsive doctor follow-up messaging in real-time.
- **Attachment Simulation:** Upload lab reports and clinical photos.

### 5. 🩺 Continuous Patient Health Vitals
- **Vitals Dashboard:** Real-time tracking of:
  - Resting Heart Rate (BPM)
  - Blood Pressure (mmHg)
  - Blood Glucose (mg/dL)
  - Blood Oxygen (% SpO2)
  - Body Weight & BMI (kg)
- **Clinical Threshold Flags:** Automatic "Normal" / "Optimal" status indicators.

### 6. 🪪 Patient Medical Passport & Settings
- Patient profile card with contact information.
- Medical passport: Blood group, known allergies, chronic conditions, and emergency contacts.
- Security toggles: Enable/Disable Biometric Authentication.

---

## 🏗️ Architecture & Folder Structure

The project follows a modular **Clean Architecture** approach using GetX for lightweight dependency injection, routing, and reactive state management:

```
carepulse/
├── pubspec.yaml
├── analysis_options.yaml
└── lib/
    ├── main.dart                          # App entry point & initialization
    ├── bindings/
    │   └── initial_binding.dart          # Dependency injection container
    ├── routes/
    │   └── app_pages.dart                # Declarative routes & transitions
    ├── core/
    │   ├── constants/                    # Colors, typography, and assets
    │   ├── theme/                        # Light & Dark medical themes
    │   └── widgets/                      # Reusable buttons, inputs, headers
    ├── data/
    │   ├── models/                       # Domain models (Doctor, Appointment, Rx, etc.)
    │   ├── mock_data/                    # Clinical demo datasets
    │   └── repositories/                 # Abstract interfaces + Mock implementations
    └── modules/
        ├── auth/                         # Login & Biometric authentication
        ├── navigation/                   # Bottom navigation container
        ├── home/                         # Patient home dashboard
        ├── doctors/                      # Doctor directory & appointment booking
        ├── appointments/                 # Scheduled, completed & cancelled visits
        ├── prescriptions/                # Digital Rx & pharmacy refill orders
        ├── chat/                         # Encrypted doctor-patient messaging
        └── profile/                      # Medical passport & security settings
```

---

## 🔌 Swapping Mock Repositories to Live Firebase / Supabase

The codebase adheres strictly to the **Dependency Inversion Principle**. Each feature depends only on abstract repository interfaces (`IAuthRepository`, `IDoctorRepository`, `IAppointmentRepository`, etc.).

To switch from Mock to live Firebase/Supabase:
1. Create a `FirebaseAppointmentRepository` implementing `IAppointmentRepository`.
2. In `lib/bindings/initial_binding.dart`, replace:
   ```dart
   // From:
   Get.put<IAppointmentRepository>(AppointmentRepository(), permanent: true);
   
   // To:
   Get.put<IAppointmentRepository>(FirebaseAppointmentRepository(), permanent: true);
   ```
No UI widgets, controllers, or views need to be rewritten!

---

## 🚀 How to Run

1. Open your terminal and navigate to the project directory:
   ```bash
   cd carepulse
   ```

2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```

3. Run on your desired target (Chrome, Windows, Android Emulator, or iOS Simulator):
   ```bash
   flutter run -d chrome
   # or
   flutter run -d windows
   ```
