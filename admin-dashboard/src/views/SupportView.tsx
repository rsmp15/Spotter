import React, { useState, useMemo } from 'react';
import { useAdmin } from '../context/AdminContext';
import type { SupportCase } from '../data/Database';
import { DataTable } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { HeadphonesIcon, Search, AlertCircle, CheckCircle2, TicketPlus, Clock } from 'lucide-react';

// ── helpers ──────────────────────────────────────────────────────────────────

const STATUS_PILL: Record<SupportCase['status'], string> = {
  'Open':     'pill pill-red',
  'Resolved': 'pill pill-green',
};

function timeSince(id: string) {
  // deterministically simulate age from the id's numeric suffix
  const num = parseInt(id.replace(/\D/g, ''), 10) || 0;
  const hours = (num % 72) + 1;
  if (hours < 24) return `${hours}h ago`;
  return `${Math.floor(hours / 24)}d ago`;
}

// ── component ────────────────────────────────────────────────────────────────

export const SupportView: React.FC = () => {
  const { supportCases, users, addItem, updateItem, deleteItem } = useAdmin();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCase, setEditingCase]  = useState<SupportCase | null>(null);
  const [search, setSearch]            = useState('');
  const [statusFilter, setStatusFilter] = useState<SupportCase['status'] | 'All'>('All');

  const [formData, setFormData] = useState<Partial<SupportCase>>({
    userId: '', issue: '', status: 'Open',
  });

  // Stats
  const total    = supportCases.length;
  const open     = supportCases.filter((s) => s.status === 'Open').length;
  const resolved = supportCases.filter((s) => s.status === 'Resolved').length;
  const rate     = total > 0 ? Math.round((resolved / total) * 100) : 0;

  // Filtered list
  const filtered = useMemo(() => {
    return supportCases.filter((s) => {
      const user = users.find((u) => u.id === s.userId);
      const matchSearch =
        search === '' ||
        s.id.toLowerCase().includes(search.toLowerCase()) ||
        s.issue.toLowerCase().includes(search.toLowerCase()) ||
        user?.name.toLowerCase().includes(search.toLowerCase());
      const matchStatus = statusFilter === 'All' || s.status === statusFilter;
      return matchSearch && matchStatus;
    });
  }, [supportCases, users, search, statusFilter]);

  // Handlers
  const handleOpenNew = () => {
    setEditingCase(null);
    setFormData({ userId: users[0]?.id || '', issue: '', status: 'Open' });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (c: SupportCase) => {
    setEditingCase(c);
    setFormData({ ...c });
    setIsModalOpen(true);
  };

  const handleDelete = (c: SupportCase) => {
    if (confirm(`Delete case ${c.id}?`)) {
      deleteItem('supportCases', 'id', c.id);
    }
  };

  const handleSave = () => {
    if (!formData.issue?.trim()) return;
    if (editingCase) {
      updateItem('supportCases', 'id', editingCase.id, formData);
    } else {
      addItem('supportCases', { ...formData, id: `s${Date.now()}` });
    }
    setIsModalOpen(false);
  };

  return (
    <div>
      {/* ── Page header ───────────────────────────────────────── */}
      <div className="page-header">
        <div>
          <h1 className="page-title">Support & Safety</h1>
          <p className="page-subtitle">Handle rider and driver support tickets and safety cases.</p>
        </div>
        <button className="btn btn-primary" onClick={handleOpenNew}>
          <TicketPlus size={15} />
          Create Ticket
        </button>
      </div>

      {/* ── Stat cards ────────────────────────────────────────── */}
      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Total Cases</span>
            <div className="stat-card-icon" style={{ background: '#FFF0F3' }}>
              <HeadphonesIcon size={16} color="var(--brand)" />
            </div>
          </div>
          <div className="stat-card-value">{total}</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Open</span>
            <div className="stat-card-icon" style={{ background: 'var(--red-bg)' }}>
              <AlertCircle size={16} color="var(--red)" />
            </div>
          </div>
          <div className="stat-card-value">{open}</div>
          {open > 0 && <div className="stat-card-delta down">Action required</div>}
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Resolved</span>
            <div className="stat-card-icon" style={{ background: 'var(--green-bg)' }}>
              <CheckCircle2 size={16} color="var(--green)" />
            </div>
          </div>
          <div className="stat-card-value">{resolved}</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Resolution Rate</span>
            <div className="stat-card-icon" style={{ background: 'var(--amber-bg)' }}>
              <Clock size={16} color="var(--amber)" />
            </div>
          </div>
          <div className="stat-card-value">{rate}%</div>
          <div className={`stat-card-delta ${rate >= 70 ? 'up' : 'down'}`}>
            {rate >= 70 ? '↑ On track' : '↓ Below target'}
          </div>
        </div>
      </div>

      {/* ── Table toolbar ─────────────────────────────────────── */}
      <div className="table-toolbar">
        <label className="table-search">
          <Search size={13} color="var(--hint)" />
          <input
            placeholder="Search cases, users or issues…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </label>

        {(['All', 'Open', 'Resolved'] as const).map((s) => (
          <button
            key={s}
            className={`filter-chip ${statusFilter === s ? 'active' : ''}`}
            onClick={() => setStatusFilter(s)}
          >
            {s}
          </button>
        ))}

        <span style={{ marginLeft: 'auto', fontSize: 13, color: 'var(--mute)' }}>
          {filtered.length} of {total} cases
        </span>
      </div>

      {/* ── Data table ────────────────────────────────────────── */}
      <DataTable
        data={filtered}
        keyExtractor={(s) => s.id}
        onEdit={handleOpenEdit}
        onDelete={handleDelete}
        emptyTitle="No cases found"
        emptyDesc="No support tickets match your current filters."
        columns={[
          {
            header: 'Case',
            accessor: (s) => (
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
                  <span className="id-cell">{s.id}</span>
                  <span style={{ color: 'var(--hint)', fontSize: 12 }}>·</span>
                  <span style={{ fontSize: 12, color: 'var(--mute)' }}>{timeSince(s.id)}</span>
                </div>
              </div>
            ),
          },
          {
            header: 'User',
            accessor: (s) => {
              const u = users.find((u) => u.id === s.userId);
              return (
                <div>
                  <div className="name-cell">{u?.name || s.userId}</div>
                  {u && (
                    <div style={{ fontSize: 12, color: 'var(--mute)' }}>{u.role}</div>
                  )}
                </div>
              );
            },
          },
          {
            header: 'Issue',
            accessor: (s) => (
              <div style={{
                maxWidth: 320,
                whiteSpace: 'nowrap',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
                fontSize: 13,
                color: 'var(--body)',
              }}>
                {s.issue}
              </div>
            ),
          },
          {
            header: 'Status',
            accessor: (s) => <span className={STATUS_PILL[s.status]}>{s.status}</span>,
          },
        ]}
      />

      {/* ── Add / Edit Modal ──────────────────────────────────── */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={editingCase ? 'Edit Case' : 'New Support Ticket'}
        subtitle={editingCase ? `Case ${editingCase.id}` : 'Log a new rider or driver issue'}
      >
        <div>
          <div className="form-group">
            <label className="form-label">User</label>
            <select
              className="form-control"
              value={formData.userId}
              onChange={(e) => setFormData({ ...formData, userId: e.target.value })}
            >
              <option value="">Select user…</option>
              {users.map((u) => (
                <option key={u.id} value={u.id}>{u.name} ({u.role})</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label className="form-label">Issue Description</label>
            <textarea
              className="form-control"
              value={formData.issue}
              onChange={(e) => setFormData({ ...formData, issue: e.target.value })}
              placeholder="Describe the problem in detail…"
            />
          </div>

          <div className="form-group">
            <label className="form-label">Status</label>
            <select
              className="form-control"
              value={formData.status}
              onChange={(e) => setFormData({ ...formData, status: e.target.value as SupportCase['status'] })}
            >
              <option>Open</option>
              <option>Resolved</option>
            </select>
          </div>

          <button
            className="btn btn-primary"
            style={{ width: '100%', marginTop: 8 }}
            onClick={handleSave}
          >
            {editingCase ? 'Save Changes' : 'Create Ticket'}
          </button>
        </div>
      </Modal>
    </div>
  );
};
