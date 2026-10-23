import 'package:flutter_test/flutter_test.dart';
import 'package:water_purifier_app/models/product_model.dart';

void main() {
  group('ProductModel Serialization & Logic Tests', () {
    final sampleMap = {
      'id': 'AP-RO-001',
      'name': 'AquaPure Copper Pro RO',
      'category': 'purifier',
      'shortDescription': '8-stage purification',
      'detailedDescription': 'Detailed description',
      'retailPrice': 18499.0,
      'wholesalePrice': 13200.0,
      'stockQuantity': 42,
      'imageUrl': 'https://example.com/img.jpg',
      'isActive': true,
      'isFeatured': true,
      'rating': 4.8,
      'specifications': {
        'Purification Capacity': '15 Litres/Hour',
        'Storage': '10 Litres',
      },
      'verifiedBenefit': 'Copper charged water',
    };

    test('ProductModel parses JSON correctly', () {
      final product = ProductModel.fromJson(sampleMap);
      expect(product.id, 'AP-RO-001');
      expect(product.name, 'AquaPure Copper Pro RO');
      expect(product.category, 'purifier');
      expect(product.retailPrice, 18499.0);
      expect(product.wholesalePrice, 13200.0);
      expect(product.stockQuantity, 42);
      expect(product.inStock, true);
      expect(product.isLowStock, false);
      expect(product.specifications['Storage'], '10 Litres');
    });

    test('ProductModel detects low stock threshold', () {
      final lowStockProduct = ProductModel(
        id: 'AP-WD-001',
        name: 'Floor Dispenser',
        category: 'dispenser',
        shortDescription: '',
        detailedDescription: '',
        retailPrice: 12000,
        wholesalePrice: 9000,
        stockQuantity: 3, // <= 5
        imageUrl: '',
      );
      expect(lowStockProduct.isLowStock, true);
      expect(lowStockProduct.inStock, true);

      final outOfStockProduct = ProductModel(
        id: 'AP-WD-002',
        name: 'Mini Dispenser',
        category: 'dispenser',
        shortDescription: '',
        detailedDescription: '',
        retailPrice: 5000,
        wholesalePrice: 4000,
        stockQuantity: 0,
        imageUrl: '',
      );
      expect(outOfStockProduct.inStock, false);
      expect(outOfStockProduct.isLowStock, false);
    });
  });
}
