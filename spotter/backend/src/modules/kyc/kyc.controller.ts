import { Request, Response, NextFunction } from 'express';
import { supabaseAdmin } from '../../config/supabase.js';
import { firebaseMessaging } from '../../config/firebase.js';

export async function approveKyc(req: Request, res: Response, next: NextFunction) {
  try {
    const { userId } = req.body;
    if (!userId) {
      return res.status(400).json({ error: 'userId is required' });
    }

    // 1. Update user role and KYC status
    const { data: user, error: userError } = await supabaseAdmin
      .from('users')
      .update({ kyc_status: 'verified', role: 'rider' })
      .eq('id', userId)
      .select('fcm_token, name')
      .single();

    if (userError) throw userError;

    // 2. Update driver_verifications status
    await supabaseAdmin
      .from('driver_verifications')
      .update({ status: 'verified' })
      .eq('user_id', userId);

    // 3. Update vehicles status
    await supabaseAdmin
      .from('vehicles')
      .update({ status: 'verified' })
      .eq('user_id', userId);

    // 4. Send FCM Push Notification
    if (user && user.fcm_token) {
      try {
        await firebaseMessaging.send({
          token: user.fcm_token,
          notification: {
            title: 'KYC Verified!',
            body: 'Congratulations! Your profile and documents have been verified. You can now accept rides.',
          },
          data: {
            type: 'kyc_status',
            status: 'verified',
          },
        });
        console.log(`FCM sent to verified user ${userId}`);
      } catch (fcmErr) {
        console.error('Error sending FCM push:', fcmErr);
      }
    }

    // Also add to notifications table
    await supabaseAdmin.from('notifications').insert({
      user_id: userId,
      title: 'KYC Verified!',
      body: 'Congratulations! Your profile and documents have been verified. You can now accept rides.',
      type: 'kyc_status',
      data: { status: 'verified' },
    });

    return res.status(200).json({ success: true, message: 'KYC approved and FCM sent' });
  } catch (error) {
    next(error);
  }
}

export async function rejectKyc(req: Request, res: Response, next: NextFunction) {
  try {
    const { userId, reason } = req.body;
    if (!userId || !reason) {
      return res.status(400).json({ error: 'userId and reason are required' });
    }

    // 1. Update user KYC status
    const { data: user, error: userError } = await supabaseAdmin
      .from('users')
      .update({ kyc_status: 'rejected' })
      .eq('id', userId)
      .select('fcm_token, name')
      .single();

    if (userError) throw userError;

    // 2. Update driver_verifications status and admin note
    await supabaseAdmin
      .from('driver_verifications')
      .update({ status: 'rejected', admin_note: reason })
      .eq('user_id', userId);

    // 3. Send FCM Push Notification
    if (user && user.fcm_token) {
      try {
        await firebaseMessaging.send({
          token: user.fcm_token,
          notification: {
            title: 'KYC Documents Rejected',
            body: `Verification rejected: ${reason}. Please update your documents.`,
          },
          data: {
            type: 'kyc_status',
            status: 'rejected',
            reason,
          },
        });
        console.log(`FCM sent to rejected user ${userId}`);
      } catch (fcmErr) {
        console.error('Error sending FCM push:', fcmErr);
      }
    }

    // Also add to notifications table
    await supabaseAdmin.from('notifications').insert({
      user_id: userId,
      title: 'KYC Documents Rejected',
      body: `Verification rejected: ${reason}. Please update your documents.`,
      type: 'kyc_status',
      data: { status: 'rejected', reason },
    });

    return res.status(200).json({ success: true, message: 'KYC rejected and FCM sent' });
  } catch (error) {
    next(error);
  }
}
