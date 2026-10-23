import initialProducts from './productsData.json';
import { Product, Order, OrderStatus, DealerApplication, DealerStatus, ServiceBooking, AutomationLog, DashboardStats } from '../types';

let products: Product[] = (initialProducts as any[]).map(p => ({
  ...p,
  retailPrice: Number(p.retailPrice),
  wholesalePrice: Number(p.wholesalePrice),
  stockQuantity: Number(p.stockQuantity),
  rating: Number(p.rating),
  specifications: p.specifications || {},
}));

let orders: Order[] = [
  {
    id: 'ORD-20261023-1001',
    userId: 'usr-892',
    userEmail: 'priya.sharma@gmail.com',
    userName: 'Priya Sharma',
    userPhone: '+91 98765 12340',
    roleAtOrder: 'customer',
    items: [
      {
        productId: 'AP-RO-001',
        productName: 'AquaPure Copper Pro RO+UV+UF+TDS Water Purifier',
        category: 'purifier',
        imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
        unitPrice: 18499,
        quantity: 1,
        totalPrice: 18499,
      },
    ],
    subtotal: 18499,
    discountAmount: 0,
    shippingCharge: 0,
    totalAmount: 18499,
    shippingAddress: {
      label: 'Home',
      street: 'Flat 304, Palm Meadows, Whitefield',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560066',
    },
    paymentMethod: 'razorpay_test',
    paymentStatus: 'paid',
    razorpayPaymentId: 'pay_test_019283K',
    orderStatus: 'processing',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 5).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'ORD-20261022-1002',
    userId: 'dlr-441',
    userEmail: 'procure@apexwater.in',
    userName: 'Apex Water Distribution LLP',
    userPhone: '+91 94480 99887',
    roleAtOrder: 'dealer',
    items: [
      {
        productId: 'AP-BP-001',
        productName: 'AquaPure High-Torque 75 GPD RO Booster Pump 24V DC',
        category: 'pump',
        imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=800&q=80',
        unitPrice: 1250,
        quantity: 10,
        totalPrice: 12500,
      },
      {
        productId: 'AP-FL-004',
        productName: 'AquaPure 80 GPD High-Rejection RO Membrane Sheet',
        category: 'filter',
        imageUrl: 'https://images.unsplash.com/photo-1584634731339-252c581abfc5?auto=format&fit=crop&w=800&q=80',
        unitPrice: 850,
        quantity: 15,
        totalPrice: 12750,
      },
    ],
    subtotal: 25250,
    discountAmount: 0,
    shippingCharge: 0,
    totalAmount: 25250,
    shippingAddress: {
      label: 'Warehouse',
      street: 'Plot 12, Peenya Industrial Area 2nd Stage',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560058',
    },
    paymentMethod: 'razorpay_test',
    paymentStatus: 'paid',
    razorpayPaymentId: 'pay_test_99214D',
    orderStatus: 'confirmed',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'ORD-20261021-1003',
    userId: 'usr-105',
    userEmail: 'vikram.mehta@gmail.com',
    userName: 'Vikram Mehta',
    userPhone: '+91 97110 55443',
    roleAtOrder: 'customer',
    items: [
      {
        productId: 'AP-FL-015',
        productName: 'AquaPure Complete Annual Maintenance Filter Replacement Kit',
        category: 'filter',
        imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
        unitPrice: 2499,
        quantity: 1,
        totalPrice: 2499,
      },
    ],
    subtotal: 2499,
    discountAmount: 0,
    shippingCharge: 0,
    totalAmount: 2499,
    shippingAddress: {
      label: 'Apartment',
      street: 'Tower B-1201, Green Glen Layout, Bellandur',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560103',
    },
    paymentMethod: 'cash_on_delivery',
    paymentStatus: 'pending',
    orderStatus: 'placed',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 48).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'ORD-20261019-0998',
    userId: 'usr-711',
    userEmail: 'rohit.verma@example.com',
    userName: 'Rohit Verma',
    userPhone: '+91 99880 11223',
    roleAtOrder: 'customer',
    items: [
      {
        productId: 'AP-RO-002',
        productName: 'AquaPure Smart IoT UV+RO Mineral Water Purifier',
        category: 'purifier',
        imageUrl: 'https://images.unsplash.com/photo-1584634731339-252c581abfc5?auto=format&fit=crop&w=800&q=80',
        unitPrice: 22999,
        quantity: 1,
        totalPrice: 22999,
      },
    ],
    subtotal: 22999,
    discountAmount: 0,
    shippingCharge: 0,
    totalAmount: 22999,
    shippingAddress: {
      label: 'Home',
      street: 'Villa 14, Rainbow Drive, Sarjapur Road',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560035',
    },
    paymentMethod: 'razorpay_test',
    paymentStatus: 'paid',
    razorpayPaymentId: 'pay_test_88123A',
    orderStatus: 'delivered',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 96).toISOString(),
    updatedAt: new Date().toISOString(),
  },
];

