import 'package:flutter/material.dart';

import '../../../../models/product.dart';

class ProductCustomizationController extends ChangeNotifier {
  final Product product;

  ProductCustomizationController(this.product);

  int quantity = 1;
  final List<ProductAddOn> selectedAddOns = [];

  double get basePrice => _priceToDouble(product.price);

  double get addOnsTotal {
    return selectedAddOns.fold(
      0,
      (total, addOn) => total + _priceToDouble(addOn.price),
    );
  }

  double get totalPrice => basePrice + addOnsTotal;

  String get formattedTotalPrice => "₱${totalPrice.toStringAsFixed(2)}";

  bool isAddOnSelected(ProductAddOn addOn) {
    return selectedAddOns.any((item) => item.name == addOn.name);
  }

  void toggleAddOn(ProductAddOn addOn) {
    if (isAddOnSelected(addOn)) {
      selectedAddOns.removeWhere((item) => item.name == addOn.name);
    } else {
      selectedAddOns.add(addOn);
    }

    notifyListeners();
  }

  void increaseQuantity() {
    quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (quantity <= 1) return;

    quantity--;
    notifyListeners();
  }

  void resetAfterCart() {
    quantity = 1;
    selectedAddOns.clear();
    notifyListeners();
  }

  Product get cartProduct {
    final addOnNames = selectedAddOns.map((addOn) => addOn.name).toList();

    return Product(
      name: addOnNames.isEmpty
          ? product.name
          : "${product.name} + ${addOnNames.join(", ")}",
      price: formattedTotalPrice,
      kcal: product.kcal,
      image: product.image,
      description: product.description,
      savings: product.savings,
      isCombo: product.isCombo,
      availability: product.availability,
      stock: product.stock,
      ingredients: [
        ...product.ingredients,
        ...selectedAddOns.map(
          (addOn) => IngredientItem(name: addOn.name, calories: addOn.price),
        ),
      ],
      addOns: product.addOns,
    );
  }

  double _priceToDouble(String price) {
    final cleaned = price.replaceAll("₱", "").replaceAll(",", "").trim();
    return double.tryParse(cleaned) ?? 0;
  }
}
