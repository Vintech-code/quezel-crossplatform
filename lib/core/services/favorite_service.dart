import 'package:flutter/foundation.dart';
import '../../models/product.dart';

class FavoriteService extends ChangeNotifier {
  static final FavoriteService instance = FavoriteService._internal();

  FavoriteService._internal();

  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Product product) {
    return _favorites.any((item) => item.name == product.name);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _favorites.removeWhere((item) => item.name == product.name);
    } else {
      _favorites.add(product);
    }

    notifyListeners();
  }
}