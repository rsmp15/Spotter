import { Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { Sidebar } from './components/Sidebar';
import { RemoteConfigManager } from './views/RemoteConfigManager';
import { UsersView } from './views/UsersView';
import { TripsView } from './views/TripsView';
import { SupportView } from './views/SupportView';
import { Bell, Search } from 'lucide-react';

const PAGE_META: Record<string, { title: string; desc: string }> = {
  users:     { title: 'Users & KYC',       desc: 'Manage riders, drivers and identity verification' },
  trips:     { title: 'Live Dispatch',      desc: 'Monitor active rides and reassign drivers in real-time' },
  support:   { title: 'Support & Safety',   desc: 'Handle rider and driver support tickets' },
  config:    { title: 'Remote Config',      desc: 'Manage dynamic feature flags and configuration' },
  analytics: { title: 'Reports',            desc: 'View analytics and operational metrics' },
};

function App() {
  const location = useLocation();
  const segment = location.pathname.replace('/', '').split('/')[0];
  const meta = PAGE_META[segment] || { title: 'Dashboard', desc: 'Spotter Operations' };

  return (
    <div className="dashboard-shell">
      <Sidebar />

      <main className="main-content">
        {/* ── Topbar ─────────────────────────────── */}
        <header className="topbar">
          {/* Breadcrumb */}
          <div className="topbar-breadcrumb">
            <span className="topbar-breadcrumb-root">Spotter Ops</span>
            <span className="topbar-breadcrumb-sep">/</span>
            <span className="topbar-breadcrumb-current">{meta.title}</span>
          </div>

          {/* Search + actions */}
          <div className="topbar-actions">
            <label className="topbar-search">
              <Search size={14} color="var(--hint)" />
              <input placeholder="Search anything…" />
            </label>

            <button className="topbar-icon-btn" title="Notifications" aria-label="Notifications">
              <Bell size={16} />
              <span className="topbar-notif-dot" />
            </button>
          </div>
        </header>

        {/* ── Content ───────────────────────────── */}
        <div className="content-area">
          <Routes>
            <Route path="/"          element={<Navigate to="/users" replace />} />
            <Route path="/users"     element={<UsersView />} />
            <Route path="/trips"     element={<TripsView />} />
            <Route path="/support"   element={<SupportView />} />
            <Route path="/config"    element={<RemoteConfigManager />} />
            <Route path="/analytics" element={
              <div style={{ padding: '48px', textAlign: 'center', color: 'var(--hint)' }}>
                <p style={{ fontSize: 15 }}>Analytics view coming soon</p>
              </div>
            } />
          </Routes>
        </div>
      </main>
    </div>
  );
}

export default App;
