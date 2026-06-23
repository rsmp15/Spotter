import { Request, Response } from 'express';
import { supabaseAdmin, generateSupabaseUserToken } from '../../config/supabase.js';
import { z } from 'zod';

export const syncUserSchema = z.object({
  body: z.object({
    name: z.string().min(2, 'Name must be at least 2 characters').optional(),
    email: z.string().email('Invalid email address').optional().nullable(),
    fcmToken: z.string().optional().nullable(),
  }),
});

export async function syncUser(req: Request, res: Response) {
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

      const { data: newUser, error: insertError } = await supabaseAdmin
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

      user = newUser as any;
    } else {
      // Update existing user profile if name, email or fcmToken are provided
      const updates: any = {};
      if (name) updates.name = name;
      if (email !== undefined) updates.email = email;
      if (fcmToken !== undefined) updates.fcm_token = fcmToken;
      updates.updated_at = new Date().toISOString();

      if (Object.keys(updates).length > 1) { // more than just updated_at
        const { data: updatedUser, error: updateError } = await supabaseAdmin
          .from('users')
          .update(updates)
          .eq('firebase_uid', firebaseUid)
          .select('*')
          .single();

        if (updateError) {
          console.error('Error updating user:', updateError);
          return res.status(500).json({ error: 'Failed to update user profile' });
        }
        
        user = updatedUser as any;
      }
    }

    // Generate custom token for Supabase client
    const supabaseToken = generateSupabaseUserToken(user!.id);

    return res.status(200).json({
      user,
      supabase_token: supabaseToken,
    });
  } catch (error: any) {
    console.error('Sync error:', error);
    return res.status(500).json({ error: 'Internal server error during synchronization' });
  }
}

export async function getMe(req: Request, res: Response) {
  try {
    if (!req.user) {
      return res.status(404).json({ error: 'User profile not found' });
    }

    const supabaseToken = generateSupabaseUserToken(req.user.id);

    return res.status(200).json({
      user: req.user,
      supabase_token: supabaseToken,
    });
  } catch (error: any) {
    console.error('GetMe error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
