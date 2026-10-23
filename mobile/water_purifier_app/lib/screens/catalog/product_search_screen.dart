import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/empty_state_view.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final _searchController = TextEditingController();

  final List<String> _popularQueries = [
    'Copper RO',
    'Booster Pump 24V',
    'Membrane 80 GPD',
    'Water Dispenser',
    'Sediment Filter',
    'SMPS 24V',
    'Alkaline Mineral',
    'Solenoid Valve',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final results = productProvider.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            productProvider.setSearchQuery('');
            context.pop();
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search 60+ products...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      productProvider.setSearchQuery('');
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            productProvider.setSearchQuery(val);
            setState(() {});
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Searches if query is empty
          if (_searchController.text.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Popular Searches',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _popularQueries.map((q) {
                  return ActionChip(
                    label: Text(q, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Theme.of(context).cardColor,
                    onPressed: () {
                      _searchController.text = q;
                      productProvider.setSearchQuery(q);
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 32),
          ],

          // Search Results Summary
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Found ${results.length} results for "${_searchController.text}"',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),

          // Grid Results
          Expanded(
            child: results.isEmpty && _searchController.text.isNotEmpty
                ? EmptyStateView(
                    icon: Icons.search_off,
                    title: 'No Matching Results',
                    description: 'We could not find any purifier or spare part matching "${_searchController.text}".',
                    buttonText: 'Clear Search',
                    onButtonPressed: () {
                      _searchController.clear();
                      productProvider.setSearchQuery('');
                      setState(() {});
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: results.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.67,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      final product = results[index];
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
}
