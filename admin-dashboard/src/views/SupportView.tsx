import React, { useState } from 'react';
import { useAdmin } from '../context/AdminContext';
import type { SupportCase } from '../data/Database';
import { DataTable } from '../components/DataTable';
import { Modal } from '../components/Modal';

export const SupportView: React.FC = () => {
  const { supportCases, users, addItem, updateItem, deleteItem } = useAdmin();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingCase, setEditingCase] = useState<SupportCase | null>(null);

  const [formData, setFormData] = useState<Partial<SupportCase>>({
    userId: '', issue: '', status: 'Open'
  });

  const handleOpenNew = () => {
    setEditingCase(null);
    setFormData({ userId: users[0]?.id || '', issue: '', status: 'Open' });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (supportCase: SupportCase) => {
    setEditingCase(supportCase);
    setFormData(supportCase);
    setIsModalOpen(true);
  };

  const handleDelete = (supportCase: SupportCase) => {
    if (confirm(`Are you sure you want to delete case ${supportCase.id}?`)) {
      deleteItem('supportCases', 'id', supportCase.id);
    }
  };

  const handleSave = () => {
    if (editingCase) {
      updateItem('supportCases', 'id', editingCase.id, formData);
    } else {
      addItem('supportCases', {
        ...formData,
        id: `s${Date.now()}`,
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
          <h1 className="text-display-md">Support & Safety</h1>
          <p className="text-body-sm">Manage rider and driver support tickets.</p>
        </div>
        <button className="pill-btn" onClick={handleOpenNew}>+ Create Ticket</button>
      </div>

      <DataTable 
        data={supportCases}
        keyExtractor={s => s.id}
        onEdit={handleOpenEdit}
        onDelete={handleDelete}
        columns={[
          { header: 'Case ID', accessor: 'id' },
          { header: 'User', accessor: (s) => users.find(u => u.id === s.userId)?.name || s.userId },
          { header: 'Issue Description', accessor: 'issue' },
          { 
            header: 'Status', 
            accessor: (s) => (
              <span style={{ 
                padding: '4px 8px', borderRadius: '4px', fontSize: '12px', fontWeight: 600,
                background: s.status === 'Resolved' ? '#e6f4ea' : '#fce8e6',
                color: s.status === 'Resolved' ? '#1e8e3e' : '#d93025'
              }}>
                {s.status}
              </span>
            ) 
          },
        ]}
      />

      <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} title={editingCase ? "Edit Ticket" : "New Ticket"}>
        <div>
          <label className="text-body-sm">User</label>
          <select style={inputStyle} value={formData.userId} onChange={e => setFormData({...formData, userId: e.target.value})}>
            <option value="">Select User...</option>
            {users.map(u => <option key={u.id} value={u.id}>{u.name} ({u.role})</option>)}
          </select>

          <label className="text-body-sm">Issue Description</label>
          <textarea 
            style={{ ...inputStyle, minHeight: '100px' }} 
            value={formData.issue} 
            onChange={e => setFormData({...formData, issue: e.target.value})}
            placeholder="Describe the problem..."
          />

          <label className="text-body-sm">Status</label>
          <select style={inputStyle} value={formData.status} onChange={e => setFormData({...formData, status: e.target.value as any})}>
            <option>Open</option>
            <option>Resolved</option>
          </select>

          <button className="pill-btn" style={{ width: '100%', marginTop: '16px' }} onClick={handleSave}>
            {editingCase ? "Save Changes" : "Create Ticket"}
          </button>
        </div>
      </Modal>
    </div>
  );
};
