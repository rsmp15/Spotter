-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table (decoupled from auth.users, using firebase_uid for mapping)
CREATE TABLE users (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  firebase_uid    TEXT UNIQUE NOT NULL,
  name            TEXT NOT NULL,
  phone           TEXT UNIQUE NOT NULL,
  email           TEXT,
  profile_image   TEXT,
  rating          DECIMAL(3,2) DEFAULT 5.00,
  role            TEXT DEFAULT 'user',   -- 'user' | 'rider'
  kyc_status      TEXT DEFAULT 'not_started', -- 'not_started' | 'pending' | 'verified' | 'rejected'
  wallet_balance  INTEGER DEFAULT 0,  -- in paise (1 INR = 100 paise)
  fcm_token       TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Driver KYC / Verification
CREATE TABLE driver_verifications (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  dl_number     TEXT NOT NULL,
  dl_image_url  TEXT,
  status        TEXT DEFAULT 'pending',  -- pending | submitted | verified | rejected
  admin_note    TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Vehicles
CREATE TABLE vehicles (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vehicle_type    TEXT NOT NULL,  -- 'car' | 'bike' | 'auto'
  vehicle_number  TEXT UNIQUE NOT NULL,
  vehicle_model   TEXT NOT NULL,
  rc_image_url    TEXT,
  insurance_url   TEXT,
  status          TEXT DEFAULT 'pending', -- pending | verified | rejected
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Trips (posted by travelers/drivers)
CREATE TABLE trips (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  traveler_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  vehicle_id      UUID REFERENCES vehicles(id) ON DELETE SET NULL,
  source          TEXT NOT NULL,
  source_lat      DECIMAL(10,7) NOT NULL,
  source_lng      DECIMAL(10,7) NOT NULL,
  destination     TEXT NOT NULL,
  dest_lat        DECIMAL(10,7) NOT NULL,
  dest_lng        DECIMAL(10,7) NOT NULL,
  departure_time  TIMESTAMPTZ NOT NULL,
  available_seats INTEGER NOT NULL,
  price_per_seat  INTEGER NOT NULL,  -- in paise
  parcel_allowed  BOOLEAN DEFAULT false,
  status          TEXT DEFAULT 'active',  -- active | in_progress | completed | cancelled
  polyline        TEXT,   -- encoded route polyline
  distance_km     DECIMAL(6,1),
  duration_min    INTEGER,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Trip Requests (by passengers)
CREATE TABLE trip_requests (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id         UUID NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
  passenger_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  seats_requested INTEGER DEFAULT 1,
  total_amount    INTEGER NOT NULL,  -- in paise
  status          TEXT DEFAULT 'pending',  -- pending | accepted | rejected | cancelled
  payment_status  TEXT DEFAULT 'pending',  -- pending | paid | refunded
  stripe_payment_intent_id TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Parcels
CREATE TABLE parcels (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  trip_id         UUID REFERENCES trips(id) ON DELETE SET NULL,
  traveler_id     UUID REFERENCES users(id) ON DELETE SET NULL,
  weight_kg       DECIMAL(5,2),
  description     TEXT,
  photo_url       TEXT,
  amount          INTEGER NOT NULL,  -- in paise
  pickup_otp      TEXT NOT NULL,
  delivery_otp    TEXT NOT NULL,
  status          TEXT DEFAULT 'created', -- created | picked_up | delivered | cancelled
  payment_status  TEXT DEFAULT 'pending', -- pending | paid | refunded
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Wallet Transactions
CREATE TABLE wallet_transactions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount        INTEGER NOT NULL, -- positive for credit, negative for debit
  type          TEXT NOT NULL,  -- 'credit' | 'debit'
  source        TEXT NOT NULL,  -- 'stripe' | 'refund' | 'booking' | 'payout'
  reference_id  TEXT,           -- references stripe payment intent, trip request id, etc.
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Reviews
CREATE TABLE reviews (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reviewer_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  reviewed_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  trip_id           UUID REFERENCES trips(id) ON DELETE SET NULL,
  rating            DECIMAL(2,1) NOT NULL,
  comment           TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  body        TEXT NOT NULL,
  type        TEXT,  -- 'trip_request' | 'accepted' | 'payment' | 'parcel'
  data        JSONB DEFAULT '{}',
  read        BOOLEAN DEFAULT false,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Support Tickets
CREATE TABLE support_tickets (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subject     TEXT NOT NULL,
  status      TEXT DEFAULT 'open', -- open | resolved | closed
  messages    JSONB DEFAULT '[]', -- array of chat messages
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Create Indexes for performance
CREATE INDEX idx_users_firebase_uid ON users(firebase_uid);
CREATE INDEX idx_trips_traveler ON trips(traveler_id);
CREATE INDEX idx_trips_geo ON trips(source_lat, source_lng, dest_lat, dest_lng);
CREATE INDEX idx_trip_requests_trip ON trip_requests(trip_id);
CREATE INDEX idx_trip_requests_passenger ON trip_requests(passenger_id);
CREATE INDEX idx_parcels_sender ON parcels(sender_id);
CREATE INDEX idx_parcels_trip ON parcels(trip_id);
CREATE INDEX idx_wallet_tx_user ON wallet_transactions(user_id);
CREATE INDEX idx_reviews_reviewed ON reviews(reviewed_user_id);
CREATE INDEX idx_notifications_user_unread ON notifications(user_id) WHERE read = false;

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE driver_verifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE trip_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE parcels ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;

-- Create Policies for RLS
-- Note: Since the backend API handles database changes using service-role/admin permissions,
-- RLS policies are primarily defined to protect data when client reads directly (e.g. via realtime/subscriptions)
-- or if the client makes direct reads using a custom Supabase token.

-- Users policies: Anyone authenticated can read basic user info (name, photo, rating, role), but only the user themselves can read/write full profile details.
CREATE POLICY "Allow public read of basic user profiles" ON users 
  FOR SELECT USING (true);

CREATE POLICY "Allow users to manage their own profile" ON users 
  FOR ALL USING (auth.uid() = id);

-- Trips policies: Anyone can search/read active trips, but only the traveler can manage their own trips.
CREATE POLICY "Allow anyone to read active trips" ON trips 
  FOR SELECT USING (status = 'active');

CREATE POLICY "Allow travelers to manage their own trips" ON trips 
  FOR ALL USING (auth.uid() = traveler_id);

-- Trip Requests policies: Passenger can read/manage their own requests. Driver of the trip can read requests for their trip.
CREATE POLICY "Allow passengers to manage their own requests" ON trip_requests 
  FOR ALL USING (auth.uid() = passenger_id);

CREATE POLICY "Allow drivers to view requests for their trips" ON trip_requests 
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM trips 
      WHERE trips.id = trip_requests.trip_id AND trips.traveler_id = auth.uid()
    )
  );

-- Parcels policies: Sender and traveler can view/manage their parcels.
CREATE POLICY "Allow senders to manage their parcels" ON parcels 
  FOR ALL USING (auth.uid() = sender_id);

CREATE POLICY "Allow travelers to view/update assigned parcels" ON parcels 
  FOR SELECT USING (auth.uid() = traveler_id);

-- Wallet Transactions policies: Users can only read their own transactions.
CREATE POLICY "Allow users to view their own transactions" ON wallet_transactions 
  FOR SELECT USING (auth.uid() = user_id);

-- Notifications policies: Users can only read/update their own notifications.
CREATE POLICY "Allow users to manage their own notifications" ON notifications 
  FOR ALL USING (auth.uid() = user_id);

-- Reviews policies: Anyone can read reviews, but only the reviewer can create/edit.
CREATE POLICY "Allow public read of reviews" ON reviews 
  FOR SELECT USING (true);

CREATE POLICY "Allow reviewer to manage reviews" ON reviews 
  FOR ALL USING (auth.uid() = reviewer_id);

-- Payouts Table (for tracking driver payouts)
CREATE TABLE payouts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount        INTEGER NOT NULL, -- in paise
  status        TEXT DEFAULT 'pending', -- 'pending' | 'paid' | 'failed'
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_payouts_driver ON payouts(driver_id);

ALTER TABLE payouts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow users to view their own payouts" ON payouts 
  FOR SELECT USING (auth.uid() = driver_id);

-- Remote Config Table
CREATE TABLE remote_configs (
  key           TEXT PRIMARY KEY,
  value         JSONB NOT NULL,
  type          TEXT NOT NULL, -- 'boolean' | 'string' | 'number'
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE remote_configs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read of remote configs" ON remote_configs 
  FOR SELECT USING (true);

-- Add current location coordinates to trips for real-time tracking
ALTER TABLE trips ADD COLUMN IF NOT EXISTS current_lat DECIMAL(10,7);
ALTER TABLE trips ADD COLUMN IF NOT EXISTS current_lng DECIMAL(10,7);



