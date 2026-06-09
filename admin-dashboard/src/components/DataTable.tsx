import React from 'react';

interface Column<T> {
  header: string;
  accessor: keyof T | ((item: T) => React.ReactNode);
  className?: string;
}

interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  onEdit?: (item: T) => void;
  onDelete?: (item: T) => void;
  keyExtractor: (item: T) => string;
  emptyTitle?: string;
  emptyDesc?: string;
}

export function DataTable<T>({
  data,
  columns,
  onEdit,
  onDelete,
  keyExtractor,
  emptyTitle = 'No records found',
  emptyDesc = 'Add a new entry to get started.',
}: DataTableProps<T>) {
  return (
    <div className="data-table-wrap">
      <table className="data-table">
        <thead>
          <tr>
            {columns.map((col, idx) => (
              <th key={idx}>{col.header}</th>
            ))}
            {(onEdit || onDelete) && (
              <th style={{ textAlign: 'right' }}>Actions</th>
            )}
          </tr>
        </thead>
        <tbody>
          {data.length === 0 ? (
            <tr className="empty-row">
              <td colSpan={columns.length + (onEdit || onDelete ? 1 : 0)}>
                <div className="empty-state">
                  <div className="empty-state-icon">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                      <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2" />
                      <rect x="9" y="3" width="6" height="4" rx="1" />
                    </svg>
                  </div>
                  <div className="empty-state-title">{emptyTitle}</div>
                  <div className="empty-state-desc">{emptyDesc}</div>
                </div>
              </td>
            </tr>
          ) : (
            data.map((item) => (
              <tr key={keyExtractor(item)}>
                {columns.map((col, idx) => (
                  <td key={idx} className={col.className}>
                    {typeof col.accessor === 'function'
                      ? col.accessor(item)
                      : (item[col.accessor] as React.ReactNode)}
                  </td>
                ))}
                {(onEdit || onDelete) && (
                  <td className="actions-cell">
                    {onEdit && (
                      <button className="tbl-action edit" onClick={() => onEdit(item)}>
                        Edit
                      </button>
                    )}
                    {onDelete && (
                      <button className="tbl-action del" onClick={() => onDelete(item)} style={{ marginLeft: 4 }}>
                        Delete
                      </button>
                    )}
                  </td>
                )}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}
