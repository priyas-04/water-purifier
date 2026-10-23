class ProductModel {
  final String id;
  final String name;
  final String category; // purifier, dispenser, pump, filter, spare_part
  final String shortDescription;
  final String detailedDescription;
  final double retailPrice;
  final double wholesalePrice;
  final int stockQuantity;
  final String imageUrl;
  final bool isActive;
  final bool isFeatured;
  final double rating;
  final Map<String, dynamic> specifications;
  final String verifiedBenefit;
  final int postedCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.shortDescription,
    required this.detailedDescription,
    required this.retailPrice,
    required this.wholesalePrice,
    required this.stockQuantity,
    required this.imageUrl,
    this.isActive = true,
    this.isFeatured = false,
    this.rating = 4.7,
    this.specifications = const {},
    this.verifiedBenefit = '',
    this.postedCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  bool get inStock => stockQuantity > 0;
  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 5;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'purifier',
      shortDescription: json['shortDescription'] ?? '',
      detailedDescription: json['detailedDescription'] ?? '',
      retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0.0,
      wholesalePrice: (json['wholesalePrice'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      specifications: (json['specifications'] as Map<String, dynamic>?) ?? {},
      verifiedBenefit: json['verifiedBenefit'] ?? '',
      postedCount: (json['postedCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'shortDescription': shortDescription,
      'detailedDescription': detailedDescription,
      'retailPrice': retailPrice,
      'wholesalePrice': wholesalePrice,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'rating': rating,
      'specifications': specifications,
      'verifiedBenefit': verifiedBenefit,
      'postedCount': postedCount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
