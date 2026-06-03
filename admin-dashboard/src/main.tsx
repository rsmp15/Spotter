import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.tsx';
import './index.css';
import { AdminProvider } from './context/AdminContext.tsx';
import { BrowserRouter } from 'react-router-dom';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <AdminProvider>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </AdminProvider>
  </StrictMode>,
);
