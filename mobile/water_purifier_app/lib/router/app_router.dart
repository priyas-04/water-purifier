import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/main_shell.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/dealer_register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/catalog/categories_screen.dart';
import '../screens/catalog/product_list_screen.dart';
import '../screens/catalog/product_search_screen.dart';
import '../screens/catalog/product_detail_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/address_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/checkout/payment_result_screen.dart';
import '../screens/checkout/order_confirmation_screen.dart';
import '../screens/orders/order_history_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../screens/service/service_booking_screen.dart';
import '../screens/service/service_history_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/referral_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/help/help_screen.dart';
import '../screens/dealer/dealer_dashboard_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Splash
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),

    // Auth Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dealer-register',
      builder: (context, state) => const DealerRegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Main Shell Navigation (5 Tabs)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: '/service',
          builder: (context, state) => const ServiceHistoryScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Product & Search Routes
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ProductDetailScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const ProductSearchScreen(),
    ),

    // Checkout & Order Routes
    GoRoute(
      path: '/select-address',
      builder: (context, state) => const AddressScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/payment-result',
      builder: (context, state) {
        final success = state.uri.queryParameters['success'] == 'true';
        final paymentId = state.uri.queryParameters['paymentId'];
        final error = state.uri.queryParameters['error'];
        return PaymentResultScreen(
          isSuccess: success,
          paymentId: paymentId,
          errorMessage: error,
        );
      },
    ),
    GoRoute(
      path: '/order-confirmation',
      builder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'] ?? 'ORD-REF';
        return OrderConfirmationScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/order/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return OrderDetailScreen(orderId: id);
      },
    ),

    // Service & Dealer Routes
    GoRoute(
      path: '/service-booking',
      builder: (context, state) => const ServiceBookingScreen(),
    ),
    GoRoute(
      path: '/dealer-hub',
      builder: (context, state) => const DealerDashboardScreen(),
    ),

    // Profile Utilities
    GoRoute(
      path: '/referral',
      builder: (context, state) => const ReferralScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpScreen(),
    ),
  ],
);
