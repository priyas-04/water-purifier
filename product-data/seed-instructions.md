# Product Catalogue Seeding Guide

This guide explains how to import the 60 sample products from `products.json` into Google Cloud Firestore.

## Prerequisites
1. A Firebase project created at [console.firebase.google.com](https://console.firebase.google.com).
2. Cloud Firestore enabled in production or test mode.
3. Node.js (v18+) installed.
4. Download a Firebase Admin SDK Service Account Private Key:
   - Go to **Project Settings** > **Service Accounts** in the Firebase Console.
   - Click **Generate New Private Key**.
   - Save the downloaded JSON file as `serviceAccountKey.json` inside this `product-data/` directory (or specify its path).
   - **Important**: `serviceAccountKey.json` is listed in `.gitignore` and must NEVER be committed to Git.

## Seeding via Node.js Script

Run the automated seed script:

```bash
# In the product-data directory
cd product-data
npm install firebase-admin
node seed.js
```

Or set the environment variable:
```bash
GOOGLE_APPLICATION_CREDENTIALS="./serviceAccountKey.json" node seed.js
```

## Creating the Initial Administrator

The seed script also creates the initial secure admin user profile without needing client-side privilege escalation:

```bash
node seed.js --create-admin admin@aquapure.com "AquaPure Administrator"
```

## Offline / Demo Mode
Both the Flutter mobile application and the React Admin panel feature an automatic offline / demo mode fallback: if Firebase credentials or internet are not configured, they automatically load and render the full 60-product catalogue from local memory/embedded JSON, so the application is 100% interactive and testable at all times.
