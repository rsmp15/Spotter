import admin from 'firebase-admin';
import { env } from './env.js';

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert({
    projectId: env.FIREBASE_PROJECT_ID,
    clientEmail: env.FIREBASE_CLIENT_EMAIL,
    privateKey: env.FIREBASE_PRIVATE_KEY,
  }),
});

export const firebaseAdmin = admin;
export const firebaseAuth = admin.auth();
export const firebaseMessaging = admin.messaging();
