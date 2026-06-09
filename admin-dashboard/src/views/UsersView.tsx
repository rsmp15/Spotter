import React, { useState, useMemo } from 'react';
import { useAdmin } from '../context/AdminContext';
import type { User } from '../data/Database';
import { DataTable } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { UserPlus, Users, UserCheck, Clock, Search } from 'lucide-react';

// ── helpers ─────────────────────────────────────────────────────────────────

function getInitials(name: string) {
  return name
    .split(' ')
    .map((p) => p[0])
    .join('')
    .slice(0, 2)
    .toUpperCase();
}

function avatarColor(id: string) {
  const colors = [
    '#FF385C', '#0066CC', '#008A05', '#C47700',
    '#6B46C1', '#0891b2', '#db2777',
  ];
  let hash = 0;
  for (let i = 0; i < id.length; i++) hash = (hash * 31 + id.charCodeAt(i)) & 0xffff;
  return colors[hash % colors.length];
}

const STATUS_PILL: Record<User['status'], string> = {
  'Active':      'pill pill-green',
  'Pending KYC': 'pill pill-amber',
  'Suspended':   'pill pill-red',
};

// ── component ────────────────────────────────────────────────────────────────

export const UsersView: React.FC = () => {
  const { users, addItem, updateItem, deleteItem } = useAdmin();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingUser, setEditingUser]  = useState<User | null>(null);
  const [search, setSearch]            = useState('');
  const [roleFilter, setRoleFilter]    = useState<'All' | 'Rider' | 'Driver'>('All');

  const [formData, setFormData] = useState<Partial<User>>({
    name: '', role: 'Rider', status: 'Active',
  });

  // Stats
  const total    = users.length;
  const active   = users.filter((u) => u.status === 'Active').length;
  const pending  = users.filter((u) => u.status === 'Pending KYC').length;
  const riders   = users.filter((u) => u.role === 'Rider').length;
  const drivers  = users.filter((u) => u.role === 'Driver').length;

  // Filtered list
  const filtered = useMemo(() => {
    return users.filter((u) => {
      const matchSearch =
        search === '' ||
        u.name.toLowerCase().includes(search.toLowerCase()) ||
        u.id.toLowerCase().includes(search.toLowerCase());
      const matchRole = roleFilter === 'All' || u.role === roleFilter;
      return matchSearch && matchRole;
    });
  }, [users, search, roleFilter]);

  // Handlers
  const handleOpenNew = () => {
    setEditingUser(null);
    setFormData({ name: '', role: 'Rider', status: 'Active' });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (user: User) => {
    setEditingUser(user);
    setFormData({ ...user });
    setIsModalOpen(true);
  };

  const handleDelete = (user: User) => {
    if (confirm(`Remove ${user.name} from the platform?`)) {
      deleteItem('users', 'id', user.id);
    }
  };

  const handleSave = () => {
    if (!formData.name?.trim()) return;
    if (editingUser) {
      updateItem('users', 'id', editingUser.id, formData);
    } else {
      addItem('users', { ...formData, id: `u${Date.now()}` });
    }
    setIsModalOpen(false);
  };

  return (
    <div>
      {/* ── Page header ───────────────────────────────────────── */}
      <div className="page-header">
        <div>
          <h1 className="page-title">Users & KYC</h1>
          <p className="page-subtitle">Manage riders, drivers and identity verification status.</p>
        </div>
        <button className="btn btn-primary" onClick={handleOpenNew}>
          <UserPlus size={15} />
          Add User
        </button>
      </div>

      {/* ── Stat cards ────────────────────────────────────────── */}
      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Total Users</span>
            <div className="stat-card-icon" style={{ background: '#FFF0F3' }}>
              <Users size={16} color="var(--brand)" />
            </div>
          </div>
          <div className="stat-card-value">{total}</div>
          <div className="stat-card-delta up">↑ All time</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Active</span>
            <div className="stat-card-icon" style={{ background: 'var(--green-bg)' }}>
              <UserCheck size={16} color="var(--green)" />
            </div>
          </div>
          <div className="stat-card-value">{active}</div>
          <div className="stat-card-delta up">↑ Verified</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Pending KYC</span>
            <div className="stat-card-icon" style={{ background: 'var(--amber-bg)' }}>
              <Clock size={16} color="var(--amber)" />
            </div>
          </div>
          <div className="stat-card-value">{pending}</div>
          <div className="stat-card-delta down">Needs review</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Riders</span>
            <div className="stat-card-icon" style={{ background: 'var(--blue-bg)' }}>
              <span style={{ fontSize: 16 }}>🛵</span>
            </div>
          </div>
          <div className="stat-card-value">{riders}</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Drivers</span>
            <div className="stat-card-icon" style={{ background: 'var(--purple-bg)' }}>
              <span style={{ fontSize: 16 }}>🚗</span>
            </div>
          </div>
          <div className="stat-card-value">{drivers}</div>
        </div>
      </div>

      {/* ── Table toolbar ─────────────────────────────────────── */}
      <div className="table-toolbar">
        <label className="table-search">
          <Search size={13} color="var(--hint)" />
          <input
            placeholder="Search by name or ID…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </label>

        {(['All', 'Rider', 'Driver'] as const).map((r) => (
          <button
            key={r}
            className={`filter-chip ${roleFilter === r ? 'active' : ''}`}
            onClick={() => setRoleFilter(r)}
          >
            {r}
          </button>
        ))}

        <span style={{ marginLeft: 'auto', fontSize: 13, color: 'var(--mute)' }}>
          {filtered.length} of {total} users
        </span>
      </div>

      {/* ── Data table ────────────────────────────────────────── */}
      <DataTable
        data={filtered}
        keyExtractor={(u) => u.id}
        onEdit={handleOpenEdit}
        onDelete={handleDelete}
        emptyTitle="No users found"
        emptyDesc="Try adjusting your search or filters."
        columns={[
          {
            header: 'User',
            accessor: (u) => (
              <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                <div
                  className="avatar"
                  style={{ background: avatarColor(u.id) }}
                >
                  {getInitials(u.name)}
                </div>
                <div>
                  <div className="name-cell">{u.name}</div>
                  <div style={{ fontSize: 12, color: 'var(--mute)' }}>{u.id}</div>
                </div>
              </div>
            ),
          },
          {
            header: 'Role',
            accessor: (u) => (
              <span className={`pill ${u.role === 'Driver' ? 'pill-purple' : 'pill-blue'}`}>
                {u.role}
              </span>
            ),
          },
          {
            header: 'Status',
            accessor: (u) => (
              <span className={STATUS_PILL[u.status]}>{u.status}</span>
            ),
          },
        ]}
      />

      {/* ── Add / Edit Modal ──────────────────────────────────── */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={editingUser ? 'Edit User' : 'Add New User'}
        subtitle={editingUser ? `Editing ${editingUser.name}` : 'Fill in the details below'}
      >
        <div>
          <div className="form-group">
            <label className="form-label">Full Name</label>
            <input
              className="form-control"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              placeholder="e.g. Alice Smith"
            />
          </div>

          <div className="form-group">
            <label className="form-label">Role</label>
            <select
              className="form-control"
              value={formData.role}
              onChange={(e) => setFormData({ ...formData, role: e.target.value as User['role'] })}
            >
              <option>Rider</option>
              <option>Driver</option>
            </select>
          </div>

          <div className="form-group">
            <label className="form-label">Status</label>
            <select
              className="form-control"
              value={formData.status}
              onChange={(e) => setFormData({ ...formData, status: e.target.value as User['status'] })}
            >
              <option>Active</option>
              <option>Pending KYC</option>
              <option>Suspended</option>
            </select>
          </div>

          <button
            className="btn btn-primary"
            style={{ width: '100%', marginTop: 8 }}
            onClick={handleSave}
          >
            {editingUser ? 'Save Changes' : 'Create User'}
          </button>
        </div>
      </Modal>
    </div>
  );
};
