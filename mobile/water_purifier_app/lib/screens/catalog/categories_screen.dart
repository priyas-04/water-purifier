import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/product_provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    final categoryDetails = [
      {
        'id': 'purifier',
        'title': 'Water Purifiers',
        'description': 'RO, UV, UF, Copper & IoT Alkaline domestic & commercial systems.',
        'count': '15 Models',
        'icon': Icons.sanitizer_outlined,
        'color': Colors.blue,
      },
      {
        'id': 'dispenser',
        'title': 'Water Dispensers',
        'description': 'Bottom-loading, hot & cold desktop, and heavy-duty floor dispensers.',
        'count': '10 Models',
        'icon': Icons.local_drink_outlined,
        'color': Colors.indigo,
      },
      {
        'id': 'pump',
        'title': 'Booster Pumps',
        'description': '75/100/150 GPD diaphragm, brushless DC, and commercial high-pressure pumps.',
        'count': '10 Models',
        'icon': Icons.speed_outlined,
        'color': Colors.teal,
      },
      {
        'id': 'filter',
        'title': 'Filters & Cartridges',
        'description': 'Sediment, coconut carbon, RO membranes, alkaline & copper inlines.',
        'count': '15 Models',
        'icon': Icons.filter_alt_outlined,
        'color': Colors.purple,
      },
      {
        'id': 'spare_part',
        'title': 'Spare Parts & Fittings',
        'description': 'SMPS power adapters, solenoid valves, pressure switches, housings & wrenches.',
        'count': '10 Models',
        'icon': Icons.build_outlined,
        'color': Colors.deepOrange,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categoryDetails.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final cat = categoryDetails[index];
          final color = cat['color'] as Color;

          return Card(
            child: InkWell(
              onTap: () {
                productProvider.setCategory(cat['id'] as String);
                context.push('/products');
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(cat['icon'] as IconData, color: color, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cat['title'] as String,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  cat['count'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat['description'] as String,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
