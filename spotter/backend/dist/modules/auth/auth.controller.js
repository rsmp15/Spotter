"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.syncUserSchema = void 0;
exports.syncUser = syncUser;
exports.getMe = getMe;
const supabase_js_1 = require("../../config/supabase.js");
const zod_1 = require("zod");
exports.syncUserSchema = zod_1.z.object({
    body: zod_1.z.object({
        name: zod_1.z.string().min(2, 'Name must be at least 2 characters').optional(),
        email: zod_1.z.string().email('Invalid email address').optional().nullable(),
        fcmToken: zod_1.z.string().optional().nullable(),
    }),
});
async function syncUser(req, res) {
    try {
        const firebaseUid = req.firebaseUser.uid;
        const phone = req.firebaseUser.phone_number;
        if (!phone) {
            return res.status(400).json({ error: 'Auth token must contain a verified phone number' });
        }
        const { name, email, fcmToken } = req.body;
        // Check if user already exists
        let user = req.user;
        if (!user) {
            // Create new user in database
            if (!name) {
                return res.status(400).json({ error: 'Name is required for new registration' });
            }
            const { data: newUser, error: insertError } = await supabase_js_1.supabaseAdmin
                .from('users')
                .insert({
                firebase_uid: firebaseUid,
                name,
                phone,
                email: email || null,
                fcm_token: fcmToken || null,
            })
                .select('*')
                .single();
            if (insertError) {
                console.error('Error inserting user:', insertError);
                return res.status(500).json({ error: 'Failed to create user profile' });
            }
            user = newUser;
        }
        else {
            // Update existing user profile if name, email or fcmToken are provided
            const updates = {};
            if (name)
                updates.name = name;
            if (email !== undefined)
                updates.email = email;
            if (fcmToken !== undefined)
                updates.fcm_token = fcmToken;
            updates.updated_at = new Date().toISOString();
            if (Object.keys(updates).length > 1) { // more than just updated_at
                const { data: updatedUser, error: updateError } = await supabase_js_1.supabaseAdmin
                    .from('users')
                    .update(updates)
                    .eq('firebase_uid', firebaseUid)
                    .select('*')
                    .single();
                if (updateError) {
                    console.error('Error updating user:', updateError);
                    return res.status(500).json({ error: 'Failed to update user profile' });
                }
                user = updatedUser;
            }
        }
        // Generate custom token for Supabase client
        const supabaseToken = (0, supabase_js_1.generateSupabaseUserToken)(user.id);
        return res.status(200).json({
            user,
            supabase_token: supabaseToken,
        });
    }
    catch (error) {
        console.error('Sync error:', error);
        return res.status(500).json({ error: 'Internal server error during synchronization' });
    }
}
async function getMe(req, res) {
    try {
        if (!req.user) {
            return res.status(404).json({ error: 'User profile not found' });
        }
        const supabaseToken = (0, supabase_js_1.generateSupabaseUserToken)(req.user.id);
        return res.status(200).json({
            user: req.user,
            supabase_token: supabaseToken,
        });
    }
    catch (error) {
        console.error('GetMe error:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
}
