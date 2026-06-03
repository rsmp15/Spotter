import React, { useState } from 'react';
import { useAdmin } from '../context/AdminContext';
import type { RemoteConfigFlag } from '../data/Database';
import { DataTable } from '../components/DataTable';
import { Modal } from '../components/Modal';

export const RemoteConfigManager: React.FC = () => {
  const { remoteConfigs, addItem, updateItem, deleteItem } = useAdmin();
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingFlag, setEditingFlag] = useState<RemoteConfigFlag | null>(null);

  const [formData, setFormData] = useState<Partial<RemoteConfigFlag>>({
    key: '', value: '', type: 'string'
  });

  const handleOpenNew = () => {
    setEditingFlag(null);
    setFormData({ key: '', value: '', type: 'string' });
    setIsModalOpen(true);
  };

  const handleOpenEdit = (flag: RemoteConfigFlag) => {
    setEditingFlag(flag);
    setFormData(flag);
    setIsModalOpen(true);
  };

  const handleDelete = (flag: RemoteConfigFlag) => {
    if (confirm(`Are you sure you want to delete flag ${flag.key}?`)) {
      deleteItem('remoteConfigs', 'key', flag.key);
    }
  };

  const handleSave = () => {
    let finalValue: any = formData.value;
    if (formData.type === 'boolean') finalValue = formData.value === 'true' || formData.value === true;
    if (formData.type === 'number') finalValue = Number(formData.value);

    const payload = {
      ...formData,
      value: finalValue
    };

    if (editingFlag) {
      updateItem('remoteConfigs', 'key', editingFlag.key, payload);
    } else {
      addItem('remoteConfigs', payload);
    }
    setIsModalOpen(false);
  };

  const inputStyle = {
    width: '100%', padding: '12px', border: '1px solid var(--line)',
    borderRadius: 'var(--rounded-md)', marginBottom: '16px', background: 'var(--canvas-soft)', color: 'var(--ink)'
  };

  // Convert array back to object for preview
  const jsonPreview = remoteConfigs.reduce((acc, flag) => ({...acc, [flag.key]: flag.value}), {});

  return (
    <div style={{ display: 'flex', gap: '32px', height: '100%', alignItems: 'flex-start' }}>
      <div style={{ flex: 2 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '24px' }}>
          <div>
            <h1 className="text-display-md">Remote Config</h1>
            <p className="text-body-sm">Manage dynamic feature flags.</p>
          </div>
          <button className="pill-btn" onClick={handleOpenNew}>+ Add Flag</button>
        </div>

        <DataTable 
          data={remoteConfigs}
          keyExtractor={c => c.key}
          onEdit={handleOpenEdit}
          onDelete={handleDelete}
          columns={[
            { header: 'Key', accessor: 'key' },
            { header: 'Type', accessor: 'type' },
            { header: 'Value', accessor: (c) => String(c.value) },
          ]}
        />
      </div>

      <div style={{ flex: 1 }}>
        <div className="card" style={{ height: 'auto', display: 'flex', flexDirection: 'column' }}>
          <h3 className="text-body-lg" style={{ marginBottom: '16px' }}>Payload Preview</h3>
          <p className="text-body-sm" style={{ marginBottom: '16px' }}>
            This JSON represents the current state of all flags.
          </p>
          <pre style={{
            background: 'var(--canvas-soft)', padding: '16px', borderRadius: 'var(--rounded-md)',
            overflowX: 'auto', fontSize: '14px', color: 'var(--ink)'
          }}>
            {JSON.stringify(jsonPreview, null, 2)}
          </pre>
        </div>
      </div>

      <Modal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} title={editingFlag ? "Edit Flag" : "New Flag"}>
        <div>
          <label className="text-body-sm">Key</label>
          <input 
            style={inputStyle} 
            value={formData.key} 
            onChange={e => setFormData({...formData, key: e.target.value})} 
            placeholder="e.g., show_promo_banner"
            disabled={!!editingFlag} // Don't allow changing key when editing
          />

          <label className="text-body-sm">Type</label>
          <select style={inputStyle} value={formData.type} onChange={e => setFormData({...formData, type: e.target.value as any})}>
            <option value="string">String</option>
            <option value="boolean">Boolean</option>
            <option value="number">Number</option>
          </select>

          <label className="text-body-sm">Value</label>
          {formData.type === 'boolean' ? (
            <select style={inputStyle} value={String(formData.value)} onChange={e => setFormData({...formData, value: e.target.value})}>
              <option value="true">True</option>
              <option value="false">False</option>
            </select>
          ) : (
            <input 
              style={inputStyle} 
              type={formData.type === 'number' ? 'number' : 'text'}
              value={String(formData.value || '')} 
              onChange={e => setFormData({...formData, value: e.target.value})} 
            />
          )}

          <button className="pill-btn" style={{ width: '100%', marginTop: '16px' }} onClick={handleSave}>
            {editingFlag ? "Save Changes" : "Create Flag"}
          </button>
        </div>
      </Modal>
    </div>
  );
};
