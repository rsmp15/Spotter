
import { Routes, Route, Navigate, useLocation } from 'react-router-dom';
import { Sidebar } from './components/Sidebar';
import { RemoteConfigManager } from './views/RemoteConfigManager';
import { UsersView } from './views/UsersView';
import { TripsView } from './views/TripsView';
import { SupportView } from './views/SupportView';
import { Menu, UserCircle } from 'lucide-react';

function App() {
  const location = useLocation();
  const pathName = location.pathname.replace('/', '');
  const title = pathName.charAt(0).toUpperCase() + pathName.slice(1);

  return (
    <div className="dashboard-shell">
      <Sidebar />

      <main className="main-content">
        <header className="topbar" style={{ justifyContent: 'space-between' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
            <Menu size={24} color="var(--ink)" />
            <span className="text-body-md" style={{ fontWeight: 500, color: 'var(--mute)' }}>
              Administration / <span style={{ color: 'var(--ink)' }}>{title || 'Dashboard'}</span>
            </span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <span className="text-body-sm" style={{ fontWeight: 500 }}>Admin User</span>
            <UserCircle size={28} color="var(--ink)" />
          </div>
        </header>

        <div className="content-area">
          <Routes>
            <Route path="/" element={<Navigate to="/users" replace />} />
            <Route path="/users" element={<UsersView />} />
            <Route path="/trips" element={<TripsView />} />
            <Route path="/support" element={<SupportView />} />
            <Route path="/config" element={<RemoteConfigManager />} />
          </Routes>
        </div>
      </main>
    </div>
  );
}

export default App;
