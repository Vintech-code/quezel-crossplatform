import 'package:flutter/foundation.dart';
import '../../models/product.dart';
import '../../models/cart_item.dart';

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();

  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

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
      _items.add(
        CartItem(
          product: product,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  void increase(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }

    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}