import { Router } from 'express';
import { authenticate } from '../../middleware/auth.middleware.js';
import { validate } from '../../middleware/validate.middleware.js';
import { syncUser, getMe, syncUserSchema } from './auth.controller.js';

const router = Router();

// Sync user details from Firebase to Supabase DB
router.post('/sync', authenticate, validate(syncUserSchema), syncUser);

// Retrieve currently authenticated user profile
router.get('/me', authenticate, getMe);

export default router;
