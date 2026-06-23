import { Router } from 'express';
import { approveKyc, rejectKyc } from './kyc.controller.js';

const router = Router();

// In production, you'd add middleware here to authorize only admin roles.
// Since the admin panel is a private internal tool talking to backend, we can keep it open or add basic token/key check.
router.post('/approve', approveKyc);
router.post('/reject', rejectKyc);

export default router;
