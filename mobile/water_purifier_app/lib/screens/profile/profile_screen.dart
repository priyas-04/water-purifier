import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/status_badge.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showRoleSwitcher(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assessment Role Switcher',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Switch roles instantaneously to evaluate customer retail vs dealer wholesale access without signing out.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.person, color: AppConstants.primaryBlue),
                  title: const Text('Customer (Retail Pricing)'),
                  subtitle: const Text('Browse catalogue, add retail items, book service'),
                  trailing: auth.isCustomer ? const Icon(Icons.check, color: AppConstants.primaryBlue) : null,
                  onTap: () {
                    auth.switchDemoRole(UserRole.customer);
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.storefront, color: AppConstants.successGreen),
                  title: const Text('Approved Commercial Dealer'),
                  subtitle: const Text('Unlocks discounted wholesale pricing & bulk orders'),
                  trailing: auth.isApprovedDealer ? const Icon(Icons.check, color: AppConstants.successGreen) : null,
                  onTap: () {
                    auth.switchDemoRole(UserRole.dealer, dealerStatus: DealerStatus.approved);
                    Navigator.of(ctx).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.hourglass_top, color: AppConstants.warningOrange),
                  title: const Text('Pending Dealer (Awaiting Approval)'),
                  subtitle: const Text('Wholesale prices hidden until admin approves'),
                  trailing: auth.isPendingDealer ? const Icon(Icons.check, color: AppConstants.warningOrange) : null,
                  onTap: () {
                    auth.switchDemoRole(UserRole.dealer, dealerStatus: DealerStatus.pending);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Switch Demo Role',
            onPressed: () => _showRoleSwitcher(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppConstants.primaryBlue.withOpacity(0.1),
                    child: Text(
                      user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.fullName ?? 'Guest User',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: user?.role == UserRole.dealer ? Colors.purple.shade50 : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user?.role.name.toUpperCase() ?? 'CUSTOMER',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: user?.role == UserRole.dealer ? Colors.purple.shade700 : AppConstants.primaryBlue,
                                ),
                              ),
                            ),
                            if (user?.role == UserRole.dealer) ...[
                              const SizedBox(width: 6),
                              StatusBadge.forDealer(user?.dealerStatus ?? DealerStatus.pending),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Demo Role Switcher Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz, color: AppConstants.primaryBlue, size: 24),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Role Switcher (Evaluator Mode)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Test Customer, Approved Dealer, and Pending Dealer workflows.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showRoleSwitcher(context),
                    child: const Text('Switch'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Menu Items
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  if (auth.isDealer) ...[
                    _menuTile(
                      icon: Icons.storefront,
                      title: 'Dealer Wholesale Hub',
                      color: Colors.purple,
                      onTap: () => context.push('/dealer-hub'),
                    ),
                    const Divider(height: 1),
                  ],
                  _menuTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'My Orders',
                    onTap: () => context.push('/orders'),
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Delivery Addresses',
                    onTap: () => context.push('/select-address'),
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    icon: Icons.card_giftcard_outlined,
                    title: 'Refer & Earn',
                    color: Colors.orange,
                    onTap: () => context.push('/referral'),
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications Center',
                    onTap: () => context.push('/notifications'),
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () => context.push('/settings'),
                  ),
                  const Divider(height: 1),
                  _menuTile(
                    icon: Icons.help_outline,
                    title: 'Help & Customer Care',
                    onTap: () => context.push('/help'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sign Out
            OutlinedButton.icon(
              onPressed: () {
                auth.logout();
                context.go('/login');
              },
              icon: const Icon(Icons.logout, color: AppConstants.dangerRed),
              label: const Text('Sign Out', style: TextStyle(color: AppConstants.dangerRed)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppConstants.dangerRed)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppConstants.primaryBlue),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
