import React from 'react';
import { Menu, Bell, ShieldCheck, User } from 'lucide-react';

interface HeaderProps {
  onMenuToggle: () => void;
  adminName?: string;
  adminEmail?: string;
}

export const Header: React.FC<HeaderProps> = ({ 
  onMenuToggle, 
  adminName = 'Super Administrator',
  adminEmail = 'admin@aquapure.com'
}) => {
  return (
    <header className="h-16 bg-white border-b border-slate-200 px-4 sm:px-6 flex items-center justify-between sticky top-0 z-30">
      <div className="flex items-center gap-3">
        <button
          onClick={onMenuToggle}
          className="p-2 -ml-2 text-slate-600 hover:text-slate-900 rounded-lg lg:hidden"
          aria-label="Toggle Navigation"
        >
          <Menu className="w-5 h-5" />
        </button>
        <div className="flex items-center gap-2">
          <span className="hidden sm:inline-flex items-center gap-1.5 px-2.5 py-1 bg-sky-50 text-sky-700 text-xs font-semibold rounded-md border border-sky-200">
            <ShieldCheck className="w-3.5 h-3.5" />
            Verified Administrator Access
          </span>
        </div>
      </div>

      <div className="flex items-center gap-4">
        {/* Quick status pill */}
        <div className="hidden md:flex items-center gap-2 text-xs text-slate-500 bg-slate-100 px-3 py-1.5 rounded-full">
          <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
          <span>Firestore Realtime Sync</span>
        </div>

        {/* User profile preview */}
        <div className="flex items-center gap-3 pl-2 border-l border-slate-200">
          <div className="w-8 h-8 rounded-full bg-sky-600 text-white flex items-center justify-center font-bold text-xs">
            AP
          </div>
          <div className="hidden sm:block text-left">
            <div className="text-xs font-semibold text-slate-800">{adminName}</div>
            <div className="text-[11px] text-slate-500">{adminEmail}</div>
          </div>
        </div>
      </div>
    </header>
  );
};