let dealerApplications: DealerApplication[] = [
  {
    uid: 'dlr-app-001',
    fullName: 'Sanjay Deshmukh',
    companyName: 'AquaTech Water Solutions Pvt Ltd',
    email: 'sanjay@aquatechsolutions.com',
    phone: '+91 98230 45678',
    gstNumber: '27AABCA1234F1Z8',
    businessAddress: 'Shop 4-5, Trade Centre, FC Road, Pune, Maharashtra - 411005',
    dealerStatus: 'pending',
    appliedAt: new Date(Date.now() - 1000 * 60 * 60 * 8).toISOString(),
  },
  {
    uid: 'dlr-app-002',
    fullName: 'Kavita Patel',
    companyName: 'Surat Hydro Pure Agencies',
    email: 'kavita@surathydro.in',
    phone: '+91 98980 12345',
    gstNumber: '24AAACP4567G1Z1',
    businessAddress: 'Ring Road Commercial Hub, Surat, Gujarat - 395002',
    dealerStatus: 'pending',
    appliedAt: new Date(Date.now() - 1000 * 60 * 60 * 18).toISOString(),
  },
  {
    uid: 'dlr-app-003',
    fullName: 'Rajesh Naidu',
    companyName: 'Apex Water Distribution LLP',
    email: 'procure@apexwater.in',
    phone: '+91 94480 99887',
    gstNumber: '29AAAAA0000A1Z5',
    businessAddress: 'Plot 12, Peenya Industrial Area 2nd Stage, Bangalore - 560058',
    dealerStatus: 'approved',
    appliedAt: new Date(Date.now() - 1000 * 60 * 60 * 72).toISOString(),
    reviewedAt: new Date(Date.now() - 1000 * 60 * 60 * 48).toISOString(),
  },
  {
    uid: 'dlr-app-004',
    fullName: 'Manoj Tiwari',
    companyName: 'Shree Water Services (Individual Plumber)',
    email: 'manoj.plumbing@gmail.com',
    phone: '+91 91234 56789',
    gstNumber: 'INVALID_GSTIN_123',
    businessAddress: 'Old Delhi Road, Gurgaon, Haryana',
    dealerStatus: 'rejected',
    appliedAt: new Date(Date.now() - 1000 * 60 * 60 * 120).toISOString(),
    reviewedAt: new Date(Date.now() - 1000 * 60 * 60 * 90).toISOString(),
    rejectionReason: 'Invalid GSTIN number; commercial dealer wholesale tier requires active verified enterprise registration.',
  },
];

