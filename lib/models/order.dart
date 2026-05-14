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
  final String customerName;
  final String phoneNumber;
  final String? refundReason;
  final String? refundNotes;
  final bool hasRefundProofPlaceholder;

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
    this.customerName = "Quezel Customer",
    this.phoneNumber = "",
    this.refundReason,
    this.refundNotes,
    this.hasRefundProofPlaceholder = false,
  });

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    String? deliveryLocation,
    double? deliveryKm,
    double? total,
    String? paymentMethod,
    String? orderType,
    String? status,
    DateTime? createdAt,
    String? customerName,
    String? phoneNumber,
    String? refundReason,
    String? refundNotes,
    bool? hasRefundProofPlaceholder,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      deliveryKm: deliveryKm ?? this.deliveryKm,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      refundReason: refundReason ?? this.refundReason,
      refundNotes: refundNotes ?? this.refundNotes,
      hasRefundProofPlaceholder:
          hasRefundProofPlaceholder ?? this.hasRefundProofPlaceholder,
    );
  }
}
