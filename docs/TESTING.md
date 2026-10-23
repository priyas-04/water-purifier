# AquaPure: Comprehensive Testing & Verification Guide

This document describes all automated and manual test suites across Mobile, Admin Web, Firebase Security, and AI Marketing Automation.

---

## 1. Automated Test Suites

### A. Mobile Unit Tests (`mobile/water_purifier_app/test/`)
Run using:
```bash
cd mobile/water_purifier_app
flutter test
```

Test coverage includes:
- **`cart_test.dart`**:
  - Validates retail price unit assignment for regular customers.
  - Validates wholesale price assignment for approved dealers.
  - Validates dynamic subtotal, delivery charges threshold (Free delivery above ₹1500, else ₹99), and total calculation.
  - Validates instant price recalculation when a customer logs in as an approved dealer.
- **`product_model_test.dart`**:
  - Validates JSON serialization and deserialization of the 60 product schema.
  - Validates `isLowStock` indicator (flagged when stock <= 10).
  - Validates `inStock` boolean logic when quantity is zero.
- **`auth_role_test.dart`**:
  - Validates default `dealerStatus = none` for registered retail customers.
  - Validates security invariant: `pending` dealers CANNOT access wholesale tier pricing.
  - Validates `approved` dealers unlock wholesale permissions.

### B. Admin Web Dashboard Verification
Run using:
```bash
cd admin/admin-panel
npm run build
```
Validates:
- Strict TypeScript compile-time type checking.
- Zero unused variable or broken import errors.
- Production bundle optimization via Vite.

### C. Marketing Automation Verification
Run using:
```bash
node automation/test-workflow.js
```
Validates:
- n8n workflow JSON structure and syntax validity.
- Deterministic rotation sorting (picks product with lowest `posted_count`).
- LLM prompt construction and hashtag compliance (3-6 tags).
- Public HTTPS media URL accessibility.
- Instagram Graph API Media Container & Publishing payloads.
- WAHA WhatsApp Status API broadcast payload.
- Firestore audit logging payload schema.

---

## 2. Firebase Security Rules Invariants

The rules defined in `firebase/firestore.rules` enforce:
1. **Private User Data Isolation**:
   - `match /users/{userId}`: Users can only read and update their own document, unless caller has `admin` custom claim or `role == 'admin'`.
2. **Role Self-Elevation Guard**:
   - Creating a user document with `role == 'admin'` is rejected.
   - Updating `role` or `dealerStatus` fields by non-admin users is strictly rejected via `!affectedKeys().hasAny(['role', 'dealerStatus', 'uid'])`.
3. **Wholesale Order Authorization Guard**:
   - Creating an order with `role == 'dealer'` requires that `getUserData().dealerStatus == 'approved'`.
   - Pending and rejected dealers cannot place wholesale orders.
4. **Order Status Tampering Guard**:
   - Order status progression (`confirmed`, `processing`, `shipped`, `delivered`) can only be modified by admins.
   - Customers can only cancel orders in `placed` status.
5. **Catalogue Write Protection**:
   - Products are publicly readable, but write/update/delete operations are restricted to admins.

---

## 3. Manual Functional Verification Checklist

| Component | Test Case | Expected Result | Verified Status |
| :--- | :--- | :--- | :--- |
| **Mobile Auth** | Register customer with valid details | User profile created with `customer` role and unique referral code |  Verified |
| **Mobile Auth** | Register commercial dealer with GSTIN | Dealer record created with `dealerStatus = pending` |  Verified |
| **Mobile Auth** | Evaluator Role Switcher | Switch between Customer, Approved Dealer, Pending Dealer in 1 click |  Verified |
| **Catalogue** | Browse 60 products across 5 categories | Purifiers (15), Dispensers (10), Pumps (10), Filters (15), Spares (10) |  Verified |
| **Catalogue** | Live Search & Filter | Typing "Copper" filters items; category pills filter instantly |  Verified |
| **Pricing** | Customer vs Dealer view | Customer sees Retail; Approved dealer sees Wholesale with savings badge |  Verified |
| **Cart** | Add items, change quantity | Subtotal updates dynamically; Free shipping applied above ₹1500 |  Verified |
| **Checkout** | Razorpay Test Mode checkout | Safe simulation records mock transaction reference and marks order paid |  Verified |
| **Checkout** | Address Selection | Select saved address or search area using OpenStreetMap geocoding |  Verified |
| **Orders** | Order Tracking Timeline | 5-stage tracker (`placed` -> `confirmed` -> `processing` -> `shipped` -> `delivered`) |  Verified |
| **Orders** | Order Cancellation | Cancellation enabled when order is in `placed` status |  Verified |
| **Service** | Book Service Appointment | Service request created with date, slot, address, and issue note |  Verified |
| **Admin** | Dashboard Overview | Live KPI cards, recent orders, and pending dealers summary |  Verified |
| **Admin** | Product Management | Add product modal, edit details, stock level +/- adjustment, active toggle |  Verified |
| **Admin** | Order Processing | Filter orders by status, change status via dropdown, view item details modal |  Verified |
| **Admin** | Dealer Approvals | Approve or reject pending applications with confirmation dialog |  Verified |
| **Admin** | Service Desk | Assign technician name, contact, and internal dispatch instructions |  Verified |
| **Automation** | AI Marketing Trigger | "Trigger Live Test Post" executes pipeline and records audit log |  Verified |
