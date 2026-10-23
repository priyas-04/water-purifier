import React, { useState, useEffect } from 'react';
import { 
  Users, 
  Search, 
  CheckCircle, 
  XCircle, 
  Building2, 
  FileCheck, 
  Clock, 
  AlertCircle 
} from 'lucide-react';
import { mockService } from '../services/mockData';
import { DealerApplication, DealerStatus } from '../types';
import { StatusBadge } from '../components/StatusBadge';
import { ConfirmModal } from '../components/ConfirmModal';

export const Dealers: React.FC = () => {
  const [dealers, setDealers] = useState<DealerApplication[]>([]);
  const [filteredDealers, setFilteredDealers] = useState<DealerApplication[]>([]);
  const [activeTab, setActiveTab] = useState<'all' | DealerStatus>('pending');
  const [searchQuery, setSearchQuery] = useState('');

  // Confirmation Modals
  const [actionToConfirm, setActionToConfirm] = useState<{
    uid: string;
    companyName: string;
    action: 'approved' | 'rejected';
  } | null>(null);

  const loadDealers = () => {
    setDealers(mockService.getDealerApplications());
  };

  useEffect(() => {
    loadDealers();
  }, []);

  useEffect(() => {
    let result = [...dealers];

    if (activeTab !== 'all') {
      result = result.filter(d => d.dealerStatus === activeTab);
    }

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      result = result.filter(d =>
        d.companyName.toLowerCase().includes(q) ||
        d.fullName.toLowerCase().includes(q) ||
        d.gstNumber.toLowerCase().includes(q) ||
        d.email.toLowerCase().includes(q) ||
        d.phone.includes(q)
      );
    }

    setFilteredDealers(result);
  }, [dealers, activeTab, searchQuery]);

  const handleConfirmAction = () => {
    if (!actionToConfirm) return;
    mockService.updateDealerStatus(actionToConfirm.uid, actionToConfirm.action);
    setActionToConfirm(null);
    loadDealers();
  };

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div>
        <h2 className="text-xl font-bold font-['Outfit'] text-slate-800">Dealer Partnership Desk</h2>
        <p className="text-slate-500 text-xs mt-0.5">
          Review business credentials, verify GST registrations, and unlock wholesale pricing tiers
        </p>
      </div>

      {/* Tabs and Search */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200/80 shadow-sm flex flex-col sm:flex-row gap-4 justify-between items-center">
        <div className="flex items-center gap-2 overflow-x-auto w-full sm:w-auto">
          {[
            { id: 'pending', label: 'Pending Review', count: dealers.filter(d => d.dealerStatus === 'pending').length },
            { id: 'approved', label: 'Approved Dealers', count: dealers.filter(d => d.dealerStatus === 'approved').length },
            { id: 'rejected', label: 'Rejected Applications', count: dealers.filter(d => d.dealerStatus === 'rejected').length },
            { id: 'all', label: 'All Partners', count: dealers.length },
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition-colors flex items-center gap-1.5 ${
                activeTab === tab.id
                  ? 'bg-slate-900 text-white'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              <span>{tab.label}</span>
              <span className={`px-1.5 py-0.2 rounded-full text-[10px] ${
                activeTab === tab.id ? 'bg-slate-800 text-slate-200' : 'bg-slate-200 text-slate-700'
              }`}>
                {tab.count}
              </span>
            </button>
          ))}
        </div>

        <div className="w-full sm:w-64">
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search company or GSTIN..."
            className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500 transition-colors"
          />
        </div>
      </div>

      {/* Applications List */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        {filteredDealers.map((dealer) => {
          const isPending = dealer.dealerStatus === 'pending';
          const isApproved = dealer.dealerStatus === 'approved';

          return (
            <div 
              key={dealer.uid}
              className={`bg-white rounded-2xl p-5 border shadow-sm flex flex-col justify-between ${
                isPending ? 'border-amber-200/80 bg-amber-50/10' : 'border-slate-200/80'
              }`}
            >
              <div>
                <div className="flex items-start justify-between gap-3">
                  <div className="flex items-center gap-2.5">
                    <div className="p-2.5 bg-slate-100 text-slate-700 rounded-xl">
                      <Building2 className="w-5 h-5 text-sky-600" />
                    </div>
                    <div>
                      <h3 className="font-bold text-sm text-slate-800">{dealer.companyName}</h3>
                      <p className="text-xs text-slate-500 font-medium">Contact: {dealer.fullName}</p>
                    </div>
                  </div>
                  <StatusBadge status={dealer.dealerStatus} type="dealer" />
                </div>

                <div className="mt-4 space-y-2 text-xs">
                  <div className="p-2.5 bg-slate-50 rounded-xl border border-slate-100">
                    <div className="flex items-center justify-between">
                      <span className="text-slate-400 font-semibold uppercase text-[10px]">GSTIN Registration</span>
                      <span className="font-mono font-bold text-slate-800">{dealer.gstNumber}</span>
                    </div>
                  </div>

                  <div className="text-slate-600 flex items-center justify-between">
                    <span>Email:</span>
                    <span className="font-medium text-slate-800">{dealer.email}</span>
                  </div>
                  <div className="text-slate-600 flex items-center justify-between">
                    <span>Phone:</span>
                    <span className="font-medium text-slate-800">{dealer.phone}</span>
                  </div>
                  <div className="text-slate-600 pt-1 border-t border-slate-100">
                    <span className="block text-[11px] text-slate-400 font-semibold uppercase mb-0.5">Warehouse / Office Address:</span>
                    <span className="text-slate-700 leading-relaxed">{dealer.businessAddress}</span>
                  </div>

                  {dealer.rejectionReason && (
                    <div className="mt-2 p-2 bg-rose-50 text-rose-700 rounded-lg text-[11px] border border-rose-200">
                      Reason: {dealer.rejectionReason}
                    </div>
                  )}
                </div>
              </div>

              {/* Action Buttons for Pending Applications */}
              {isPending && (
                <div className="mt-5 pt-3 border-t border-slate-100 flex items-center justify-end gap-2.5">
                  <button
                    onClick={() => setActionToConfirm({ uid: dealer.uid, companyName: dealer.companyName, action: 'rejected' })}
                    className="px-3.5 py-1.5 text-xs font-semibold text-rose-700 hover:bg-rose-50 rounded-xl border border-rose-200 transition-colors"
                  >
                    Reject Application
                  </button>
                  <button
                    onClick={() => setActionToConfirm({ uid: dealer.uid, companyName: dealer.companyName, action: 'approved' })}
                    className="px-4 py-1.5 text-xs font-bold text-white bg-emerald-600 hover:bg-emerald-500 rounded-xl shadow-sm transition-colors"
                  >
                    Approve Dealer & Wholesale Pricing
                  </button>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(actionToConfirm)}
        title={actionToConfirm?.action === 'approved' ? 'Approve Dealer Application' : 'Reject Dealer Application'}
        message={
          actionToConfirm?.action === 'approved'
            ? `Are you sure you want to approve "${actionToConfirm.companyName}"? They will immediately receive access to wholesale tier pricing and bulk ordering.`
            : `Are you sure you want to reject "${actionToConfirm?.companyName}"? Wholesale privileges will remain locked.`
        }
        confirmText={actionToConfirm?.action === 'approved' ? 'Yes, Approve Dealer' : 'Yes, Reject Application'}
        isDestructive={actionToConfirm?.action === 'rejected'}
        onConfirm={handleConfirmAction}
        onCancel={() => setActionToConfirm(null)}
      />
    </div>
  );
};
