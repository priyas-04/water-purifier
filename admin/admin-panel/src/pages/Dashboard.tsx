import React, { useState, useEffect } from 'react';
import { 
  ShoppingBag, 
  Package, 
  Users, 
  Wrench, 
  TrendingUp, 
  AlertTriangle, 
  CheckCircle, 
  Clock,
  ArrowRight
} from 'lucide-react';
import { Link } from 'react-router-dom';
import { mockService } from '../services/mockData';
import { DashboardStats, Order, DealerApplication } from '../types';
import { StatCard } from '../components/StatCard';
import { StatusBadge } from '../components/StatusBadge';

export const Dashboard: React.FC = () => {
  const [stats, setStats] = useState<DashboardStats | null>(null);
  const [recentOrders, setRecentOrders] = useState<Order[]>([]);
  const [pendingDealers, setPendingDealers] = useState<DealerApplication[]>([]);

  useEffect(() => {
    setStats(mockService.getDashboardStats());
    setRecentOrders(mockService.getOrders().slice(0, 4));
    setPendingDealers(mockService.getDealerApplications().filter(d => d.dealerStatus === 'pending'));
  }, []);

  if (!stats) return null;

  return (
    <div className="space-y-6">
      {/* Top Banner */}
      <div className="bg-gradient-to-r from-slate-900 to-sky-950 rounded-2xl p-6 text-white shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-bold font-['Outfit']">Operations Dashboard</h2>
          <p className="text-slate-300 text-sm mt-1">
            Real-time management for AquaPure water purification systems, wholesale dealers, and customer service.
          </p>
        </div>
        <div className="flex items-center gap-3">
          <Link
            to="/products"
            className="px-4 py-2 bg-sky-500 hover:bg-sky-400 text-slate-950 font-bold text-xs uppercase tracking-wider rounded-xl transition-colors text-center"
          >
            Manage 60 Products
          </Link>
        </div>
      </div>

      {/* KPI Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          title="Total Orders"
          value={stats.totalOrders}
          subtitle={`₹${stats.totalRevenue.toLocaleString('en-IN')} Total Paid Revenue`}
          icon={ShoppingBag}
          color="blue"
        />
        <StatCard
          title="Pending Orders"
          value={stats.pendingOrders}
          subtitle={`${stats.deliveredOrders} orders delivered to date`}
          icon={Clock}
          color="amber"
        />
        <StatCard
          title="Active Products"
          value={stats.activeProducts}
          subtitle={`${stats.lowStockProducts} products low in stock (<=10)`}
          icon={Package}
          color="emerald"
        />
        <StatCard
          title="Pending Dealers"
          value={stats.pendingDealers}
          subtitle={`${stats.pendingServices} active service desk tickets`}
          icon={Users}
          color="purple"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Recent Orders */}
        <div className="lg:col-span-2 bg-white rounded-2xl p-6 border border-slate-200/80 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="font-bold text-slate-800 text-base font-['Outfit']">Recent Customer & Dealer Orders</h3>
              <p className="text-xs text-slate-500">Live order processing and delivery status</p>
            </div>
            <Link to="/orders" className="text-xs font-semibold text-sky-600 hover:text-sky-700 flex items-center gap-1">
              View All <ArrowRight className="w-3.5 h-3.5" />
            </Link>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-slate-100 text-slate-400 uppercase font-semibold">
                  <th className="pb-3">Order ID</th>
                  <th className="pb-3">Customer / Entity</th>
                  <th className="pb-3">Items</th>
                  <th className="pb-3">Total</th>
                  <th className="pb-3">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {recentOrders.map((order) => (
                  <tr key={order.id} className="hover:bg-slate-50/50">
                    <td className="py-3.5 font-mono font-medium text-slate-800">{order.id}</td>
                    <td className="py-3.5">
                      <div className="font-medium text-slate-800">{order.userName}</div>
                      <div className="text-[11px] text-slate-400 capitalize">{order.roleAtOrder}</div>
                    </td>
                    <td className="py-3.5 text-slate-600">
                      {order.items.reduce((s, i) => s + i.quantity, 0)} items
                    </td>
                    <td className="py-3.5 font-bold text-slate-800">
                      ₹{order.totalAmount.toLocaleString('en-IN')}
                    </td>
                    <td className="py-3.5">
                      <StatusBadge status={order.orderStatus} />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Pending Dealer Applications */}
        <div className="bg-white rounded-2xl p-6 border border-slate-200/80 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h3 className="font-bold text-slate-800 text-base font-['Outfit']">Pending Dealers</h3>
              <p className="text-xs text-slate-500">Awaiting wholesale authorization</p>
            </div>
            <Link to="/dealers" className="text-xs font-semibold text-sky-600 hover:text-sky-700 flex items-center gap-1">
              Manage <ArrowRight className="w-3.5 h-3.5" />
            </Link>
          </div>

          {pendingDealers.length === 0 ? (
            <div className="p-8 text-center text-slate-400 text-xs">
              No pending dealer applications. All trade accounts are up to date.
            </div>
          ) : (
            <div className="space-y-3">
              {pendingDealers.map((dealer) => (
                <div key={dealer.uid} className="p-3.5 rounded-xl border border-slate-100 bg-slate-50/60 hover:bg-slate-50 transition-colors">
                  <div className="flex items-start justify-between">
                    <div>
                      <div className="font-bold text-xs text-slate-800">{dealer.companyName}</div>
                      <div className="text-[11px] text-slate-500">{dealer.fullName} • {dealer.phone}</div>
                    </div>
                    <span className="px-2 py-0.5 bg-amber-100 text-amber-800 text-[10px] font-bold rounded">
                      NEW
                    </span>
                  </div>
                  <div className="mt-2 text-[11px] font-mono text-slate-500 bg-white px-2 py-1 rounded border border-slate-200/60">
                    GSTIN: {dealer.gstNumber}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
