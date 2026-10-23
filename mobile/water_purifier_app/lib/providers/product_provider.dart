import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/mock_data_service.dart';

enum ProductSortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  nameAZ,
  rating,
}

class ProductProvider with ChangeNotifier {
  List<ProductModel> _allProducts = [];
  bool _isLoading = false;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  ProductSortOption _sortOption = ProductSortOption.featured;

  List<ProductModel> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  ProductSortOption get sortOption => _sortOption;

  List<ProductModel> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured && p.isActive).toList();

  List<ProductModel> get filteredProducts {
    List<ProductModel> list = _allProducts.where((p) => p.isActive).toList();

    // Category filter
    if (_selectedCategory != 'all') {
      list = list.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();
    }

    // Search filter
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      list = list.where((p) {
        final matchesName = p.name.toLowerCase().contains(q);
        final matchesCat = p.category.toLowerCase().contains(q);
        final matchesDesc = p.shortDescription.toLowerCase().contains(q);
        final matchesBenefit = p.verifiedBenefit.toLowerCase().contains(q);
        return matchesName || matchesCat || matchesDesc || matchesBenefit;
      }).toList();
    }

    // Sorting
    switch (_sortOption) {
      case ProductSortOption.priceLowToHigh:
        list.sort((a, b) => a.retailPrice.compareTo(b.retailPrice));
        break;
      case ProductSortOption.priceHighToLow:
        list.sort((a, b) => b.retailPrice.compareTo(a.retailPrice));
        break;
      case ProductSortOption.nameAZ:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.featured:
      default:
        // Featured first
        list.sort((a, b) => (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0));
        break;
    }

    return list;
  }

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _allProducts = await MockDataService.loadProducts();

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  ProductModel? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
