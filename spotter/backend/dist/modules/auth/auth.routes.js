"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_middleware_js_1 = require("../../middleware/auth.middleware.js");
const validate_middleware_js_1 = require("../../middleware/validate.middleware.js");
const auth_controller_js_1 = require("./auth.controller.js");
const router = (0, express_1.Router)();
// Sync user details from Firebase to Supabase DB
router.post('/sync', auth_middleware_js_1.authenticate, (0, validate_middleware_js_1.validate)(auth_controller_js_1.syncUserSchema), auth_controller_js_1.syncUser);
// Retrieve currently authenticated user profile
router.get('/me', auth_middleware_js_1.authenticate, auth_controller_js_1.getMe);
exports.default = router;
