import React from 'react';

interface Column<T> {
  header: string;
  accessor: keyof T | ((item: T) => React.ReactNode);
}

interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  onEdit?: (item: T) => void;
  onDelete?: (item: T) => void;
  keyExtractor: (item: T) => string;
}

export function DataTable<T>({ data, columns, onEdit, onDelete, keyExtractor }: DataTableProps<T>) {
  return (
    <div style={{ overflowX: 'auto', background: 'var(--canvas)', borderRadius: 'var(--rounded-lg)', border: '1px solid var(--line)' }}>
      <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
        <thead>
          <tr style={{ background: 'var(--canvas-soft)', borderBottom: '1px solid var(--line)' }}>
            {columns.map((col, idx) => (
              <th key={idx} style={{ padding: '16px', fontWeight: 600, fontSize: '14px', color: 'var(--mute)' }}>
                {col.header.toUpperCase()}
              </th>
            ))}
            {(onEdit || onDelete) && <th style={{ padding: '16px', textAlign: 'right' }}>ACTIONS</th>}
          </tr>
        </thead>
        <tbody>
          {data.length === 0 ? (
            <tr>
              <td colSpan={columns.length + (onEdit || onDelete ? 1 : 0)} style={{ padding: '24px', textAlign: 'center', color: 'var(--mute)' }}>
                No records found.
              </td>
            </tr>
          ) : data.map(item => (
            <tr key={keyExtractor(item)} style={{ borderBottom: '1px solid var(--line)' }}>
              {columns.map((col, idx) => (
                <td key={idx} style={{ padding: '16px', fontSize: '14px' }}>
                  {typeof col.accessor === 'function' ? col.accessor(item) : (item[col.accessor] as any)}
                </td>
              ))}
              {(onEdit || onDelete) && (
                <td style={{ padding: '16px', textAlign: 'right', display: 'flex', gap: '8px', justifyContent: 'flex-end' }}>
                  {onEdit && (
                    <button onClick={() => onEdit(item)} style={{ cursor: 'pointer', background: 'none', border: 'none', color: 'var(--primary)', fontWeight: 500 }}>
                      Edit
                    </button>
                  )}
                  {onDelete && (
                    <button onClick={() => onDelete(item)} style={{ cursor: 'pointer', background: 'none', border: 'none', color: 'red', fontWeight: 500 }}>
                      Delete
                    </button>
                  )}
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
