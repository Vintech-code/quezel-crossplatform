import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final String deliveryLocation;
  final double deliveryKm;
  final double total;
  final String paymentMethod;
  final String orderType;
  final String status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.deliveryLocation,
    required this.deliveryKm,
    required this.total,
    required this.paymentMethod,
    required this.orderType,
    required this.status,
    required this.createdAt,
  });
}