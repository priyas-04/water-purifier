# AquaPure: Production Deployment Guide

This guide describes how to deploy the Admin Web Dashboard to Vercel, build the release Android APK, and deploy the n8n automation engine.

---

## 1. Admin Web Dashboard Deployment to Vercel

The Admin Web Dashboard is built with React + Vite + TypeScript + Tailwind CSS and is configured for seamless deployment on Vercel.

### Step 1: Push Repository to GitHub
```bash
git add .
git commit -m "feat: complete AquaPure system"
git push origin main
```

### Step 2: Import into Vercel
1. Log into your [Vercel Dashboard](https://vercel.com).
2. Click **Add New...** > **Project**.
3. Import your GitHub repository `water-purifier-project`.
4. Configure the project settings:
   - **Framework Preset**: `Vite`
   - **Root Directory**: `admin/admin-panel`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
   - **Install Command**: `npm install`

### Step 3: Environment Variables on Vercel
Add the following environment variables in the Vercel project settings:
```
VITE_FIREBASE_API_KEY=your_firebase_api_key
VITE_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
VITE_FIREBASE_PROJECT_ID=your_project_id
VITE_FIREBASE_STORAGE_BUCKET=your_project.appspot.com
VITE_FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id
VITE_FIREBASE_APP_ID=your_app_id
```
*(Note: If variables are omitted, the dashboard runs in Safe Demo Mode using the bundled 60-product catalogue and simulated operations).*

### Step 4: Client-Side Routing Verification
The repository includes `admin/admin-panel/vercel.json` with Single Page Application (SPA) rewrite rules:
```json
{
  "framework": "vite",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```
This guarantees that direct navigation or refreshing pages like `/products`, `/orders`, or `/dealers` returns HTTP 200 without 404 errors.

---

## 2. Android Mobile Application Release Build

### Step 1: Keystore Generation
Generate a release signing keystore (or use debug keystore for assessment evaluation):
```bash
keytool -genkey -v -keystore android/app/release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias aquapure
```

### Step 2: Configure `key.properties`
Create `mobile/water_purifier_app/android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=aquapure
storeFile=release-keystore.jks
```

### Step 3: Build Release APK
```bash
cd mobile/water_purifier_app
flutter build apk --release --split-per-abi
```
Outputs:
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
- Universal: `flutter build apk --release` -> `app-release.apk`

---

## 3. Firebase Deployment

Deploy Firestore rules and composite query indexes:
```bash
cd firebase
firebase use --add your-project-id
firebase deploy --only firestore:rules,firestore:indexes
```

---

## 4. n8n AI Marketing Pipeline Cloud Deployment

To run the n8n automation 24/7 on a cloud VPS (DigitalOcean, AWS EC2, or Hetzner):
1. Copy the `automation/` directory to your cloud server:
   ```bash
   scp -r automation/ user@your-server-ip:/opt/aquapure-automation
   ```
2. SSH into your server:
   ```bash
   cd /opt/aquapure-automation
   cp .env.example .env
   # Add your Meta Instagram Token, Cloudinary, and LLM API keys
   ```
3. Run with Docker Compose:
   ```bash
   docker compose up -d
   ```
4. Verify execution:
   ```bash
   docker compose logs -f n8n
   ```
5. The Schedule Trigger runs daily at `09:00 AM IST` automatically.
