import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String paymentMethod;
  final String orderType;
  final String status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.orderType,
    required this.status,
    required this.createdAt,
  });
}