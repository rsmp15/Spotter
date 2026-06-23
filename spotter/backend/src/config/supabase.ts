import { createClient } from '@supabase/supabase-js';
import crypto from 'crypto';
import { env } from './env.js';

// Supabase Admin Client (bypasses RLS)
export const supabaseAdmin = createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
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
export function generateSupabaseUserToken(userId: string, expiresSeconds: number = 60 * 60 * 24 * 7): string {
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

  const base64UrlEncode = (obj: any): string => {
    return Buffer.from(JSON.stringify(obj))
      .toString('base64')
      .replace(/=/g, '')
      .replace(/\+/g, '-')
      .replace(/\//g, '_');
  };

  const encodedHeader = base64UrlEncode(header);
  const encodedPayload = base64UrlEncode(payload);

  const signature = crypto
    .createHmac('sha256', env.SUPABASE_JWT_SECRET)
    .update(`${encodedHeader}.${encodedPayload}`)
    .digest('base64')
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_');

  return `${encodedHeader}.${encodedPayload}.${signature}`;
}
