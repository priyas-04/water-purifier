import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = auth.user;
    final featuredProducts = productProvider.featuredProducts;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: AppConstants.accentCyan),
                const SizedBox(width: 4),
                Text(
                  user?.addresses.isNotEmpty == true
                      ? '${user!.addresses.first.city}, ${user.addresses.first.postalCode}'
                      : 'Bangalore, 560103',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
            Text(
              'Hi, ${user?.fullName.split(' ').first ?? 'Guest'} 👋',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode_outlined),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => productProvider.loadProducts(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Entry
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: InkWell(
                  onTap: () => context.push('/search'),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppConstants.primaryBlue),
                        const SizedBox(width: 12),
                        Text(
                          'Search purifiers, filters, pumps, RO...',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Dealer Status Banner if dealer
              if (auth.isDealer)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: auth.isApprovedDealer ? Colors.green.shade50 : Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: auth.isApprovedDealer ? Colors.green.shade300 : Colors.amber.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          auth.isApprovedDealer ? Icons.verified : Icons.hourglass_empty,
                          color: auth.isApprovedDealer ? Colors.green.shade800 : Colors.amber.shade900,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            auth.isApprovedDealer
                                ? 'Dealer Wholesale Pricing Active! You save up to 35% on bulk orders.'
                                : 'Dealer Application Pending. Retail prices shown until admin approval.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: auth.isApprovedDealer ? Colors.green.shade900 : Colors.amber.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Hero Marketing Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppConstants.darkNavy, AppConstants.primaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryBlue.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.accentCyan,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'FESTIVE OFFER',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '100% Active Copper\nInfused RO Systems',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Zero-cost professional installation on all domestic RO purifiers.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          productProvider.setCategory('purifier');
                          context.push('/products');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppConstants.primaryBlue,
                          minimumSize: const Size(130, 38),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: const Text('Explore Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction(
                      context,
                      icon: Icons.handyman_outlined,
                      label: 'Book Service',
                      color: Colors.blue,
                      onTap: () => context.push('/service-booking'),
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.filter_alt_outlined,
                      label: 'Filters',
                      color: Colors.teal,
                      onTap: () {
                        productProvider.setCategory('filter');
                        context.push('/products');
                      },
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.local_drink_outlined,
                      label: 'Dispensers',
                      color: Colors.purple,
                      onTap: () {
                        productProvider.setCategory('dispenser');
                        context.push('/products');
                      },
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.card_giftcard_outlined,
                      label: 'Refer & Earn',
                      color: Colors.orange,
                      onTap: () => context.push('/referral'),
                    ),
                  ],
                ),
              ),

              // Categories Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Browse by Category',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => context.push('/categories'),
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),

              // Category Horizontal List
              SizedBox(
                height: 94,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final cat = AppConstants.categories[index];
                    return GestureDetector(
                      onTap: () {
                        productProvider.setCategory(cat['id']!);
                        context.push('/products');
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppConstants.primaryBlue.withOpacity(0.08),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: productProvider.selectedCategory == cat['id']
                                    ? AppConstants.primaryBlue
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _getCategoryIcon(cat['id']!),
                              color: AppConstants.primaryBlue,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['label']!,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Featured Systems Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Water Systems',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        productProvider.setCategory('all');
                        context.push('/products');
                      },
                      child: const Text('View All (60)'),
                    ),
                  ],
                ),
              ),

              // Featured Grid (4 items)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featuredProducts.take(4).length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemBuilder: (context, index) {
                    final product = featuredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () => context.push('/product/${product.id}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String id) {
    switch (id) {
      case 'purifier':
        return Icons.sanitizer_outlined;
      case 'dispenser':
        return Icons.local_drink_outlined;
      case 'pump':
        return Icons.speed_outlined;
      case 'filter':
        return Icons.filter_alt_outlined;
      case 'spare_part':
        return Icons.build_outlined;
      default:
        return Icons.water_drop_outlined;
    }
  }
}
