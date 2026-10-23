import 'package:flutter_test/flutter_test.dart';
import 'package:water_purifier_app/models/product_model.dart';
import 'package:water_purifier_app/models/cart_item_model.dart';
import 'package:water_purifier_app/providers/cart_provider.dart';

void main() {
  group('Cart Calculation Engine Tests', () {
    late ProductModel testPurifier;
    late ProductModel testFilter;

    setUp(() {
      testPurifier = ProductModel(
        id: 'AP-RO-001',
        name: 'AquaPure Copper Pro RO',
        category: 'purifier',
        shortDescription: 'Test purifier',
        detailedDescription: '',
        retailPrice: 18000,
        wholesalePrice: 13000,
        stockQuantity: 20,
        imageUrl: 'https://example.com/test.jpg',
      );

      testFilter = ProductModel(
        id: 'AP-FL-001',
        name: 'Sediment Filter',
        category: 'filter',
        shortDescription: 'Test filter',
        detailedDescription: '',
        retailPrice: 200,
        wholesalePrice: 100,
        stockQuantity: 100,
        imageUrl: 'https://example.com/filter.jpg',
      );
    });

    test('Customer receives retail pricing on cart item addition', () {
      final item = CartItemModel.fromProduct(testPurifier, quantity: 1, isApprovedDealer: false);
      expect(item.unitPrice, 18000);
      expect(item.totalPrice, 18000);
    });

    test('Approved dealer receives wholesale pricing on cart item addition', () {
      final item = CartItemModel.fromProduct(testPurifier, quantity: 2, isApprovedDealer: true);
      expect(item.unitPrice, 13000);
      expect(item.totalPrice, 26000);
    });

    test('Cart calculates subtotal, free shipping threshold and final total correctly', () {
      final cart = CartProvider();

      // Empty cart
      expect(cart.subtotal, 0.0);
      expect(cart.shippingCharge, 0.0);
      expect(cart.totalAmount, 0.0);

      // Add item under free shipping threshold (₹1500)
      cart.addItem(testFilter, quantity: 2, isApprovedDealer: false); // 2 x 200 = 400
      expect(cart.subtotal, 400.0);
      expect(cart.shippingCharge, 99.0);
      expect(cart.totalAmount, 499.0);

      // Add item exceeding free shipping threshold
      cart.addItem(testPurifier, quantity: 1, isApprovedDealer: false); // 400 + 18000 = 18400
      expect(cart.subtotal, 18400.0);
      expect(cart.shippingCharge, 0.0); // Free shipping
      expect(cart.totalAmount, 18400.0);
    });

    test('Recalculate prices adjusts existing items when switching to approved dealer', () {
      final cart = CartProvider();
      cart.addItem(testPurifier, quantity: 1, isApprovedDealer: false);
      expect(cart.items['AP-RO-001']!.unitPrice, 18000);

      // Dealer logs in
      cart.recalculatePrices(isApprovedDealer: true);
      expect(cart.items['AP-RO-001']!.unitPrice, 13000);
      expect(cart.subtotal, 13000);
    });
  });
}
