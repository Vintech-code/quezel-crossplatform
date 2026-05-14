import 'package:hive_flutter/hive_flutter.dart';

import '../../models/cart_item.dart';
import '../../models/order.dart';
import '../../models/order_status.dart';
import '../../models/product.dart';
import '../../models/product_availability.dart';

class LocalStorageService {
  static final LocalStorageService instance = LocalStorageService._internal();

  LocalStorageService._internal();

  static const String _boxName = 'quezel';
  static const String _cartKey = 'cart_items';
  static const String _favoritesKey = 'favorite_items';
  static const String _ordersKey = 'orders';

  Box<dynamic>? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  Box<dynamic> get _storage {
    final box = _box;
    if (box == null) {
      throw StateError('Local storage not initialized.');
    }
    return box;
  }

  List<CartItem> readCartItems() {
    final raw = _storage.get(_cartKey, defaultValue: <dynamic>[]);
    final items = _decodeList(raw);

    return items
        .map((entry) => _cartItemFromMap(_asMap(entry)))
        .whereType<CartItem>()
        .toList();
  }

  void saveCartItems(List<CartItem> items) {
    final payload = items.map(_cartItemToMap).toList();
    _storage.put(_cartKey, payload);
  }

  List<Product> readFavorites() {
    final raw = _storage.get(_favoritesKey, defaultValue: <dynamic>[]);
    final items = _decodeList(raw);

    return items
        .map((entry) => _productFromMap(_asMap(entry)))
        .whereType<Product>()
        .toList();
  }

  void saveFavorites(List<Product> items) {
    final payload = items.map(_productToMap).toList();
    _storage.put(_favoritesKey, payload);
  }

  List<Order> readOrders() {
    final raw = _storage.get(_ordersKey, defaultValue: <dynamic>[]);
    final items = _decodeList(raw);

    return items
        .map((entry) => _orderFromMap(_asMap(entry)))
        .whereType<Order>()
        .toList();
  }

  void saveOrders(List<Order> items) {
    final payload = items.map(_orderToMap).toList();
    _storage.put(_ordersKey, payload);
  }

  List<dynamic> _decodeList(dynamic raw) {
    if (raw is List) return raw;
    return <dynamic>[];
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  CartItem? _cartItemFromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return null;
    final productMap = _asMap(map['product']);
    final product = _productFromMap(productMap);
    if (product == null) return null;

    return CartItem(
      product: product,
      quantity: _asInt(map['quantity'], fallback: 1),
    );
  }

  Map<String, dynamic> _cartItemToMap(CartItem item) {
    return {'product': _productToMap(item.product), 'quantity': item.quantity};
  }

  Product? _productFromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return null;

    final ingredientList = _decodeList(map['ingredients']);
    final addOnList = _decodeList(map['addOns']);

    final ingredients = ingredientList
        .map((entry) => _ingredientFromMap(_asMap(entry)))
        .whereType<IngredientItem>()
        .toList();

    final addOns = addOnList
        .map((entry) => _addOnFromMap(_asMap(entry)))
        .whereType<ProductAddOn>()
        .toList();

    return Product(
      name: _asString(map['name']),
      price: _asString(map['price']),
      kcal: _asString(map['kcal']),
      image: _asString(map['image']),
      description: _asNullableString(map['description']),
      savings: _asNullableString(map['savings']),
      isCombo: _asBool(map['isCombo']),
      ingredients: ingredients,
      addOns: addOns,
      availability: ProductAvailabilityX.fromValue(
        _asString(map['availability']),
      ),
      stock: _asInt(map['stock'], fallback: 20),
    );
  }

  Map<String, dynamic> _productToMap(Product product) {
    return {
      'name': product.name,
      'price': product.price,
      'kcal': product.kcal,
      'image': product.image,
      'description': product.description,
      'savings': product.savings,
      'isCombo': product.isCombo,
      'ingredients': product.ingredients.map(_ingredientToMap).toList(),
      'addOns': product.addOns.map(_addOnToMap).toList(),
      'availability': product.availability.value,
      'stock': product.stock,
    };
  }

  IngredientItem? _ingredientFromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return null;
    return IngredientItem(
      name: _asString(map['name']),
      calories: _asString(map['calories']),
    );
  }

  Map<String, dynamic> _ingredientToMap(IngredientItem item) {
    return {'name': item.name, 'calories': item.calories};
  }

  ProductAddOn? _addOnFromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return null;
    return ProductAddOn(
      name: _asString(map['name']),
      price: _asString(map['price']),
      type: _asString(map['type']),
    );
  }

  Map<String, dynamic> _addOnToMap(ProductAddOn addOn) {
    return {'name': addOn.name, 'price': addOn.price, 'type': addOn.type};
  }

  Order? _orderFromMap(Map<String, dynamic> map) {
    if (map.isEmpty) return null;

    final items = _decodeList(map['items'])
        .map((entry) => _cartItemFromMap(_asMap(entry)))
        .whereType<CartItem>()
        .toList();

    final createdAtRaw = _asNullableString(map['createdAt']);
    final createdAt = createdAtRaw == null
        ? DateTime.now()
        : DateTime.tryParse(createdAtRaw) ?? DateTime.now();

    return Order(
      id: _asString(map['id']),
      items: items,
      subtotal: _asDouble(map['subtotal']),
      deliveryFee: _asDouble(map['deliveryFee']),
      deliveryLocation: _asString(map['deliveryLocation']),
      deliveryKm: _asDouble(map['deliveryKm']),
      total: _asDouble(map['total']),
      paymentMethod: _asString(map['paymentMethod']),
      orderType: _asString(map['orderType']),
      status: OrderStatus.normalize(_asString(map['status'])),
      createdAt: createdAt,
      customerName: _asString(map['customerName']),
      phoneNumber: _asString(map['phoneNumber']),
      refundReason: _asNullableString(map['refundReason']),
      refundNotes: _asNullableString(map['refundNotes']),
      hasRefundProofPlaceholder: _asBool(map['hasRefundProofPlaceholder']),
    );
  }

  Map<String, dynamic> _orderToMap(Order order) {
    return {
      'id': order.id,
      'items': order.items.map(_cartItemToMap).toList(),
      'subtotal': order.subtotal,
      'deliveryFee': order.deliveryFee,
      'deliveryLocation': order.deliveryLocation,
      'deliveryKm': order.deliveryKm,
      'total': order.total,
      'paymentMethod': order.paymentMethod,
      'orderType': order.orderType,
      'status': order.status,
      'createdAt': order.createdAt.toIso8601String(),
      'customerName': order.customerName,
      'phoneNumber': order.phoneNumber,
      'refundReason': order.refundReason,
      'refundNotes': order.refundNotes,
      'hasRefundProofPlaceholder': order.hasRefundProofPlaceholder,
    };
  }

  String _asString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  String? _asNullableString(dynamic value) {
    if (value == null) return null;
    final stringValue = value.toString();
    return stringValue.isEmpty ? null : stringValue;
  }

  double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _asInt(dynamic value, {int fallback = 0}) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value?.toString().toLowerCase() == 'true';
  }
}
