"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.firebaseMessaging = exports.firebaseAuth = exports.firebaseAdmin = void 0;
const firebase_admin_1 = __importDefault(require("firebase-admin"));
const env_js_1 = require("./env.js");
// Initialize Firebase Admin SDK
firebase_admin_1.default.initializeApp({
    credential: firebase_admin_1.default.credential.cert({
        projectId: env_js_1.env.FIREBASE_PROJECT_ID,
        clientEmail: env_js_1.env.FIREBASE_CLIENT_EMAIL,
        privateKey: env_js_1.env.FIREBASE_PRIVATE_KEY,
    }),
});
exports.firebaseAdmin = firebase_admin_1.default;
exports.firebaseAuth = firebase_admin_1.default.auth();
exports.firebaseMessaging = firebase_admin_1.default.messaging();
