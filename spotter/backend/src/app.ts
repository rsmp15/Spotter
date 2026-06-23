import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { env } from './config/env.js';
import { errorHandler } from './middleware/error.middleware.js';
import { supabaseAdmin } from './config/supabase.js';
import authRoutes from './modules/auth/auth.routes.js';
import kycRoutes from './modules/kyc/kyc.routes.js';
import tripsRoutes from './modules/trips/trips.routes.js';

const app = express();

// Security Middlewares
app.use(helmet());
app.use(cors({
  origin: '*', // For production, specify origins (e.g. Flutter app deep link/web domains)
  credentials: true,
}));

// Request Logging & Parsing
app.use(morgan(env.NODE_ENV === 'development' ? 'dev' : 'combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Basic Health Check Endpoint
app.get('/health', async (req, res) => {
  try {
    // Ping Supabase to verify connectivity
    const startTime = Date.now();
    const { error } = await supabaseAdmin.from('users').select('id').limit(1);
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
  } catch (error: any) {
    console.error('Health check failed:', error);
    return res.status(500).json({
      status: 'error',
      database: 'disconnected',
      error: error.message || error,
    });
  }
});

// Register Module Routes
app.use('/api/auth', authRoutes);
app.use('/api/kyc', kycRoutes);
app.use('/api/trips', tripsRoutes);

// Global Error Handler (must be registered last)
app.use(errorHandler);

// Start Server
const port = env.PORT;
app.listen(port, () => {
  console.log(`🚀 Spotter API running on port ${port} in ${env.NODE_ENV} mode`);
});

export default app;
