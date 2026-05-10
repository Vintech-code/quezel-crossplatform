class IngredientItem {
  final String name;
  final String calories;

  const IngredientItem({
    required this.name,
    required this.calories,
  });
}

class Product {
  final String name;
  final String price;
  final String kcal;
  final String image;
  final List<IngredientItem> ingredients;

  const Product({
    required this.name,
    required this.price,
    required this.kcal,
    required this.image,
    required this.ingredients,
  });
}