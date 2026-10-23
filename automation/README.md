# AquaPure AI Marketing Automation Engine

This directory contains the autonomous marketing automation pipeline for AquaPure. It publishes one promotional product campaign daily to Instagram (and optionally WhatsApp Status) without manual intervention.

---

## 1. System Architecture

```
[Schedule Trigger 09:00 AM IST (Asia/Kolkata)]
                     ↓
[Firestore / CSV Deterministic Product Rotation]
(Sorts by least-posted & least-recently published item)
                     ↓
[LLM Marketing Caption & Hashtag Generation]
(Short hook, verified benefit, call-to-action, 3-6 hashtags)
                     ↓
[AI Product Image Generation (FLUX / DALL-E / CDN Fallback)]
                     ↓
[Cloudinary Public HTTPS CDN Hosting]
                     ↓
┌────────────────────┴────────────────────┐
↓                                         ↓
[Instagram Graph API Publishing]     [WAHA WhatsApp Status (Bonus)]
1. POST /{ig_id}/media (Container)   POST /api/sendImage
2. POST /{ig_id}/media_publish       (Broadcasts to WhatsApp Status)
└────────────────────┬────────────────────┘
                     ↓
[Firestore `automationLogs` Record Update]
[Product `postedCount` & `lastPostedAt` Update]
```

---

## 2. Prerequisites & Accounts

1. **Docker & Docker Compose** installed.
2. **Meta Developer Account**:
   - Facebook Page connected to an Instagram Business or Creator Account.
   - Meta App with `instagram_basic`, `instagram_content_publish`, and `pages_read_engagement` permissions.
   - Long-lived Page Access Token.
3. **Cloudinary Account** (Free tier) for public media CDN hosting.
4. **LLM Provider API Key** (Google Gemini API or OpenAI API).
5. **Hugging Face Token** (Optional, for FLUX / SDXL inference) or public CDN images.
6. **WhatsApp Secondary Phone Number** (Optional, for WAHA WhatsApp Status).

---

## 3. Quick Local Setup

### Step 1: Copy Environment File
```bash
cd automation
cp .env.example .env
```
Fill in your credentials in `.env`.

### Step 2: Start n8n & WAHA via Docker Compose
```bash
docker compose up -d
```

- Access n8n web interface at: `http://localhost:5678`
- Access WAHA web dashboard at: `http://localhost:3000`

### Step 3: Import Workflow into n8n
1. Open `http://localhost:5678` in your browser.
2. Create your local admin user account upon first launch.
3. Click **Workflows** > **Import from File**.
4. Select `automation/n8n-workflow.json`.
5. The full 10-node pipeline will be loaded.

---

## 4. Meta Instagram Graph API Setup

1. Go to [developers.facebook.com](https://developers.facebook.com).
2. Create an App of type **Business**.
3. Under **Add Products**, select **Instagram Graph API**.
4. Link your Facebook Page and associated Instagram Professional Account.
5. In Graph API Explorer, generate a user access token with:
   - `instagram_basic`
   - `instagram_content_publish`
   - `pages_show_list`
   - `pages_read_engagement`
6. Exchange the short-lived token for a long-lived Page Token:
   ```
   GET https://graph.facebook.com/v19.0/oauth/access_token?
     grant_type=fb_exchange_token&
     client_id={app-id}&
     client_secret={app-secret}&
     fb_exchange_token={short-lived-token}
   ```
7. Find your Instagram Business Account ID:
   ```
   GET https://graph.facebook.com/v19.0/me/accounts?access_token={page-token}
   GET https://graph.facebook.com/v19.0/{page-id}?fields=instagram_business_account&access_token={page-token}
   ```
8. Paste `INSTAGRAM_BUSINESS_ACCOUNT_ID` and `INSTAGRAM_PAGE_ACCESS_TOKEN` into `.env`.

---

## 5. Bonus: WAHA WhatsApp Status Setup

1. Open `http://localhost:3000/dashboard`.
2. Click **Start Session** (Session name: `default`).
3. Click **Scan QR Code** and scan the pairing code using your secondary WhatsApp number (`Linked Devices`).
4. Once connected, WAHA will automatically broadcast the daily product image and caption to your WhatsApp Status whenever the daily n8n workflow executes.

---

## 6. Testing & Dry Run

Run the offline automation test suite:
```bash
node automation/test-workflow.js
```

This verifies:
- n8n workflow JSON structure and syntax
- Deterministic rotation sorting
- LLM prompt generation and hashtag count (3-6)
- Public image accessibility
- Instagram media container payload creation
- WAHA broadcast payload format
- Firestore log document creation
