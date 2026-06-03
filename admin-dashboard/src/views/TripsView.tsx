import React, { useState } from 'react';
import { useAdmin } from '../context/AdminContext';
import type { Trip } from '../data/Database';
import { DataTable } from '../components/DataTable';
import { Modal } from '../components/Modal';

export const TripsView: React.FC = () => {
  const { trips, users, addItem, updateItem, deleteItem } = useAdmin();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingTrip, setEditingTrip] = useState<Trip | null>(null);

  const [formData, setFormData] = useState<Partial<Trip>>({
    riderId: '', driverId: '', status: 'Requested', fare: 0
  });

  const handleOpenNew = () => {
    setEditingTrip(null);
    setFormData({ riderId: users[0]?.id || '', driverId: '', status: 'Requested', fare: 0 });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (trip: Trip) => {
    setEditingTrip(trip);
    setFormData(trip);
    setIsModalOpen(true);
  };

  const handleDelete = (trip: Trip) => {
    if (confirm(`Are you sure you want to cancel trip ${trip.id}?`)) {
      deleteItem('trips', 'id', trip.id);
    }
  };

  const handleSave = () => {
    if (editingTrip) {
      updateItem('trips', 'id', editingTrip.id, formData);
    } else {
      addItem('trips', {
        ...formData,
        id: `t${Date.now()}`,
        fare: Number(formData.fare) || 0
      });
    }
    setIsModalOpen(false);
  };

  const inputStyle = {
    width: '100%', padding: '12px', border: '1px solid var(--line)',
    borderRadius: 'var(--rounded-md)', marginBottom: '16px', background: 'var(--canvas-soft)', color: 'var(--ink)'
  };

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '24px' }}>
        <div>
          <h1 className="text-display-md">Trips & Dispatch</h1>
          <p className="text-body-sm">Monitor active rides, reassign drivers, or cancel trips.</p>
        </div>
        <button className="pill-btn" onClick={handleOpenNew}>+ Manual Dispatch</button>
      </div>

      <DataTable 
        data={trips}
        keyExtractor={t => t.id}
        onEdit={handleOpenEdit}
        onDelete={handleDelete}
        columns={[
          { header: 'Trip ID', accessor: 'id' },
          { header: 'Rider', accessor: (t) => users.find(u => u.id === t.riderId)?.name || t.riderId },
          { header: 'Driver', accessor: (t) => t.driverId ? (users.find(u => u.id === t.driverId)?.name || t.driverId) : 'Unassigned' },
          { header: 'Fare', accessor: (t) => `$${t.fare.toFixed(2)}` },
          { 
            header: 'Status', 
            accessor: (t) => (
              <span style={{ 
                padding: '4px 8px', borderRadius: '4px', fontSize: '12px', fontWeight: 600,
                background: t.status === 'Completed' ? '#e6f4ea' : t.status === 'In Progress' ? '#e8f0fe' : t.status === 'Requested' ? '#fef7e0' : '#fce8e6',
                color: t.status === 'Completed' ? '#1e8e3e' : t.status === 'In Progress' ? '#1a73e8' : t.status === 'Requested' ? '#f9ab00' : '#d93025'
              }}>
                {t.status}
              </span>
            ) 
          },
        ]}
      />

      <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} title={editingTrip ? "Edit Trip" : "New Dispatch"}>
        <div>
          <label className="text-body-sm">Rider</label>
          <select style={inputStyle} value={formData.riderId} onChange={e => setFormData({...formData, riderId: e.target.value})}>
            <option value="">Select Rider...</option>
            {users.filter(u => u.role === 'Rider').map(u => <option key={u.id} value={u.id}>{u.name}</option>)}
          </select>

          <label className="text-body-sm">Driver (Optional)</label>
          <select style={inputStyle} value={formData.driverId || ''} onChange={e => setFormData({...formData, driverId: e.target.value})}>
            <option value="">Unassigned</option>
            {users.filter(u => u.role === 'Driver').map(u => <option key={u.id} value={u.id}>{u.name}</option>)}
          </select>

          <label className="text-body-sm">Fare Amount</label>
          <input type="number" style={inputStyle} value={formData.fare} onChange={e => setFormData({...formData, fare: Number(e.target.value)})} />

          <label className="text-body-sm">Status</label>
          <select style={inputStyle} value={formData.status} onChange={e => setFormData({...formData, status: e.target.value as any})}>
            <option>Requested</option>
            <option>In Progress</option>
            <option>Completed</option>
            <option>Cancelled</option>
          </select>

          <button className="pill-btn" style={{ width: '100%', marginTop: '16px' }} onClick={handleSave}>
            {editingTrip ? "Save Changes" : "Dispatch Trip"}
          </button>
        </div>
      </Modal>
    </div>
  );
};