let serviceBookings: ServiceBooking[] = [
  {
    id: 'SRV-20261023-01',
    userId: 'usr-892',
    customerName: 'Priya Sharma',
    customerPhone: '+91 98765 12340',
    serviceType: 'Installation',
    preferredDate: '2026-10-24',
    preferredTimeSlot: 'Morning (09:00 AM - 12:00 PM)',
    address: {
      street: 'Flat 304, Palm Meadows, Whitefield',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560066',
    },
    issueDescription: 'New AquaPure Copper Pro RO unit standard countertop wall installation.',
    status: 'scheduled',
    technicianName: 'Manoj Gowda',
    technicianPhone: '+91 94481 00223',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 4).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'SRV-20261022-02',
    userId: 'usr-331',
    customerName: 'Amit Bansal',
    customerPhone: '+91 98112 33445',
    serviceType: 'Filter Replacement',
    preferredDate: '2026-10-25',
    preferredTimeSlot: 'Afternoon (12:00 PM - 03:00 PM)',
    address: {
      street: 'B-403, Sobha City, Thanisandra',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560077',
    },
    issueDescription: 'Annual maintenance. RO membrane and sediment cartridge replacement needed.',
    status: 'technician_assigned',
    technicianName: 'Suresh Kumar',
    technicianPhone: '+91 94488 12345',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 20).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'SRV-20261021-03',
    userId: 'usr-554',
    customerName: 'Meenakshi Sundaram',
    customerPhone: '+91 97400 66778',
    serviceType: 'Leakage / Repair',
    preferredDate: '2026-10-23',
    preferredTimeSlot: 'Express Emergency Slot',
    address: {
      street: 'Villa 9, Prestige Ferns, Bellandur',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560103',
    },
    issueDescription: 'Minor pipe elbow dripping under the kitchen sink.',
    status: 'in_progress',
    technicianName: 'Ravi Shankar',
    technicianPhone: '+91 99001 22334',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 28).toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'SRV-20261019-04',
    userId: 'usr-105',
    customerName: 'Vikram Mehta',
    customerPhone: '+91 97110 55443',
    serviceType: 'Routine Maintenance',
    preferredDate: '2026-10-20',
    preferredTimeSlot: 'Morning (09:00 AM - 12:00 PM)',
    address: {
      street: 'Tower B-1201, Green Glen Layout, Bellandur',
      city: 'Bangalore',
      state: 'Karnataka',
      postalCode: '560103',
    },
    issueDescription: 'TDS audit and routine internal sanitization.',
    status: 'completed',
    technicianName: 'Suresh Kumar',
    technicianPhone: '+91 94488 12345',
    serviceNotes: 'TDS calibrated from 450 ppm raw water to 75 ppm drinking water. System sanitized.',
    createdAt: new Date(Date.now() - 1000 * 60 * 60 * 90).toISOString(),
    updatedAt: new Date().toISOString(),
  },
];

let automationLogs: AutomationLog[] = [
  {
    id: 'LOG-20261023-01',
    productId: 'AP-RO-001',
    productName: 'AquaPure Copper Pro RO+UV+UF+TDS Water Purifier',
    timestamp: '2026-10-23T09:00:00.000Z',
    channel: 'instagram',
    caption: 'Pure health in every drop! 💧 Infuse your daily hydration with natural active copper and crisp alkaline minerals. Experience 99.9% virus and heavy metal protection with the AquaPure Copper Pro. #AquaPure #CopperWater #AlkalineWater #WaterPurifier #PureHydration',
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
    postIdentifier: '18029384756201948',
    status: 'success',
  },
  {
    id: 'LOG-20261022-02',
    productId: 'AP-WD-002',
    productName: 'AquaPure Bottom-Loading Ergonomic Water Dispenser',
    timestamp: '2026-10-22T09:00:00.000Z',
    channel: 'instagram',
    caption: 'Say goodbye to heavy bottle lifting! 🚀 The AquaPure Bottom-Loading Dispenser lets you slide heavy 20L jars directly into the base with zero back strain. Instant iced cold & piping hot water. #AquaPure #WaterDispenser #OfficeHydration #HomeComfort',
    imageUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?auto=format&fit=crop&w=800&q=80',
    postIdentifier: '18039485726194837',
    status: 'success',
  },
  {
    id: 'LOG-20261021-03',
    productId: 'AP-BP-001',
    productName: 'AquaPure High-Torque 75 GPD RO Booster Pump 24V DC',
    timestamp: '2026-10-21T09:00:00.000Z',
    channel: 'instagram',
    caption: 'Upgrade your purifier pressure! ⚡ 100% electrolytic copper wound 75 GPD booster pump delivers quiet, leak-free high pressure for dense RO membranes. #AquaPure #BoosterPump #ROComponents #PlumbingLife',
    imageUrl: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?auto=format&fit=crop&w=800&q=80',
    postIdentifier: '18048392019284756',
    status: 'success',
  },
];

