"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const morgan_1 = __importDefault(require("morgan"));
const env_js_1 = require("./config/env.js");
const error_middleware_js_1 = require("./middleware/error.middleware.js");
const supabase_js_1 = require("./config/supabase.js");
const auth_routes_js_1 = __importDefault(require("./modules/auth/auth.routes.js"));
const kyc_routes_js_1 = __importDefault(require("./modules/kyc/kyc.routes.js"));
const trips_routes_js_1 = __importDefault(require("./modules/trips/trips.routes.js"));
const app = (0, express_1.default)();
// Security Middlewares
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)({
    origin: '*', // For production, specify origins (e.g. Flutter app deep link/web domains)
    credentials: true,
}));
// Request Logging & Parsing
app.use((0, morgan_1.default)(env_js_1.env.NODE_ENV === 'development' ? 'dev' : 'combined'));
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
// Basic Health Check Endpoint
app.get('/health', async (req, res) => {
    try {
        // Ping Supabase to verify connectivity
        const startTime = Date.now();
        const { error } = await supabase_js_1.supabaseAdmin.from('users').select('id').limit(1);
        const latency = Date.now() - startTime;
        if (error) {
            throw error;
        }
        return res.status(200).json({
            status: 'ok',
            version: '1.0.0',
            database: 'connected',
            latency: `${latency}ms`,
        });
    }
    catch (error) {
        console.error('Health check failed:', error);
        return res.status(500).json({
            status: 'error',
            database: 'disconnected',
            error: error.message || error,
        });
    }
});
// Register Module Routes
app.use('/api/auth', auth_routes_js_1.default);
app.use('/api/kyc', kyc_routes_js_1.default);
app.use('/api/trips', trips_routes_js_1.default);
// Global Error Handler (must be registered last)
app.use(error_middleware_js_1.errorHandler);
// Start Server
const port = env_js_1.env.PORT;
app.listen(port, () => {
    console.log(`🚀 Spotter API running on port ${port} in ${env_js_1.env.NODE_ENV} mode`);
});
exports.default = app;
