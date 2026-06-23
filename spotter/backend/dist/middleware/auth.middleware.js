"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.authenticate = authenticate;
const firebase_js_1 = require("../config/firebase.js");
const supabase_js_1 = require("../config/supabase.js");
async function authenticate(req, res, next) {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ error: 'Unauthorized: No token provided' });
        }
        const token = authHeader.split('Bearer ')[1];
        // Verify Firebase JWT
        const decodedToken = await firebase_js_1.firebaseAuth.verifyIdToken(token);
        req.firebaseUser = decodedToken;
        // Retrieve corresponding Supabase user
        const { data: user, error } = await supabase_js_1.supabaseAdmin
            .from('users')
            .select('*')
            .eq('firebase_uid', decodedToken.uid)
            .single();
        if (error && error.code !== 'PGRST116') { // PGRST116 is PostgreSQL "no rows returned"
            console.error('Database error fetching user:', error);
            return res.status(500).json({ error: 'Internal server error' });
        }
        if (user) {
            req.user = user;
        }
        else {
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
    }
    catch (error) {
        console.error('Authentication error:', error.message || error);
        return res.status(401).json({ error: 'Unauthorized: Invalid token' });
    }
}
