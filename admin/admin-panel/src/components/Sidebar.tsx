import React from 'react';
import { NavLink } from 'react-router-dom';
import { 
  LayoutDashboard, 
  Package, 
  ShoppingBag, 
  Users, 
  Wrench, 
  Bot, 
  Droplet,
  ExternalLink
} from 'lucide-react';

interface SidebarProps {
  isOpen: boolean;
  onClose: () => void;
}

export const Sidebar: React.FC<SidebarProps> = ({ isOpen, onClose }) => {
  const navItems = [
    { to: '/', label: 'Dashboard Overview', icon: LayoutDashboard },
    { to: '/products', label: 'Product Catalog (60)', icon: Package },
    { to: '/orders', label: 'Order Processing', icon: ShoppingBag },
    { to: '/dealers', label: 'Dealer Approvals', icon: Users },
    { to: '/service-desk', label: 'Service Desk', icon: Wrench },
    { to: '/automation', label: 'AI Marketing & Logs', icon: Bot },
  ];

  return (
    <>
      {/* Mobile Backdrop */}
      {isOpen && (
        <div 
          className="fixed inset-0 bg-black/40 z-40 lg:hidden"
          onClick={onClose}
        />
      )}

      <aside className={`
        fixed top-0 bottom-0 left-0 z-50 w-64 bg-slate-900 text-white flex flex-col transition-transform duration-200 ease-in-out
        lg:translate-x-0 ${isOpen ? 'translate-x-0' : '-translate-x-full'}
      `}>
        {/* Brand Header */}
        <div className="h-16 px-6 flex items-center gap-3 border-b border-slate-800">
          <div className="p-2 bg-sky-500 rounded-lg text-white">
            <Droplet className="w-5 h-5 fill-current" />
          </div>
          <div>
            <h1 className="font-bold text-lg tracking-tight font-['Outfit']">AquaPure</h1>
            <p className="text-xs text-sky-400 font-medium">Operations Dashboard</p>
          </div>
        </div>

        {/* Navigation Items */}
        <div className="flex-1 py-6 px-3 space-y-1 overflow-y-auto">
          <div className="px-3 mb-2 text-xs font-semibold uppercase tracking-wider text-slate-400">
            Management
          </div>
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <NavLink
                key={item.to}
                to={item.to}
                onClick={onClose}
                className={({ isActive }) => `
                  flex items-center gap-3 px-3 py-2.5 rounded-xl font-medium text-sm transition-colors
                  ${isActive 
                    ? 'bg-sky-600 text-white shadow-sm' 
                    : 'text-slate-300 hover:bg-slate-800 hover:text-white'
                  }
                `}
              >
                <Icon className="w-4 h-4" />
                <span>{item.label}</span>
              </NavLink>
            );
          })}
        </div>

        {/* Footer info */}
        <div className="p-4 border-t border-slate-800 bg-slate-950/50">
          <div className="flex items-center justify-between text-xs text-slate-400 mb-2">
            <span>Environment</span>
            <span className="px-2 py-0.5 bg-emerald-500/20 text-emerald-400 rounded-full font-medium">Live Demo</span>
          </div>
          <div className="text-xs text-slate-500">
            Version 1.0.0 • AquaPure Enterprise
          </div>
        </div>
      </aside>
    </>
  );
};
