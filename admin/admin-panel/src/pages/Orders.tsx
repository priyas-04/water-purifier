import React, { useState, useEffect } from 'react';
import { 
  ShoppingBag, 
  Search, 
  Filter, 
  Eye, 
  CheckCircle2, 
  XCircle, 
  Truck, 
  Clock, 
  CreditCard 
} from 'lucide-react';
import { mockService } from '../services/mockData';
import { Order, OrderStatus } from '../types';
import { StatusBadge } from '../components/StatusBadge';
import { ConfirmModal } from '../components/ConfirmModal';

export const Orders: React.FC = () => {
  const [orders, setOrders] = useState<Order[]>([]);
  const [filteredOrders, setFilteredOrders] = useState<Order[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedStatus, setSelectedStatus] = useState<string>('all');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);

  // Status Change Confirmation
  const [statusToChange, setStatusToChange] = useState<{ id: string; nextStatus: OrderStatus } | null>(null);

  const loadOrders = () => {
    setOrders(mockService.getOrders());
  };

  useEffect(() => {
    loadOrders();
  }, []);

  useEffect(() => {
    let result = [...orders];

    if (selectedStatus !== 'all') {
      result = result.filter(o => o.orderStatus === selectedStatus);
    }

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      result = result.filter(o => 
        o.id.toLowerCase().includes(q) ||
        o.userName.toLowerCase().includes(q) ||
        o.userEmail.toLowerCase().includes(q) ||
        o.userPhone.includes(q)
      );
    }

    setFilteredOrders(result);
  }, [orders, searchQuery, selectedStatus]);

  const confirmStatusChange = () => {
    if (!statusToChange) return;
    mockService.updateOrderStatus(statusToChange.id, statusToChange.nextStatus);
    setStatusToChange(null);
    loadOrders();
  };

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-xl font-bold font-['Outfit'] text-slate-800">Order Management ({orders.length})</h2>
          <p className="text-slate-500 text-xs mt-0.5">Track fulfillment, payment reconciliation, and status progression</p>
        </div>
      </div>

      {/* Search & Filter Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200/80 shadow-sm flex flex-col md:flex-row gap-4 justify-between items-center">
        <div className="relative w-full md:w-80">
          <Search className="w-4 h-4 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search by Order ID, customer, email, or phone..."
            className="w-full pl-9 pr-4 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500 transition-colors"
          />
        </div>

        {/* Status Filters */}
        <div className="flex items-center gap-2 overflow-x-auto w-full md:w-auto pb-1 md:pb-0">
          {[
            { id: 'all', label: 'All Orders' },
            { id: 'placed', label: 'Placed' },
            { id: 'confirmed', label: 'Confirmed' },
            { id: 'processing', label: 'Processing' },
            { id: 'shipped', label: 'Shipped' },
            { id: 'delivered', label: 'Delivered' },
            { id: 'cancelled', label: 'Cancelled' },
          ].map((st) => (
            <button
              key={st.id}
              onClick={() => setSelectedStatus(st.id)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition-colors ${
                selectedStatus === st.id
                  ? 'bg-slate-900 text-white'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
              }`}
            >
              {st.label}
            </button>
          ))}
        </div>
      </div>

      {/* Orders Table */}
      <div className="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="bg-slate-50/80 border-b border-slate-200 text-slate-500 uppercase font-semibold">
                <th className="py-3 px-4">Order ID & Date</th>
                <th className="py-3 px-4">Customer / Dealer</th>
                <th className="py-3 px-4">Payment Info</th>
                <th className="py-3 px-4">Total Amount</th>
                <th className="py-3 px-4">Current Status</th>
                <th className="py-3 px-4">Update Status</th>
                <th className="py-3 px-4 text-right">Details</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredOrders.map((order) => (
                <tr key={order.id} className="hover:bg-slate-50/50">
                  <td className="py-3.5 px-4">
                    <div className="font-mono font-bold text-slate-800">{order.id}</div>
                    <div className="text-[11px] text-slate-400 mt-0.5">
                      {new Date(order.createdAt).toLocaleDateString('en-IN', {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                      })}
                    </div>
                  </td>
                  <td className="py-3.5 px-4">
                    <div className="font-bold text-slate-800">{order.userName}</div>
                    <div className="text-[11px] text-slate-500">{order.userEmail}</div>
                    <span className="inline-block mt-1 px-1.5 py-0.5 bg-slate-100 text-slate-600 rounded text-[10px] font-semibold capitalize">
                      {order.roleAtOrder}
                    </span>
                  </td>
                  <td className="py-3.5 px-4">
                    <div className="flex items-center gap-1.5 font-medium text-slate-800">
                      <CreditCard className="w-3.5 h-3.5 text-slate-400" />
                      <span className="capitalize">{order.paymentMethod.replace('_', ' ')}</span>
                    </div>
                    <div className={`text-[11px] font-semibold mt-0.5 ${order.paymentStatus === 'paid' ? 'text-emerald-600' : 'text-slate-500'}`}>
                      {order.paymentStatus.toUpperCase()}
                    </div>
                  </td>
                  <td className="py-3.5 px-4 font-bold text-slate-800 text-sm">
                    ₹{order.totalAmount.toLocaleString('en-IN')}
                  </td>
                  <td className="py-3.5 px-4">
                    <StatusBadge status={order.orderStatus} />
                  </td>
                  <td className="py-3.5 px-4">
                    <select
                      value={order.orderStatus}
                      onChange={(e) => setStatusToChange({ id: order.id, nextStatus: e.target.value as OrderStatus })}
                      className="px-2.5 py-1 bg-slate-50 border border-slate-200 rounded-lg text-xs font-semibold focus:outline-none focus:border-sky-500"
                    >
                      <option value="placed">Placed</option>
                      <option value="confirmed">Confirmed</option>
                      <option value="processing">Processing</option>
                      <option value="shipped">Shipped</option>
                      <option value="delivered">Delivered</option>
                      <option value="cancelled">Cancelled</option>
                    </select>
                  </td>
                  <td className="py-3.5 px-4 text-right">
                    <button
                      onClick={() => setSelectedOrder(order)}
                      className="p-1.5 text-slate-600 hover:text-sky-600 hover:bg-sky-50 rounded-lg transition-colors"
                      title="View Order Details"
                    >
                      <Eye className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Order Detail Modal */}
      {selectedOrder && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm overflow-y-auto">
          <div className="bg-white rounded-2xl max-w-xl w-full p-6 shadow-xl border border-slate-100 my-8">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100">
              <div>
                <h3 className="font-bold text-base text-slate-800 font-['Outfit']">Order Details</h3>
                <p className="text-xs font-mono text-slate-500 mt-0.5">{selectedOrder.id}</p>
              </div>
              <button 
                onClick={() => setSelectedOrder(null)}
                className="text-slate-400 hover:text-slate-600 text-sm font-semibold"
              >
                Close
              </button>
            </div>

            <div className="space-y-4 mt-4 text-xs">
              {/* Shipping Address Snapshot */}
              <div className="p-3 bg-slate-50 rounded-xl border border-slate-100">
                <div className="font-semibold text-slate-700 uppercase tracking-wider text-[10px] mb-1">
                  Delivery Destination
                </div>
                <div className="font-bold text-slate-800">{selectedOrder.userName} ({selectedOrder.userPhone})</div>
                <div className="text-slate-600 mt-0.5">
                  {selectedOrder.shippingAddress.street}, {selectedOrder.shippingAddress.city}, {selectedOrder.shippingAddress.state} - {selectedOrder.shippingAddress.postalCode}
                </div>
              </div>

              {/* Items Breakdown */}
              <div>
                <div className="font-semibold text-slate-700 uppercase tracking-wider text-[10px] mb-2">
                  Purchased Items ({selectedOrder.items.length})
                </div>
                <div className="space-y-2">
                  {selectedOrder.items.map((item, idx) => (
                    <div key={idx} className="flex items-center justify-between p-2.5 rounded-xl border border-slate-100">
                      <div className="flex items-center gap-2.5">
                        <img src={item.imageUrl} alt="" className="w-9 h-9 rounded object-cover border border-slate-200" />
                        <div>
                          <div className="font-bold text-slate-800">{item.productName}</div>
                          <div className="text-slate-500 text-[11px]">Qty: {item.quantity} × ₹{item.unitPrice.toLocaleString('en-IN')}</div>
                        </div>
                      </div>
                      <div className="font-bold text-slate-800">
                        ₹{item.totalPrice.toLocaleString('en-IN')}
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Price Calculation Summary */}
              <div className="pt-3 border-t border-slate-100 space-y-1.5">
                <div className="flex justify-between text-slate-500">
                  <span>Subtotal</span>
                  <span>₹{selectedOrder.subtotal.toLocaleString('en-IN')}</span>
                </div>
                <div className="flex justify-between text-slate-500">
                  <span>Shipping Fee</span>
                  <span>{selectedOrder.shippingCharge === 0 ? 'FREE' : `₹${selectedOrder.shippingCharge}`}</span>
                </div>
                <div className="flex justify-between font-bold text-sm text-slate-800 pt-1 border-t border-slate-100">
                  <span>Total Amount</span>
                  <span>₹{selectedOrder.totalAmount.toLocaleString('en-IN')}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Confirmation Modal */}
      <ConfirmModal
        isOpen={Boolean(statusToChange)}
        title="Update Order Status"
        message={`Are you sure you want to transition order ${statusToChange?.id} to "${statusToChange?.nextStatus.toUpperCase()}"? Customers and tracking logs will be updated immediately.`}
        confirmText="Yes, Update Status"
        onConfirm={confirmStatusChange}
        onCancel={() => setStatusToChange(null)}
      />
    </div>
  );
};
