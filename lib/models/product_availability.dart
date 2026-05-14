import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

enum ProductAvailability {
  available,
  outOfStock,
  temporarilyUnavailable,
  hidden,
}

extension ProductAvailabilityX on ProductAvailability {
  String get value {
    switch (this) {
      case ProductAvailability.available:
        return "available";
      case ProductAvailability.outOfStock:
        return "out_of_stock";
      case ProductAvailability.temporarilyUnavailable:
        return "temporarily_unavailable";
      case ProductAvailability.hidden:
        return "hidden";
    }
  }

  String get label {
    switch (this) {
      case ProductAvailability.available:
        return "Available";
      case ProductAvailability.outOfStock:
        return "Out of Stock";
      case ProductAvailability.temporarilyUnavailable:
        return "Temporarily Unavailable";
      case ProductAvailability.hidden:
        return "Hidden";
    }
  }

  bool get canOrder => this == ProductAvailability.available;

  Color get color {
    switch (this) {
      case ProductAvailability.available:
        return AppColors.softGold;
      case ProductAvailability.outOfStock:
        return AppColors.coffeeBrown;
      case ProductAvailability.temporarilyUnavailable:
        return AppColors.mutedForeground;
      case ProductAvailability.hidden:
        return AppColors.darkEspresso;
    }
  }

  static ProductAvailability fromValue(String value) {
    switch (value) {
      case "out_of_stock":
        return ProductAvailability.outOfStock;
      case "temporarily_unavailable":
        return ProductAvailability.temporarilyUnavailable;
      case "hidden":
        return ProductAvailability.hidden;
      default:
        return ProductAvailability.available;
    }
  }
}
