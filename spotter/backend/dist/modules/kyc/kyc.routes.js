"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const kyc_controller_js_1 = require("./kyc.controller.js");
const router = (0, express_1.Router)();
// In production, you'd add middleware here to authorize only admin roles.
// Since the admin panel is a private internal tool talking to backend, we can keep it open or add basic token/key check.
router.post('/approve', kyc_controller_js_1.approveKyc);
router.post('/reject', kyc_controller_js_1.rejectKyc);
exports.default = router;
