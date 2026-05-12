import 'package:flutter/foundation.dart';

import '../../models/order.dart';
import 'cart_service.dart';
import 'local_storage_service.dart';

class OrderService extends ChangeNotifier {
  static final OrderService instance = OrderService._internal();

  OrderService._internal();

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadFromStorage() async {
    final stored = LocalStorageService.instance.readOrders();
    _orders
      ..clear()
      ..addAll(stored);
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
    _persist();
  }

  void markOutForDelivery(String orderId) {
    _updateStatus(orderId, "Out for delivery");
  }

  void markCompleted(String orderId) {
    _updateStatus(orderId, "Completed");
  }

  void cancelOrder(String orderId) {
    _updateStatus(orderId, "Cancelled");
  }

  void requestRefund(String orderId) {
    _updateStatus(orderId, "Refund");
  }

  void reorder(Order order) {
    for (final item in order.items) {
      CartService.instance.addToCart(item.product, quantity: item.quantity);
    }
  }

  void _updateStatus(String orderId, String status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return;

    _orders[index] = _orders[index].copyWith(status: status);
    notifyListeners();
    _persist();
  }

  void _persist() {
    LocalStorageService.instance.saveOrders(_orders);
  }
}
