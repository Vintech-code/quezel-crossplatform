import 'package:flutter/foundation.dart';

import '../../models/order.dart';
import '../../models/order_status.dart';
import 'cart_service.dart';
import 'local_storage_service.dart';
import 'product_catalog_service.dart';

class OrderService extends ChangeNotifier {
  static final OrderService instance = OrderService._internal();

  OrderService._internal();

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  Future<void> loadFromStorage() async {
    final stored = LocalStorageService.instance.readOrders();
    _orders
      ..clear()
      ..addAll(
        stored.map(
          (order) =>
              order.copyWith(status: OrderStatus.normalize(order.status)),
        ),
      );
    notifyListeners();
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    for (final item in order.items) {
      ProductCatalogService.instance.reduceStock(item.product, item.quantity);
    }
    notifyListeners();
    _persist();
  }

  void acceptOrder(String orderId) {
    _updateStatus(orderId, OrderStatus.accepted);
  }

  void markPreparing(String orderId) {
    _updateStatus(orderId, OrderStatus.preparing);
  }

  void markOutForDelivery(String orderId) {
    _updateStatus(orderId, OrderStatus.outForDelivery);
  }

  void markDelivered(String orderId) {
    _updateStatus(orderId, OrderStatus.delivered);
  }

  void cancelOrder(String orderId) {
    _updateStatus(orderId, OrderStatus.cancelled);
  }

  void rejectOrder(String orderId) {
    _updateStatus(orderId, OrderStatus.cancelled);
  }

  void requestRefund(
    String orderId, {
    required String reason,
    String? notes,
    bool hasProofPlaceholder = false,
  }) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index < 0) return;

    _orders[index] = _orders[index].copyWith(
      status: OrderStatus.refundRequested,
      refundReason: reason,
      refundNotes: notes,
      hasRefundProofPlaceholder: hasProofPlaceholder,
    );
    notifyListeners();
    _persist();
  }

  void approveRefund(String orderId) {
    _updateStatus(orderId, OrderStatus.refundApproved);
  }

  void rejectRefund(String orderId) {
    _updateStatus(orderId, OrderStatus.refundRejected);
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
