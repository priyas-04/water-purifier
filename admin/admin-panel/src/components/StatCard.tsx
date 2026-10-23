import React from 'react';
import { LucideIcon } from 'lucide-react';

interface StatCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon: LucideIcon;
  color?: 'blue' | 'emerald' | 'amber' | 'purple' | 'red';
  onClick?: () => void;
}

export const StatCard: React.FC<StatCardProps> = ({
  title,
  value,
  subtitle,
  icon: Icon,
  color = 'blue',
  onClick,
}) => {
  const colorMap = {
    blue: {
      bg: 'bg-sky-50 text-sky-600 border-sky-100',
      badge: 'text-sky-600',
    },
    emerald: {
      bg: 'bg-emerald-50 text-emerald-600 border-emerald-100',
      badge: 'text-emerald-600',
    },
    amber: {
      bg: 'bg-amber-50 text-amber-600 border-amber-100',
      badge: 'text-amber-600',
    },
    purple: {
      bg: 'bg-purple-50 text-purple-600 border-purple-100',
      badge: 'text-purple-600',
    },
    red: {
      bg: 'bg-rose-50 text-rose-600 border-rose-100',
      badge: 'text-rose-600',
    },
  };

  const selectedColor = colorMap[color];

  return (
    <div
      onClick={onClick}
      className={`bg-white rounded-2xl p-5 border border-slate-200/80 shadow-sm transition-all ${
        onClick ? 'cursor-pointer hover:shadow-md hover:border-slate-300' : ''
      }`}
    >
      <div className="flex items-center justify-between">
        <span className="text-xs font-medium text-slate-500 uppercase tracking-wider">{title}</span>
        <div className={`p-2.5 rounded-xl border ${selectedColor.bg}`}>
          <Icon className="w-5 h-5" />
        </div>
      </div>
      <div className="mt-4">
        <div className="text-2xl font-bold text-slate-800 tracking-tight font-['Outfit']">{value}</div>
        {subtitle && (
          <div className="text-xs text-slate-500 mt-1 font-medium">{subtitle}</div>
        )}
      </div>
    </div>
  );
};
