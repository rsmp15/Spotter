"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.supabaseAdmin = void 0;
exports.generateSupabaseUserToken = generateSupabaseUserToken;
const supabase_js_1 = require("@supabase/supabase-js");
const crypto_1 = __importDefault(require("crypto"));
const env_js_1 = require("./env.js");
// Supabase Admin Client (bypasses RLS)
exports.supabaseAdmin = (0, supabase_js_1.createClient)(env_js_1.env.SUPABASE_URL, env_js_1.env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: {
        persistSession: false,
        autoRefreshToken: false,
    },
});
/**
 * Generates a custom JWT signed with Supabase JWT Secret.
 * This token can be used by the Flutter app client to authenticate directly with Supabase
 * (e.g. for Storage, Realtime subscriptions) and evaluate RLS policies.
 */
function generateSupabaseUserToken(userId, expiresSeconds = 60 * 60 * 24 * 7) {
    const header = {
        alg: 'HS256',
        typ: 'JWT',
    };
    const now = Math.floor(Date.now() / 1000);
    const payload = {
        role: 'authenticated',
        iss: 'supabase',
        aud: 'authenticated',
        sub: userId,
        exp: now + expiresSeconds,
        iat: now,
    };
    const base64UrlEncode = (obj) => {
        return Buffer.from(JSON.stringify(obj))
            .toString('base64')
            .replace(/=/g, '')
            .replace(/\+/g, '-')
            .replace(/\//g, '_');
    };
    const encodedHeader = base64UrlEncode(header);
    const encodedPayload = base64UrlEncode(payload);
    const signature = crypto_1.default
        .createHmac('sha256', env_js_1.env.SUPABASE_JWT_SECRET)
        .update(`${encodedHeader}.${encodedPayload}`)
        .digest('base64')
        .replace(/=/g, '')
        .replace(/\+/g, '-')
        .replace(/\//g, '_');
    return `${encodedHeader}.${encodedPayload}.${signature}`;
}
