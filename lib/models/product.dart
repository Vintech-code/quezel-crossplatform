import 'product_availability.dart';

class IngredientItem {
  final String name;
  final String calories;

  const IngredientItem({required this.name, required this.calories});
}

class ProductAddOn {
  final String name;
  final String price;
  final String type;

  const ProductAddOn({
    required this.name,
    required this.price,
    required this.type,
  });
}

class Product {
  final String name;
  final String price;
  final String kcal;
  final String image;
  final String? description;
  final String? savings;
  final bool isCombo;
  final List<IngredientItem> ingredients;
  final List<ProductAddOn> addOns;
  final ProductAvailability availability;
  final int stock;

  const Product({
    required this.name,
    required this.price,
    required this.kcal,
    required this.image,
    required this.ingredients,
    this.description,
    this.savings,
    this.isCombo = false,
    this.addOns = const [],
    this.availability = ProductAvailability.available,
    this.stock = 20,
  });

  bool get canOrder => availability.canOrder && stock > 0;

  Product copyWith({
    String? name,
    String? price,
    String? kcal,
    String? image,
    String? description,
    String? savings,
    bool? isCombo,
    List<IngredientItem>? ingredients,
    List<ProductAddOn>? addOns,
    ProductAvailability? availability,
    int? stock,
  }) {
    final nextStock = stock ?? this.stock;
    final nextAvailability = nextStock <= 0
        ? ProductAvailability.outOfStock
        : availability ?? this.availability;

    return Product(
      name: name ?? this.name,
      price: price ?? this.price,
      kcal: kcal ?? this.kcal,
      image: image ?? this.image,
      description: description ?? this.description,
      savings: savings ?? this.savings,
      isCombo: isCombo ?? this.isCombo,
      ingredients: ingredients ?? this.ingredients,
      addOns: addOns ?? this.addOns,
      availability: nextAvailability,
      stock: nextStock,
    );
  }
}
