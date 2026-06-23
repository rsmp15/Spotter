import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
import path from 'path';

// Load env variables from backend .env
dotenv.config({ path: path.resolve(__dirname, '../.env') });

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    persistSession: false,
    autoRefreshToken: false,
  },
});

async function seedAdmin() {
  const email = 'admin@spotter.com';
  const password = 'admin123'; // Standard admin password for dev/prod seed

  console.log(`Creating admin user: ${email}...`);

  // 1. Create user in Supabase Auth
  const { data: authUser, error: authError } = await supabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
    user_metadata: { role: 'admin' },
  });

  if (authError) {
    if (authError.message.includes('already exists') || authError.message.includes('already registered')) {
      console.log('ℹ️ Admin user already exists in Supabase Auth.');
    } else {
      console.error('❌ Error creating Auth user:', authError.message);
      process.exit(1);
    }
  } else {
    console.log('✅ Admin user created in Supabase Auth successfully:', authUser.user?.id);
  }

  // 2. Also ensure they are in the public.users table (optional, but good for references)
  // Let's get the user ID. If it's already there or newly created, sync it.
  const adminAuthId = authUser.user?.id;
  if (adminAuthId) {
    const { data: existingUser } = await supabase
      .from('users')
      .select('id')
      .eq('firebase_uid', adminAuthId)
      .single();

    if (!existingUser) {
      const { error: dbError } = await supabase.from('users').insert({
        firebase_uid: adminAuthId,
        name: 'Spotter Admin',
        phone: '+910000000000', // Placeholders for admin profile
        email: email,
        role: 'admin',
        kyc_status: 'verified',
        wallet_balance: 0,
      });

      if (dbError) {
        console.error('❌ Error inserting admin into public.users table:', dbError.message);
      } else {
        console.log('✅ Admin synced to public.users table.');
      }
    } else {
      console.log('ℹ️ Admin already synced in public.users table.');
    }
  }
}

seedAdmin().catch((err) => {
  console.error('❌ Seed failed:', err);
  process.exit(1);
});
