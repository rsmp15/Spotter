import { Request, Response, NextFunction } from 'express';
import { firebaseAuth } from '../config/firebase.js';
import { supabaseAdmin } from '../config/supabase.js';

interface SupabaseUser {
  id: string;
  firebase_uid: string;
  name: string;
  phone: string;
  email: string | null;
  role: string;
  kyc_status: string;
  wallet_balance: number;
  fcm_token: string | null;
}

declare global {
  namespace Express {
    interface Request {
      firebaseUser?: any;
      user?: SupabaseUser;
    }
  }
}

export async function authenticate(req: Request, res: Response, next: NextFunction) {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'Unauthorized: No token provided' });
    }

    const token = authHeader.split('Bearer ')[1];
    
    // Verify Firebase JWT
    const decodedToken = await firebaseAuth.verifyIdToken(token);
    req.firebaseUser = decodedToken;

    // Retrieve corresponding Supabase user
    const { data: user, error } = await supabaseAdmin
      .from('users')
      .select('*')
      .eq('firebase_uid', decodedToken.uid)
      .single();

    if (error && error.code !== 'PGRST116') { // PGRST116 is PostgreSQL "no rows returned"
      console.error('Database error fetching user:', error);
      return res.status(500).json({ error: 'Internal server error' });
    }

    if (user) {
      req.user = user as SupabaseUser;
    } else {
      // If user does not exist in DB, only allow access to the sync endpoint
      const isSyncRoute = req.path === '/auth/sync' && req.method === 'POST';
      if (!isSyncRoute) {
        return res.status(403).json({ 
          error: 'Forbidden: Profile synchronization required',
          code: 'SYNC_REQUIRED'
        });
      }
    }

    next();
  } catch (error: any) {
    console.error('Authentication error:', error.message || error);
    return res.status(401).json({ error: 'Unauthorized: Invalid token' });
  }
}
