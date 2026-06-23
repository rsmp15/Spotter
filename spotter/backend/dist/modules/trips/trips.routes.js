"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_middleware_js_1 = require("../../middleware/auth.middleware.js");
const trips_controller_js_1 = require("./trips.controller.js");
const router = (0, express_1.Router)();
// Create a trip (requires auth)
router.post('/', auth_middleware_js_1.authenticate, trips_controller_js_1.createTrip);
// Search trips
router.get('/search', trips_controller_js_1.searchTrips);
// Get trip details
router.get('/:id', trips_controller_js_1.getTrip);
// Update trip status (requires auth)
router.put('/:id/status', auth_middleware_js_1.authenticate, trips_controller_js_1.updateTripStatus);
// Update location of a trip (requires auth)
router.put('/:id/location', auth_middleware_js_1.authenticate, trips_controller_js_1.updateLocation);
exports.default = router;
