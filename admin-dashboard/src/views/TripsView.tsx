import React, { useState, useMemo } from 'react';
import { useAdmin } from '../context/AdminContext';
import type { Trip } from '../data/Database';
import { DataTable } from '../components/DataTable';
import { Modal } from '../components/Modal';
import { MapPin, Navigation, Search, TrendingUp, DollarSign, Clock, XCircle } from 'lucide-react';

// ── helpers ──────────────────────────────────────────────────────────────────

const STATUS_PILL: Record<Trip['status'], string> = {
  'Requested':   'pill pill-amber',
  'In Progress': 'pill pill-blue',
  'Completed':   'pill pill-green',
  'Cancelled':   'pill pill-red',
};

function formatFare(fare: number) {
  return new Intl.NumberFormat('en-IN', {
    style: 'currency', currency: 'INR', maximumFractionDigits: 0,
  }).format(fare);
}

// ── component ────────────────────────────────────────────────────────────────

export const TripsView: React.FC = () => {
  const { trips, users, addItem, updateItem, deleteItem } = useAdmin();

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingTrip, setEditingTrip]  = useState<Trip | null>(null);
  const [search, setSearch]            = useState('');
  const [statusFilter, setStatusFilter] = useState<Trip['status'] | 'All'>('All');

  const [formData, setFormData] = useState<Partial<Trip>>({
    riderId: '', driverId: '', status: 'Requested', fare: 0,
  });

  // Stats
  const total       = trips.length;
  const inProgress  = trips.filter((t) => t.status === 'In Progress').length;
  const completed   = trips.filter((t) => t.status === 'Completed').length;
  const totalFare   = trips.filter((t) => t.status === 'Completed').reduce((s, t) => s + t.fare, 0);
  const cancelled   = trips.filter((t) => t.status === 'Cancelled').length;

  // Filtered list
  const filtered = useMemo(() => {
    return trips.filter((t) => {
      const rider  = users.find((u) => u.id === t.riderId);
      const driver = users.find((u) => u.id === t.driverId);
      const matchSearch =
        search === '' ||
        t.id.toLowerCase().includes(search.toLowerCase()) ||
        rider?.name.toLowerCase().includes(search.toLowerCase()) ||
        driver?.name.toLowerCase().includes(search.toLowerCase());
      const matchStatus = statusFilter === 'All' || t.status === statusFilter;
      return matchSearch && matchStatus;
    });
  }, [trips, users, search, statusFilter]);

  // Handlers
  const handleOpenNew = () => {
    setEditingTrip(null);
    setFormData({ riderId: users[0]?.id || '', driverId: '', status: 'Requested', fare: 0 });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (trip: Trip) => {
    setEditingTrip(trip);
    setFormData({ ...trip });
    setIsModalOpen(true);
  };

  const handleDelete = (trip: Trip) => {
    if (confirm(`Cancel trip ${trip.id}?`)) {
      deleteItem('trips', 'id', trip.id);
    }
  };

  const handleSave = () => {
    if (editingTrip) {
      updateItem('trips', 'id', editingTrip.id, { ...formData, fare: Number(formData.fare) });
    } else {
      addItem('trips', { ...formData, id: `t${Date.now()}`, fare: Number(formData.fare) || 0 });
    }
    setIsModalOpen(false);
  };

  const STATUS_FILTERS = ['All', 'Requested', 'In Progress', 'Completed', 'Cancelled'] as const;

  return (
    <div>
      {/* ── Page header ───────────────────────────────────────── */}
      <div className="page-header">
        <div>
          <h1 className="page-title">Live Dispatch</h1>
          <p className="page-subtitle">Monitor active rides, reassign drivers, or cancel trips.</p>
        </div>
        <button className="btn btn-primary" onClick={handleOpenNew}>
          <Navigation size={15} />
          Manual Dispatch
        </button>
      </div>

      {/* ── Stat cards ────────────────────────────────────────── */}
      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Total Trips</span>
            <div className="stat-card-icon" style={{ background: '#FFF0F3' }}>
              <MapPin size={16} color="var(--brand)" />
            </div>
          </div>
          <div className="stat-card-value">{total}</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">In Progress</span>
            <div className="stat-card-icon" style={{ background: 'var(--blue-bg)' }}>
              <Navigation size={16} color="var(--blue)" />
            </div>
          </div>
          <div className="stat-card-value">{inProgress}</div>
          <div className="stat-card-delta up">Live now</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Completed</span>
            <div className="stat-card-icon" style={{ background: 'var(--green-bg)' }}>
              <TrendingUp size={16} color="var(--green)" />
            </div>
          </div>
          <div className="stat-card-value">{completed}</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Revenue</span>
            <div className="stat-card-icon" style={{ background: 'var(--amber-bg)' }}>
              <DollarSign size={16} color="var(--amber)" />
            </div>
          </div>
          <div className="stat-card-value" style={{ fontSize: 22 }}>
            {formatFare(totalFare)}
          </div>
          <div className="stat-card-delta up">Completed trips</div>
        </div>

        <div className="stat-card">
          <div className="stat-card-header">
            <span className="stat-card-label">Cancelled</span>
            <div className="stat-card-icon" style={{ background: 'var(--red-bg)' }}>
              <XCircle size={16} color="var(--red)" />
            </div>
          </div>
          <div className="stat-card-value">{cancelled}</div>
          {cancelled > 0 && <div className="stat-card-delta down">Needs review</div>}
        </div>
      </div>

      {/* ── Table toolbar ─────────────────────────────────────── */}
      <div className="table-toolbar">
        <label className="table-search">
          <Search size={13} color="var(--hint)" />
          <input
            placeholder="Search by trip ID or name…"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </label>

        {STATUS_FILTERS.map((s) => (
          <button
            key={s}
            className={`filter-chip ${statusFilter === s ? 'active' : ''}`}
            onClick={() => setStatusFilter(s)}
          >
            {s}
          </button>
        ))}

        <span style={{ marginLeft: 'auto', fontSize: 13, color: 'var(--mute)' }}>
          {filtered.length} of {total} trips
        </span>
      </div>

      {/* ── Data table ────────────────────────────────────────── */}
      <DataTable
        data={filtered}
        keyExtractor={(t) => t.id}
        onEdit={handleOpenEdit}
        onDelete={handleDelete}
        emptyTitle="No trips found"
        emptyDesc="Try adjusting your search or add a dispatch manually."
        columns={[
          {
            header: 'Trip ID',
            accessor: (t) => <span className="id-cell">{t.id}</span>,
          },
          {
            header: 'Rider',
            accessor: (t) => {
              const u = users.find((u) => u.id === t.riderId);
              return (
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <div
                    className="trip-route-dot from"
                    style={{ width: 8, height: 8, borderRadius: '50%', background: 'var(--green)', flexShrink: 0 }}
                  />
                  <span className="name-cell">{u?.name || t.riderId}</span>
                </div>
              );
            },
          },
          {
            header: 'Driver',
            accessor: (t) => {
              const u = t.driverId ? users.find((u) => u.id === t.driverId) : null;
              return u ? (
                <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
                  <div
                    style={{ width: 8, height: 8, borderRadius: '50%', background: 'var(--brand)', flexShrink: 0 }}
                  />
                  <span className="name-cell">{u.name}</span>
                </div>
              ) : (
                <span style={{ color: 'var(--hint)', fontStyle: 'italic', fontSize: 13 }}>Unassigned</span>
              );
            },
          },
          {
            header: 'Fare',
            accessor: (t) => <span className="trip-fare">{formatFare(t.fare)}</span>,
          },
          {
            header: 'Status',
            accessor: (t) => <span className={STATUS_PILL[t.status]}>{t.status}</span>,
          },
        ]}
      />

      {/* ── Add / Edit Modal ──────────────────────────────────── */}
      <Modal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        title={editingTrip ? 'Edit Trip' : 'New Dispatch'}
        subtitle={editingTrip ? `Trip ${editingTrip.id}` : 'Manually assign a rider to a driver'}
      >
        <div>
          <div className="form-group">
            <label className="form-label">Rider</label>
            <select
              className="form-control"
              value={formData.riderId}
              onChange={(e) => setFormData({ ...formData, riderId: e.target.value })}
            >
              <option value="">Select rider…</option>
              {users.filter((u) => u.role === 'Rider').map((u) => (
                <option key={u.id} value={u.id}>{u.name}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label className="form-label">Driver (optional)</label>
            <select
              className="form-control"
              value={formData.driverId || ''}
              onChange={(e) => setFormData({ ...formData, driverId: e.target.value || null })}
            >
              <option value="">Unassigned</option>
              {users.filter((u) => u.role === 'Driver').map((u) => (
                <option key={u.id} value={u.id}>{u.name}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label className="form-label">Fare (₹)</label>
            <input
              type="number"
              className="form-control"
              value={formData.fare}
              onChange={(e) => setFormData({ ...formData, fare: Number(e.target.value) })}
              placeholder="e.g. 250"
              min={0}
            />
          </div>

          <div className="form-group">
            <label className="form-label">Status</label>
            <select
              className="form-control"
              value={formData.status}
              onChange={(e) => setFormData({ ...formData, status: e.target.value as Trip['status'] })}
            >
              <option>Requested</option>
              <option>In Progress</option>
              <option>Completed</option>
              <option>Cancelled</option>
            </select>
          </div>

          <button
            className="btn btn-primary"
            style={{ width: '100%', marginTop: 8 }}
            onClick={handleSave}
          >
            {editingTrip ? 'Save Changes' : 'Dispatch Trip'}
          </button>
        </div>
      </Modal>
    </div>
  );
};
