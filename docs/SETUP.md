# AquaPure: Complete Environment & Setup Guide

This guide details the step-by-step instructions to set up, configure, and execute the entire AquaPure ecosystem locally.

---

## 1. Prerequisites

Ensure you have the following installed on your workstation:
- **Node.js**: v18.0.0 or higher (v20+ recommended)
- **npm**: v9.0.0 or higher
- **Git**: v2.30.0 or higher
- **Flutter SDK**: v3.16.0 or higher (for mobile development)
- **Android Studio / SDK**: Android 14 (API 34) platform tools & emulator
- **Docker & Docker Compose**: For local n8n and WAHA services

---

## 2. Repository Layout

```
water-purifier-project/
├── mobile/water_purifier_app/   # Flutter Android Mobile Application
├── admin/admin-panel/           # React + Vite + TypeScript Admin Dashboard
├── automation/                  # n8n Workflow, WAHA Docker, Marketing scripts
├── product-data/                # 60 Sample Products JSON and Firestore seeder
├── firebase/                    # Firestore Security Rules, Indexes, and config
└── docs/                        # Architecture, Setup, Testing, and Deployment
```

---

## 3. Product Catalogue & Database Seeding

The project comes pre-bundled with 60 realistic water purifier products across 5 categories (`purifier`, `dispenser`, `pump`, `filter`, `spare_part`).

### Option A: Local / Offline Mode (Zero Configuration)
Both the Flutter mobile application and the React admin panel run out-of-the-box in **Safe Demo Mode** without needing real Firebase credentials or network access.

### Option B: Seeding to Cloud Firestore
1. Create a Firebase Project at [console.firebase.google.com](https://console.firebase.google.com).
2. Enable **Firestore Database** and **Firebase Authentication** (Email/Password).
3. Download a Service Account Private Key:
   - Project Settings > Service Accounts > Generate New Private Key.
   - Save as `product-data/serviceAccountKey.json`.
4. Deploy security rules and indexes:
   ```bash
   firebase deploy --only firestore
   ```
5. Run the seeder script:
   ```bash
   cd product-data
   npm install firebase-admin
   node seed.js
   ```
6. Bootstrap the initial Super Administrator:
   ```bash
   node seed.js --create-admin admin@aquapure.com "AquaPure Administrator"
   ```

---

## 4. Admin Web Dashboard Setup

1. Open a terminal in `admin/admin-panel`:
   ```bash
   cd admin/admin-panel
   npm install
   ```
2. (Optional) Create `.env` from example:
   ```bash
   cp .env.example .env
   ```
3. Start the Vite local development server:
   ```bash
   npm run dev
   ```
4. Open `http://localhost:5173/` in your browser.
5. Log in with the pre-filled demo administrator credentials:
   - **Email**: `admin@aquapure.com`
   - **Password**: `admin123`

---

## 5. Flutter Mobile Application Setup

1. Open a terminal in `mobile/water_purifier_app`:
   ```bash
   cd mobile/water_purifier_app
   ```
2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```
3. Run tests:
   ```bash
   flutter test
   ```
4. Launch on an Android Emulator or connected device:
   ```bash
   flutter run
   ```

### Evaluator Demo Accounts:
The mobile application features an instant **Evaluator Mode Role Switcher** on the login and profile screens:
- **Customer Account**: `rahul.sharma@example.com` / `password123` (Retail pricing, service bookings)
- **Approved Dealer**: `dealer.approved@aquapure.com` / `password123` (Wholesale prices, bulk orders)
- **Pending Dealer**: `dealer.pending@aquapure.com` / `password123` (Wholesale locked awaiting approval)

---

## 6. AI Marketing Automation Setup (n8n & WAHA)

1. Open a terminal in `automation`:
   ```bash
   cd automation
   cp .env.example .env
   ```
2. Start containers:
   ```bash
   docker compose up -d
   ```
3. Access n8n at `http://localhost:5678`.
4. Import `automation/n8n-workflow.json`.
5. Run the offline test suite:
   ```bash
   node test-workflow.js
   ```
