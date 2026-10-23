import React from 'react';
import { OrderStatus, DealerStatus, ServiceStatus } from '../types';

interface StatusBadgeProps {
  status: OrderStatus | DealerStatus | ServiceStatus | string;
  type?: 'order' | 'dealer' | 'service';
}

export const StatusBadge: React.FC<StatusBadgeProps> = ({ status, type = 'order' }) => {
  let bg = 'bg-slate-100 text-slate-700 border-slate-200';
  let label = status.toString().replace('_', ' ').toUpperCase();

  switch (status) {
    // Orders & Services
    case 'placed':
    case 'submitted':
      bg = 'bg-blue-50 text-blue-700 border-blue-200';
      break;
    case 'confirmed':
    case 'scheduled':
      bg = 'bg-teal-50 text-teal-700 border-teal-200';
      break;
    case 'processing':
    case 'technician_assigned':
    case 'in_progress':
      bg = 'bg-amber-50 text-amber-700 border-amber-200';
      break;
    case 'shipped':
      bg = 'bg-indigo-50 text-indigo-700 border-indigo-200';
      break;
    case 'delivered':
    case 'completed':
    case 'approved':
      bg = 'bg-emerald-50 text-emerald-700 border-emerald-200';
      break;
    case 'cancelled':
    case 'rejected':
      bg = 'bg-rose-50 text-rose-700 border-rose-200';
      break;
    case 'pending':
      bg = 'bg-amber-50 text-amber-800 border-amber-200';
      label = 'PENDING APPROVAL';
      break;
    default:
      break;
  }

  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-semibold border ${bg}`}>
      {label}
    </span>
  );
};
