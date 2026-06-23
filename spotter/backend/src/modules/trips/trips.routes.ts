import { Router } from 'express';
import { authenticate } from '../../middleware/auth.middleware.js';
import {
  createTrip,
  searchTrips,
  getTrip,
  updateTripStatus,
  updateLocation,
} from './trips.controller.js';

const router = Router();

// Create a trip (requires auth)
router.post('/', authenticate, createTrip);

// Search trips
router.get('/search', searchTrips);

// Get trip details
router.get('/:id', getTrip);

// Update trip status (requires auth)
router.put('/:id/status', authenticate, updateTripStatus);

// Update location of a trip (requires auth)
router.put('/:id/location', authenticate, updateLocation);

export default router;
