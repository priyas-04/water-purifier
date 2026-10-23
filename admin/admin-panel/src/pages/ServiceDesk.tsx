import React, { useState, useEffect } from 'react';
import { 
  Wrench, 
  Search, 
  Calendar, 
  Clock, 
  User, 
  Phone, 
  MapPin, 
  CheckCircle2, 
  X 
} from 'lucide-react';
import { mockService } from '../services/mockData';
import { ServiceBooking, ServiceStatus } from '../types';
import { StatusBadge } from '../components/StatusBadge';

export const ServiceDesk: React.FC = () => {
  const [bookings, setBookings] = useState<ServiceBooking[]>([]);
  const [filteredBookings, setFilteredBookings] = useState<ServiceBooking[]>([]);
  const [selectedStatus, setSelectedStatus] = useState<string>('all');
  const [searchQuery, setSearchQuery] = useState('');

  // Assign Technician Modal
  const [assigningBooking, setAssigningBooking] = useState<ServiceBooking | null>(null);
  const [techName, setTechName] = useState('');
  const [techPhone, setTechPhone] = useState('');
  const [serviceNotes, setServiceNotes] = useState('');

  const loadBookings = () => {
    setBookings(mockService.getServiceBookings());
  };

  useEffect(() => {
    loadBookings();
  }, []);

  useEffect(() => {
    let result = [...bookings];

    if (selectedStatus !== 'all') {
      result = result.filter(b => b.status === selectedStatus);
    }

    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      result = result.filter(b =>
        b.customerName.toLowerCase().includes(q) ||
        b.customerPhone.includes(q) ||
        b.id.toLowerCase().includes(q) ||
        b.serviceType.toLowerCase().includes(q)
      );
    }

    setFilteredBookings(result);
  }, [bookings, selectedStatus, searchQuery]);

  const handleOpenAssignModal = (booking: ServiceBooking) => {
    setAssigningBooking(booking);
    setTechName(booking.technicianName || 'Manoj Gowda');
    setTechPhone(booking.technicianPhone || '+91 94481 00223');
    setServiceNotes(booking.serviceNotes || '');
  };

  const handleSaveTechnician = (e: React.FormEvent) => {
    e.preventDefault();
    if (!assigningBooking) return;

    mockService.updateServiceBooking(assigningBooking.id, {
      technicianName: techName,
      technicianPhone: techPhone,
      serviceNotes: serviceNotes,
      status: 'technician_assigned',
    });

    setAssigningBooking(null);
    loadBookings();
  };

  const handleStatusChange = (id: string, newStatus: ServiceStatus) => {
    mockService.updateServiceBooking(id, { status: newStatus });
    loadBookings();
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h2 className="text-xl font-bold font-['Outfit'] text-slate-800">Customer Service Desk ({bookings.length})</h2>
        <p className="text-slate-500 text-xs mt-0.5">
          Dispatch certified field engineers for installation, repair, and filter replacement tickets
        </p>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200/80 shadow-sm flex flex-col sm:flex-row gap-4 justify-between items-center">
        <div className="flex items-center gap-2 overflow-x-auto w-full sm:w-auto">
          {[
            { id: 'all', label: 'All Tickets' },
            { id: 'submitted', label: 'Submitted' },
            { id: 'scheduled', label: 'Scheduled' },
            { id: 'technician_assigned', label: 'Assigned' },
            { id: 'in_progress', label: 'In Progress' },
            { id: 'completed', label: 'Completed' },
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

        <div className="w-full sm:w-64">
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search customer, phone, or service..."
            className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500 transition-colors"
          />
        </div>
      </div>

      {/* Bookings Table */}
      <div className="bg-white rounded-2xl border border-slate-200/80 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-xs">
            <thead>
              <tr className="bg-slate-50/80 border-b border-slate-200 text-slate-500 uppercase font-semibold">
                <th className="py-3 px-4">Ticket ID & Service</th>
                <th className="py-3 px-4">Customer Details</th>
                <th className="py-3 px-4">Scheduled Slot</th>
                <th className="py-3 px-4">Assigned Engineer</th>
                <th className="py-3 px-4">Ticket Status</th>
                <th className="py-3 px-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {filteredBookings.map((b) => (
                <tr key={b.id} className="hover:bg-slate-50/50">
                  <td className="py-3.5 px-4">
                    <div className="font-mono font-bold text-slate-800">{b.id}</div>
                    <div className="text-slate-600 font-semibold mt-0.5">{b.serviceType}</div>
                    {b.issueDescription && (
                      <div className="text-[11px] text-slate-400 line-clamp-1 max-w-xs">{b.issueDescription}</div>
                    )}
                  </td>
                  <td className="py-3.5 px-4">
                    <div className="font-bold text-slate-800">{b.customerName}</div>
                    <div className="text-[11px] text-slate-500">{b.customerPhone}</div>
                    <div className="text-[11px] text-slate-400 line-clamp-1 max-w-xs">{b.address.street}, {b.address.city}</div>
                  </td>
                  <td className="py-3.5 px-4">
                    <div className="font-semibold text-slate-800">{b.preferredDate}</div>
                    <div className="text-[11px] text-slate-500">{b.preferredTimeSlot}</div>
                  </td>
                  <td className="py-3.5 px-4">
                    {b.technicianName ? (
                      <div>
                        <div className="font-bold text-slate-800">{b.technicianName}</div>
                        <div className="text-[11px] text-slate-500">{b.technicianPhone}</div>
                      </div>
                    ) : (
                      <span className="text-amber-600 font-semibold text-[11px]">Unassigned</span>
                    )}
                  </td>
                  <td className="py-3.5 px-4">
                    <select
                      value={b.status}
                      onChange={(e) => handleStatusChange(b.id, e.target.value as ServiceStatus)}
                      className="px-2.5 py-1 bg-slate-50 border border-slate-200 rounded-lg text-xs font-semibold focus:outline-none focus:border-sky-500"
                    >
                      <option value="submitted">Submitted</option>
                      <option value="scheduled">Scheduled</option>
                      <option value="technician_assigned">Assigned</option>
                      <option value="in_progress">In Progress</option>
                      <option value="completed">Completed</option>
                      <option value="cancelled">Cancelled</option>
                    </select>
                  </td>
                  <td className="py-3.5 px-4 text-right">
                    <button
                      onClick={() => handleOpenAssignModal(b)}
                      className="px-2.5 py-1 bg-sky-50 text-sky-700 hover:bg-sky-100 font-semibold rounded-lg text-xs transition-colors"
                    >
                      {b.technicianName ? 'Reassign' : 'Assign Engineer'}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Assign Technician Modal */}
      {assigningBooking && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/50 backdrop-blur-sm">
          <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-xl border border-slate-100">
            <div className="flex items-center justify-between pb-4 border-b border-slate-100">
              <h3 className="font-bold text-base text-slate-800 font-['Outfit']">Assign Field Technician</h3>
              <button 
                onClick={() => setAssigningBooking(null)}
                className="text-slate-400 hover:text-slate-600"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSaveTechnician} className="space-y-4 mt-4 text-xs">
              <div>
                <label className="block font-semibold text-slate-700 mb-1">Technician Full Name</label>
                <input
                  type="text"
                  required
                  value={techName}
                  onChange={(e) => setTechName(e.target.value)}
                  className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                />
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">Technician Phone Number</label>
                <input
                  type="text"
                  required
                  value={techPhone}
                  onChange={(e) => setTechPhone(e.target.value)}
                  className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                />
              </div>

              <div>
                <label className="block font-semibold text-slate-700 mb-1">Internal Dispatch Instructions / Notes</label>
                <textarea
                  rows={3}
                  value={serviceNotes}
                  onChange={(e) => setServiceNotes(e.target.value)}
                  placeholder="e.g. Carry sediment filter kit and digital TDS meter..."
                  className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:border-sky-500"
                />
              </div>

              <div className="pt-4 flex items-center justify-end gap-3 border-t border-slate-100">
                <button
                  type="button"
                  onClick={() => setAssigningBooking(null)}
                  className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-xl font-semibold"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-5 py-2 bg-sky-600 hover:bg-sky-500 text-white rounded-xl font-bold shadow-sm"
                >
                  Confirm & Dispatch
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};
