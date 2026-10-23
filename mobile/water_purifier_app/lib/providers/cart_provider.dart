import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => {..._items};

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingCharge => subtotal > 1500 ? 0.0 : (subtotal == 0 ? 0.0 : 99.0);

  double get totalAmount => subtotal + shippingCharge;

  bool get isEmpty => _items.isEmpty;

  void addItem(ProductModel product, {int quantity = 1, required bool isApprovedDealer}) {
    final effectivePrice = isApprovedDealer ? product.wholesalePrice : product.retailPrice;

    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => CartItemModel(
          product: product,
          quantity: existing.quantity + quantity,
          unitPrice: effectivePrice,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItemModel(
          product: product,
          quantity: quantity,
          unitPrice: effectivePrice,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (!_items.containsKey(productId)) return;

    if (newQuantity <= 0) {
      _items.remove(productId);
    } else {
      final current = _items[productId]!;
      _items[productId] = CartItemModel(
        product: current.product,
        quantity: newQuantity,
        unitPrice: current.unitPrice,
      );
    }
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      updateQuantity(productId, _items[productId]!.quantity + 1);
    }
  }

  void decrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      updateQuantity(productId, _items[productId]!.quantity - 1);
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Recalculate prices if the user logs in as an approved dealer or customer
  void recalculatePrices({required bool isApprovedDealer}) {
    _items.updateAll((key, item) {
      final price = isApprovedDealer ? item.product.wholesalePrice : item.product.retailPrice;
      return CartItemModel(
        product: item.product,
        quantity: item.quantity,
        unitPrice: price,
      );
    });
    notifyListeners();
  }
}
