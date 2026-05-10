import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice {
    final cleanPrice = product.price.replaceAll(RegExp(r"[^0-9.]"), "");
    return double.tryParse(cleanPrice) ?? 0;
  }
}
