export type ProductCategory = 'purifier' | 'dispenser' | 'pump' | 'filter' | 'spare_part';

export interface Product {
  id: string;
  name: string;
  category: ProductCategory;
  shortDescription: string;
  detailedDescription: string;
  retailPrice: number;
  wholesalePrice: number;
  stockQuantity: number;
  imageUrl: string;
  isActive: boolean;
  isFeatured: boolean;
  rating: number;
  specifications: Record<string, string>;
  verifiedBenefit: string;
  postedCount: number;
  createdAt?: string;
  updatedAt?: string;
}

export type OrderStatus = 'placed' | 'confirmed' | 'processing' | 'shipped' | 'delivered' | 'cancelled';
export type PaymentStatus = 'pending' | 'paid' | 'failed' | 'refunded';
export type PaymentMethod = 'razorpay_test' | 'cash_on_delivery' | 'demo_mock';

export interface OrderItem {
  productId: string;
  productName: string;
  category: string;
  imageUrl: string;
  unitPrice: number;
  quantity: number;
  totalPrice: number;
}

export interface Order {
  id: string;
  userId: string;
  userEmail: string;
  userName: string;
  userPhone: string;
  roleAtOrder: 'customer' | 'dealer';
  items: OrderItem[];
  subtotal: number;
  discountAmount: number;
  shippingCharge: number;
  totalAmount: number;
  shippingAddress: {
    label: string;
    street: string;
    city: string;
    state: string;
    postalCode: string;
  };
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  razorpayPaymentId?: string;
  orderStatus: OrderStatus;
  createdAt: string;
  updatedAt: string;
}

export type DealerStatus = 'pending' | 'approved' | 'rejected';

export interface DealerApplication {
  uid: string;
  fullName: string;
  companyName: string;
  email: string;
  phone: string;
  gstNumber: string;
  businessAddress: string;
  dealerStatus: DealerStatus;
  appliedAt: string;
  reviewedAt?: string;
  rejectionReason?: string;
}

export type ServiceStatus = 'submitted' | 'scheduled' | 'technician_assigned' | 'in_progress' | 'completed' | 'cancelled';

export interface ServiceBooking {
  id: string;
  userId: string;
  customerName: string;
  customerPhone: string;
  serviceType: string;
  preferredDate: string;
  preferredTimeSlot: string;
  address: {
    street: string;
    city: string;
    state: string;
    postalCode: string;
  };
  issueDescription: string;
  status: ServiceStatus;
  technicianName?: string;
  technicianPhone?: string;
  serviceNotes?: string;
  createdAt: string;
  updatedAt: string;
}

export interface AutomationLog {
  id: string;
  productId: string;
  productName: string;
  timestamp: string;
  channel: 'instagram' | 'whatsapp_status';
  caption: string;
  imageUrl: string;
  postIdentifier: string;
  status: 'success' | 'failed';
  errorMessage?: string;
}

export interface DashboardStats {
  totalOrders: number;
  pendingOrders: number;
  deliveredOrders: number;
  totalRevenue: number;
  totalProducts: number;
  activeProducts: number;
  lowStockProducts: number;
  pendingDealers: number;
  pendingServices: number;
}
