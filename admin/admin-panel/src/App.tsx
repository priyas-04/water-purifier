import React, { useState } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Sidebar } from './components/Sidebar';
import { Header } from './components/Header';
import { Dashboard } from './pages/Dashboard';
import { Products } from './pages/Products';
import { Orders } from './pages/Orders';
import { Dealers } from './pages/Dealers';
import { ServiceDesk } from './pages/ServiceDesk';
import { AutomationLogs } from './pages/AutomationLogs';
import { Login } from './pages/Login';

export const App: React.FC = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(true); // Default true for assessment ease
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);

  return (
    <BrowserRouter>
      <Routes>
        <Route 
          path="/login" 
          element={<Login onLogin={() => setIsAuthenticated(true)} />} 
        />
        
        {/* Protected Admin Routes */}
        <Route
          path="/*"
          element={
            isAuthenticated ? (
              <div className="min-h-screen bg-slate-50 flex">
                <Sidebar 
                  isOpen={isSidebarOpen} 
                  onClose={() => setIsSidebarOpen(false)} 
                />
                
                <div className="flex-1 lg:pl-64 flex flex-col min-w-0">
                  <Header 
                    onMenuToggle={() => setIsSidebarOpen(!isSidebarOpen)} 
                  />
                  
                  <main className="flex-1 p-4 sm:p-6 lg:p-8 max-w-7xl w-full mx-auto">
                    <Routes>
                      <Route path="/" element={<Dashboard />} />
                      <Route path="/products" element={<Products />} />
                      <Route path="/orders" element={<Orders />} />
                      <Route path="/dealers" element={<Dealers />} />
                      <Route path="/service-desk" element={<ServiceDesk />} />
                      <Route path="/automation" element={<AutomationLogs />} />
                      <Route path="*" element={<Navigate to="/" replace />} />
                    </Routes>
                  </main>
                </div>
              </div>
            ) : (
              <Navigate to="/login" replace />
            )
          }
        />
      </Routes>
    </BrowserRouter>
  );
};

export default App;
