import React, { createContext, useContext, useState, useEffect } from 'react';
import { MockDatabase } from '../data/Database';
import type { User, Trip, SupportCase, RemoteConfigFlag } from '../data/Database';

interface AdminContextType {
  users: User[];
  trips: Trip[];
  supportCases: SupportCase[];
  remoteConfigs: RemoteConfigFlag[];
  
  // Generic CRUD
  addItem: (collection: 'users'|'trips'|'supportCases'|'remoteConfigs', item: any) => void;
  updateItem: (collection: 'users'|'trips'|'supportCases'|'remoteConfigs', idField: string, id: string, updates: any) => void;
  deleteItem: (collection: 'users'|'trips'|'supportCases'|'remoteConfigs', idField: string, id: string) => void;
}

const AdminContext = createContext<AdminContextType | undefined>(undefined);

export const AdminProvider: React.FC<{children: React.ReactNode}> = ({ children }) => {
  const [data, setData] = useState(MockDatabase.loadData());

  useEffect(() => {
    MockDatabase.saveData(data);
  }, [data]);

  const addItem = (collection: keyof typeof data, item: any) => {
    setData(prev => ({ ...prev, [collection]: [...prev[collection], item] }));
  };

  const updateItem = (collection: keyof typeof data, idField: string, id: string, updates: any) => {
    setData(prev => ({
      ...prev,
      [collection]: (prev[collection] as any[]).map(item => 
        item[idField] === id ? { ...item, ...updates } : item
      )
    }));
  };

  const deleteItem = (collection: keyof typeof data, idField: string, id: string) => {
    setData(prev => ({
      ...prev,
      [collection]: (prev[collection] as any[]).filter(item => item[idField] !== id)
    }));
  };

  return (
    <AdminContext.Provider value={{
      ...data,
      addItem,
      updateItem,
      deleteItem
    }}>
      {children}
    </AdminContext.Provider>
  );
};

export const useAdmin = () => {
  const ctx = useContext(AdminContext);
  if (!ctx) throw new Error("useAdmin must be used within AdminProvider");
  return ctx;
};
