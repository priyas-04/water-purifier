/**
 * AquaPure Firestore Database Seeding Script
 * 
 * Safely populates Cloud Firestore with 60 catalogue products and handles
 * secure initial admin creation using the Firebase Admin SDK.
 * 
 * Usage:
 *   node seed.js [--dry-run] [--create-admin <email> <fullName>]
 */

const fs = require('fs');
const path = require('path');

const productsFilePath = path.join(__dirname, 'products.json');
const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');

const args = process.argv.slice(2);
const isDryRun = args.includes('--dry-run');
const adminIdx = args.indexOf('--create-admin');

async function main() {
  console.log('--- AquaPure Product Seeder & Admin Bootstrap ---');

  if (!fs.existsSync(productsFilePath)) {
    console.error(`Error: Products file not found at ${productsFilePath}`);
    process.exit(1);
  }

  const rawData = fs.readFileSync(productsFilePath, 'utf8');
  const products = JSON.parse(rawData);
  console.log(`Loaded ${products.length} products from products.json.`);

  // Validation
  const categories = {};
  for (const p of products) {
    if (!p.id || !p.name || !p.category || !p.retailPrice || !p.wholesalePrice || !p.imageUrl) {
      console.error(`Validation Error: Product ${p.id || 'unknown'} missing required fields!`);
      process.exit(1);
    }
    categories[p.category] = (categories[p.category] || 0) + 1;
  }
  console.log('Category distribution:');
  Object.entries(categories).forEach(([cat, count]) => {
    console.log(`  - ${cat}: ${count}`);
  });

  if (isDryRun || !fs.existsSync(serviceAccountPath)) {
    console.log('\n[INFO] Running in SAFE / VALIDATION mode.');
    if (!fs.existsSync(serviceAccountPath)) {
      console.log('No serviceAccountKey.json detected in product-data/. All 60 products validated successfully.');
      console.log('To write to live Firestore, place your Firebase serviceAccountKey.json in this directory and re-run.');
    } else {
      console.log('Dry run complete. No database changes were made.');
    }
    return;
  }

  // Live Firebase Admin SDK Execution
  let admin;
  try {
    admin = require('firebase-admin');
  } catch (err) {
    console.error('firebase-admin package not found. Run `npm install firebase-admin` in this folder first.');
    process.exit(1);
  }

  const serviceAccount = require(serviceAccountPath);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });

  const db = admin.firestore();
  console.log('\nConnected to Firestore. Beginning batch write for 60 products...');

  // Firestore allows up to 500 writes per batch. 60 products fits in a single batch.
  const batch = db.batch();
  for (const product of products) {
    const docRef = db.collection('products').doc(product.id);
    batch.set(docRef, {
      ...product,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    }, { merge: true });
  }

  await batch.commit();
  console.log(' Successfully seeded 60 products to Firestore collection "products"!');

  // Handle Initial Admin Creation if requested
  if (adminIdx !== -1 && args[adminIdx + 1]) {
    const adminEmail = args[adminIdx + 1];
    const adminName = args[adminIdx + 2] || 'AquaPure Admin';
    console.log(`\nBootstrapping admin user for ${adminEmail}...`);

    try {
      let userRecord;
      try {
        userRecord = await admin.auth().getUserByEmail(adminEmail);
      } catch (e) {
        // Create user if doesn't exist
        userRecord = await admin.auth().createUser({
          email: adminEmail,
          displayName: adminName,
          emailVerified: true
        });
        console.log(`Created new Auth user with UID: ${userRecord.uid}`);
      }

      await admin.auth().setCustomUserClaims(userRecord.uid, { role: 'admin' });
      await db.collection('users').doc(userRecord.uid).set({
        uid: userRecord.uid,
        email: adminEmail,
        fullName: adminName,
        role: 'admin',
        dealerStatus: 'none',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });

      console.log(` Admin user ${adminEmail} successfully configured with admin role!`);
    } catch (authErr) {
      console.error('Failed to create/assign admin user:', authErr.message);
    }
  }

  console.log('\nSeeding operation completed.');
  process.exit(0);
}

main().catch(err => {
  console.error('Fatal error during seed execution:', err);
  process.exit(1);
});
