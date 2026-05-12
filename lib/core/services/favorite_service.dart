import 'package:flutter/foundation.dart';

import '../../models/product.dart';
import 'local_storage_service.dart';

class FavoriteService extends ChangeNotifier {
  static final FavoriteService instance = FavoriteService._internal();

  FavoriteService._internal();

  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  Future<void> loadFromStorage() async {
    final stored = LocalStorageService.instance.readFavorites();
    _favorites
      ..clear()
      ..addAll(stored);
    notifyListeners();
  }

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
    _persist();
  }

  void _persist() {
    LocalStorageService.instance.saveFavorites(_favorites);
  }
}
