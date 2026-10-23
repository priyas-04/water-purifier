import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/empty_state_view.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  void _showSortModal(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'Sort Products By',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                _sortTile(ctx, productProvider, 'Featured Recommendations', ProductSortOption.featured),
                _sortTile(ctx, productProvider, 'Price: Low to High', ProductSortOption.priceLowToHigh),
                _sortTile(ctx, productProvider, 'Price: High to Low', ProductSortOption.priceHighToLow),
                _sortTile(ctx, productProvider, 'Customer Rating', ProductSortOption.rating),
                _sortTile(ctx, productProvider, 'Product Name (A-Z)', ProductSortOption.nameAZ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sortTile(BuildContext ctx, ProductProvider provider, String label, ProductSortOption option) {
    final isSelected = provider.sortOption == option;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppConstants.primaryBlue : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: AppConstants.primaryBlue) : null,
      onTap: () {
        provider.setSortOption(option);
        Navigator.of(ctx).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortModal(context),
            tooltip: 'Sort',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Horizontal Scrollable Chips
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = AppConstants.categories[index];
                final isSelected = productProvider.selectedCategory == cat['id'];

                return ChoiceChip(
                  label: Text(cat['label']!),
                  selected: isSelected,
                  selectedColor: AppConstants.primaryBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      productProvider.setCategory(cat['id']!);
                    }
                  },
                );
              },
            ),
          ),

          // Count & Active Filter indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${products.length} Products',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                InkWell(
                  onTap: () => _showSortModal(context),
                  child: Row(
                    children: [
                      Text(
                        _getSortLabel(productProvider.sortOption),
                        style: const TextStyle(fontSize: 12, color: AppConstants.primaryBlue, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_drop_down, color: AppConstants.primaryBlue, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Products Grid
          Expanded(
            child: products.isEmpty
                ? EmptyStateView(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Products Found',
                    description: 'No products match the selected category filter.',
                    buttonText: 'Show All Products',
                    onButtonPressed: () => productProvider.setCategory('all'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.67,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.push('/product/${product.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getSortLabel(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.priceLowToHigh:
        return 'Price: Low-High';
      case ProductSortOption.priceHighToLow:
        return 'Price: High-Low';
      case ProductSortOption.rating:
        return 'Top Rated';
      case ProductSortOption.nameAZ:
        return 'Name: A-Z';
      case ProductSortOption.featured:
      default:
        return 'Featured';
    }
  }
}
