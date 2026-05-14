import 'package:flutter/foundation.dart';

import '../../data/customer_home_data.dart';
import '../../models/product.dart';
import '../../models/product_availability.dart';

class ProductCatalogService extends ChangeNotifier {
  static final ProductCatalogService instance =
      ProductCatalogService._internal();

  ProductCatalogService._internal() {
    _seedProducts();
  }

  final Map<String, List<Product>> _sections = {};

  Map<String, List<Product>> get customerSections {
    return _sections.map(
      (category, products) => MapEntry(
        category,
        products
            .where(
              (product) => product.availability != ProductAvailability.hidden,
            )
            .toList(),
      ),
    );
  }

  Map<String, List<Product>> get adminSections {
    return _sections.map(
      (category, products) => MapEntry(category, List.unmodifiable(products)),
    );
  }

  List<Product> get products {
    return _sections.values.expand((items) => items).toList();
  }

  int get availableCount {
    return products
        .where(
          (product) => product.availability == ProductAvailability.available,
        )
        .length;
  }

  int get hiddenCount {
    return products
        .where((product) => product.availability == ProductAvailability.hidden)
        .length;
  }

  int get lowStockCount {
    return products.where((product) => product.stock <= 3).length;
  }

  Product? findByName(String name) {
    for (final product in products) {
      if (product.name == name) return product;
    }
    return null;
  }

  ProductAvailability availabilityOf(Product product) {
    return findByName(_baseName(product.name))?.availability ??
        product.availability;
  }

  bool canOrder(Product product) {
    final catalogProduct = findByName(_baseName(product.name));
    if (catalogProduct == null) return product.canOrder;
    return catalogProduct.canOrder;
  }

  void setAvailability(Product product, ProductAvailability availability) {
    _updateProduct(
      product.name,
      (item) => item.copyWith(availability: availability),
    );
  }

  void setStock(Product product, int stock) {
    _updateProduct(product.name, (item) => item.copyWith(stock: stock));
  }

  void reduceStock(Product product, int quantity) {
    final current = findByName(_baseName(product.name));
    if (current == null) return;
    setStock(current, (current.stock - quantity).clamp(0, 999));
  }

  void _seedProducts() {
    _sections
      ..clear()
      ..addAll(
        customerProductSections.map((category, products) {
          return MapEntry(category, products.map(_withMockInventory).toList());
        }),
      );
  }

  Product _withMockInventory(Product product) {
    switch (product.name) {
      case "Crema De Leche":
        return product.copyWith(
          availability: ProductAvailability.temporarilyUnavailable,
          stock: 8,
        );
      case "Lemon Juice Regular":
        return product.copyWith(stock: 0);
      case "Cheese Supreme Combo":
        return product.copyWith(
          availability: ProductAvailability.hidden,
          stock: 5,
        );
      default:
        return product.copyWith(stock: 12);
    }
  }

  void _updateProduct(String productName, Product Function(Product) update) {
    for (final entry in _sections.entries) {
      final index = entry.value.indexWhere((item) => item.name == productName);
      if (index < 0) continue;

      entry.value[index] = update(entry.value[index]);
      notifyListeners();
      return;
    }
  }

  String _baseName(String name) {
    return name.split(" + ").first;
  }
}
