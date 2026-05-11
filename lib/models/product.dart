class IngredientItem {
  final String name;
  final String calories;

  const IngredientItem({
    required this.name,
    required this.calories,
  });
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
  });
}