import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final double unitPrice;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    required this.unitPrice,
  });

  double get totalPrice => unitPrice * quantity;

  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1, required bool isApprovedDealer}) {
    final effectivePrice = isApprovedDealer ? product.wholesalePrice : product.retailPrice;
    return CartItemModel(
      product: product,
      quantity: quantity,
      unitPrice: effectivePrice,
    );
  }

  Map<String, dynamic> toSnapshot() {
    return {
      'productId': product.id,
      'productName': product.name,
      'category': product.category,
      'imageUrl': product.imageUrl,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  factory CartItemModel.fromSnapshot(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel(
        id: map['productId'] ?? '',
        name: map['productName'] ?? '',
        category: map['category'] ?? '',
        shortDescription: '',
        detailedDescription: '',
        retailPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
        wholesalePrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
        stockQuantity: 999,
        imageUrl: map['imageUrl'] ?? '',
      ),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
