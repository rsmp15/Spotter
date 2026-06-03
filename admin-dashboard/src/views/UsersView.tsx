import React, { useState } from 'react';
import { useAdmin } from '../context/AdminContext';
import type { User } from '../data/Database';
import { DataTable } from '../components/DataTable';
import { Modal } from '../components/Modal';

export const UsersView: React.FC = () => {
  const { users, addItem, updateItem, deleteItem } = useAdmin();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);

  const [formData, setFormData] = useState<Partial<User>>({
    name: '', role: 'Rider', status: 'Active'
  });

  const handleOpenNew = () => {
    setEditingUser(null);
    setFormData({ name: '', role: 'Rider', status: 'Active' });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (user: User) => {
    setEditingUser(user);
    setFormData(user);
    setIsModalOpen(true);
  };

  const handleDelete = (user: User) => {
    if (confirm(`Are you sure you want to delete ${user.name}?`)) {
      deleteItem('users', 'id', user.id);
    }
  };

  const handleSave = () => {
    if (editingUser) {
      updateItem('users', 'id', editingUser.id, formData);
    } else {
      addItem('users', {
        ...formData,
        id: `u${Date.now()}`
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
          <h1 className="text-display-md">Users</h1>
          <p className="text-body-sm">Manage Riders and Drivers, review KYC status.</p>
        </div>
        <button className="pill-btn" onClick={handleOpenNew}>+ Add User</button>
      </div>

      <DataTable 
        data={users}
        keyExtractor={u => u.id}
        onEdit={handleOpenEdit}
        onDelete={handleDelete}
        columns={[
          { header: 'ID', accessor: 'id' },
          { header: 'Name', accessor: 'name' },
          { header: 'Role', accessor: 'role' },
          { 
            header: 'Status', 
            accessor: (u) => (
              <span style={{ 
                padding: '4px 8px', borderRadius: '4px', fontSize: '12px', fontWeight: 600,
                background: u.status === 'Active' ? '#e6f4ea' : u.status === 'Pending KYC' ? '#fef7e0' : '#fce8e6',
                color: u.status === 'Active' ? '#1e8e3e' : u.status === 'Pending KYC' ? '#f9ab00' : '#d93025'
              }}>
                {u.status}
              </span>
            ) 
          },
        ]}
      />

      <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} title={editingUser ? "Edit User" : "New User"}>
        <div>
          <label className="text-body-sm">Full Name</label>
          <input style={inputStyle} value={formData.name} onChange={e => setFormData({...formData, name: e.target.value})} placeholder="Alice Smith" />
          
          <label className="text-body-sm">Role</label>
          <select style={inputStyle} value={formData.role} onChange={e => setFormData({...formData, role: e.target.value as any})}>
            <option>Rider</option>
            <option>Driver</option>
          </select>

          <label className="text-body-sm">Status</label>
          <select style={inputStyle} value={formData.status} onChange={e => setFormData({...formData, status: e.target.value as any})}>
            <option>Active</option>
            <option>Pending KYC</option>
            <option>Suspended</option>
          </select>

          <button className="pill-btn" style={{ width: '100%', marginTop: '16px' }} onClick={handleSave}>
            {editingUser ? "Save Changes" : "Create User"}
          </button>
        </div>
      </Modal>
    </div>
  );
};
