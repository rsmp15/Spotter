import React from 'react';
import { NavLink } from 'react-router-dom';
import { Navigation, Users, Map, Settings, ShieldAlert } from 'lucide-react';

export const Sidebar: React.FC = () => {
  const getNavStyle = ({ isActive }: { isActive: boolean }) => ({
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    padding: '12px 16px',
    borderRadius: 'var(--rounded-pill)',
    textDecoration: 'none',
    fontWeight: isActive ? 600 : 500,
    color: isActive ? 'var(--primary)' : 'var(--ink)',
    background: isActive ? 'var(--canvas-soft)' : 'transparent',
    fontFamily: 'Inter, sans-serif'
  });

  return (
    <aside className="sidebar">
      <div style={{ padding: '24px', display: 'flex', alignItems: 'center', gap: '12px', borderBottom: '1px solid var(--line)' }}>
        <Navigation size={24} color="var(--primary)" />
        <span style={{ fontSize: '20px', fontWeight: 700, fontFamily: 'Inter', letterSpacing: '-0.5px' }}>Spotter Ops</span>
      </div>
      
      <nav style={{ padding: '24px 16px', display: 'flex', flexDirection: 'column', gap: '8px' }}>
        <NavLink to="/users" style={getNavStyle}>
          <Users size={20} />
          Users & KYC
        </NavLink>
        <NavLink to="/trips" style={getNavStyle}>
          <Map size={20} />
          Live Dispatch
        </NavLink>
        <NavLink to="/support" style={getNavStyle}>
          <ShieldAlert size={20} />
          Support & Safety
        </NavLink>
        <NavLink to="/config" style={getNavStyle}>
          <Settings size={20} />
          Remote Config
        </NavLink>
      </nav>
    </aside>
  );
};