export const mockService = {
  // Products
  getProducts: (): Product[] => [...products],
  getProduct: (id: string): Product | undefined => products.find(p => p.id === id),
  createProduct: (product: Omit<Product, 'createdAt' | 'updatedAt'>): Product => {
    const newProduct: Product = {
      ...product,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    products.unshift(newProduct);
    return newProduct;
  },
  updateProduct: (id: string, updates: Partial<Product>): Product | null => {
    const idx = products.findIndex(p => p.id === id);
    if (idx === -1) return null;
    products[idx] = { ...products[idx], ...updates, updatedAt: new Date().toISOString() };
    return products[idx];
  },
  deleteProduct: (id: string): boolean => {
    const initialLen = products.length;
    products = products.filter(p => p.id !== id);
    return products.length < initialLen;
  },

  // Orders
  getOrders: (): Order[] => [...orders],
  getOrder: (id: string): Order | undefined => orders.find(o => o.id === id),
  updateOrderStatus: (id: string, status: OrderStatus): Order | null => {
    const idx = orders.findIndex(o => o.id === id);
    if (idx === -1) return null;
    orders[idx] = {
      ...orders[idx],
      orderStatus: status,
      updatedAt: new Date().toISOString(),
    };
    return orders[idx];
  },

  // Dealers
  getDealerApplications: (): DealerApplication[] => [...dealerApplications],
  updateDealerStatus: (uid: string, status: DealerStatus, reason?: string): DealerApplication | null => {
    const idx = dealerApplications.findIndex(d => d.uid === uid);
    if (idx === -1) return null;
    dealerApplications[idx] = {
      ...dealerApplications[idx],
      dealerStatus: status,
      reviewedAt: new Date().toISOString(),
      rejectionReason: reason,
    };
    return dealerApplications[idx];
  },

  // Service Desk
  getServiceBookings: (): ServiceBooking[] => [...serviceBookings],
  updateServiceBooking: (id: string, updates: Partial<ServiceBooking>): ServiceBooking | null => {
    const idx = serviceBookings.findIndex(s => s.id === id);
    if (idx === -1) return null;
    serviceBookings[idx] = { ...serviceBookings[idx], ...updates, updatedAt: new Date().toISOString() };
    return serviceBookings[idx];
  },

  // Automation Logs
  getAutomationLogs: (): AutomationLog[] => [...automationLogs],

  // Dashboard Metrics
  getDashboardStats: (): DashboardStats => {
    const totalOrders = orders.length;
    const pendingOrders = orders.filter(o => o.orderStatus === 'placed' || o.orderStatus === 'confirmed' || o.orderStatus === 'processing').length;
    const deliveredOrders = orders.filter(o => o.orderStatus === 'delivered').length;
    const totalRevenue = orders.reduce((sum, o) => sum + (o.paymentStatus === 'paid' ? o.totalAmount : 0), 0);
    const totalProducts = products.length;
    const activeProducts = products.filter(p => p.isActive).length;
    const lowStockProducts = products.filter(p => p.stockQuantity <= 10).length;
    const pendingDealers = dealerApplications.filter(d => d.dealerStatus === 'pending').length;
    const pendingServices = serviceBookings.filter(s => s.status !== 'completed' && s.status !== 'cancelled').length;

    return {
      totalOrders,
      pendingOrders,
      deliveredOrders,
      totalRevenue,
      totalProducts,
      activeProducts,
      lowStockProducts,
      pendingDealers,
      pendingServices,
    };
  },
};
