import 'package:flutter/foundation.dart';

import '../../models/cart_item.dart';
import '../../models/product.dart';
import 'local_storage_service.dart';

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();

  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  Future<void> loadFromStorage() async {
    final stored = LocalStorageService.instance.readCartItems();
    _items
      ..clear()
      ..addAll(stored);
    notifyListeners();
  }

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(
      0,
      (sum, item) => sum + (item.totalPrice * item.quantity),
    );
  }

  void addToCart(Product product, {int quantity = 1}) {
    final index = _items.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
    _persist();
  }

  void increase(CartItem item) {
    item.quantity++;
    notifyListeners();
    _persist();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }

    notifyListeners();
    _persist();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
    _persist();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _persist();
  }

  void _persist() {
    LocalStorageService.instance.saveCartItems(_items);
  }
}
