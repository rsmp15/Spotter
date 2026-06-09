import React from 'react';
import { NavLink } from 'react-router-dom';
import { Users, MapPin, HeadphonesIcon, SlidersHorizontal, BarChart3, LogOut } from 'lucide-react';

// Airbnb Spotter logo mark (SVG)
const SpotterMark: React.FC = () => (
  <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      d="M10 1C6.134 1 3 4.134 3 8c0 5.25 7 11 7 11s7-5.75 7-11c0-3.866-3.134-7-7-7z"
      fill="white"
    />
    <circle cx="10" cy="8" r="2.5" fill="#FF385C" />
  </svg>
);

interface NavItemProps {
  to: string;
  icon: React.ReactNode;
  label: string;
  badge?: number;
}

const NavItem: React.FC<NavItemProps> = ({ to, icon, label, badge }) => (
  <NavLink
    to={to}
    className={({ isActive }) => `nav-item ${isActive ? 'active' : ''}`}
  >
    <span className="nav-icon" style={{ display: 'flex', alignItems: 'center' }}>{icon}</span>
    <span style={{ flex: 1 }}>{label}</span>
    {badge !== undefined && badge > 0 && (
      <span className="nav-badge">{badge}</span>
    )}
  </NavLink>
);

export const Sidebar: React.FC = () => {
  return (
    <aside className="sidebar">
      {/* Brand */}
      <div className="sidebar-brand">
        <div className="sidebar-brand-icon">
          <SpotterMark />
        </div>
        <div>
          <div className="sidebar-brand-text">Spotter</div>
          <div className="sidebar-brand-sub">Operations</div>
        </div>
      </div>

      {/* Navigation */}
      <nav className="sidebar-nav">
        <div className="sidebar-section-label">Manage</div>
        <NavItem to="/users"   icon={<Users size={16} />}              label="Users & KYC" />
        <NavItem to="/trips"   icon={<MapPin size={16} />}             label="Live Dispatch" badge={1} />
        <NavItem to="/support" icon={<HeadphonesIcon size={16} />}     label="Support & Safety" badge={1} />

        <div className="sidebar-section-label" style={{ marginTop: '8px' }}>System</div>
        <NavItem to="/config"  icon={<SlidersHorizontal size={16} />}  label="Remote Config" />

        <div className="sidebar-section-label" style={{ marginTop: '8px' }}>Analytics</div>
        <NavItem to="/analytics" icon={<BarChart3 size={16} />}        label="Reports" />
      </nav>

      {/* Footer */}
      <div className="sidebar-footer">
        <div className="nav-item" style={{ cursor: 'pointer', color: 'var(--red)' }}>
          <LogOut size={16} />
          <span>Sign out</span>
        </div>

        <div className="sidebar-user" style={{ marginTop: '4px' }}>
          <div className="sidebar-avatar">A</div>
          <div className="sidebar-user-info">
            <div className="sidebar-user-name">Admin User</div>
            <div className="sidebar-user-role">Super Admin</div>
          </div>
        </div>
      </div>
    </aside>
  );
};
