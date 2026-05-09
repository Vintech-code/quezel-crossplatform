import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cart_service.dart';
import '../../../models/order.dart';
import '../../../models/cart_item.dart';
import '../../../core/services/order_service.dart';
import '../orders/order_history_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final cart = CartService.instance;

  @override
  void initState() {
    super.initState();
    cart.addListener(_refresh);
  }

  @override
  void dispose() {
    cart.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void placeOrder() {
    final orderItems = cart.items
        .map(
          (item) => CartItem(
            product: item.product,
            quantity: item.quantity,
          ),
        )
        .toList();

    final order = Order(
      id: "QZ-${DateTime.now().millisecondsSinceEpoch}",
      items: orderItems,
      total: cart.subtotal,
      paymentMethod: "GCash",
      orderType: "Delivery",
      status: "Preparing",
      createdAt: DateTime.now(),
    );

    OrderService.instance.addOrder(order);
    cart.clearCart();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderHistoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = cart.subtotal;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(context),
                    const SizedBox(height: 22),
                    const Text(
                      "Checkout",
                      style: TextStyle(
                        fontFamily: AppFonts.righteous,
                        fontSize: 32,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Review your order before confirming payment.",
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 18),

                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _sectionCard(
                            title: "Order Summary",
                            child: Column(
                              children: cart.items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 54,
                                        width: 54,
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Image.asset(
                                          item.product.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontFamily: AppFonts.poppins,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.darkEspresso,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "x${item.quantity}",
                                        style: const TextStyle(
                                          fontFamily: AppFonts.poppins,
                                          fontSize: 13,
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 12),

                          _sectionCard(
                            title: "Payment Method",
                            child: Row(
                              children: [
                                Container(
                                  height: 44,
                                  width: 44,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.softGold.withOpacity(0.35),
                                    ),
                                  ),
                                  child: Image.asset(
                                    "assets/images/gcash.jpg",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "GCash",
                                        style: TextStyle(
                                          fontFamily: AppFonts.poppins,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.darkEspresso,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        "Default payment method",
                                        style: TextStyle(
                                          fontFamily: AppFonts.poppins,
                                          fontSize: 12,
                                          color: AppColors.mutedForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.softGold,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          _sectionCard(
                            title: "Payment Details",
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _InfoLine(
                                  label: "Payment",
                                  value: "GCash only",
                                ),
                                SizedBox(height: 8),
                                _InfoLine(
                                  label: "Order Type",
                                  value: "Delivery",
                                ),
                                SizedBox(height: 8),
                                _InfoLine(
                                  label: "Note",
                                  value: "No cash on delivery",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _bottomCheckoutPanel(total),
          ],
        ),
      ),
    );
  }

Widget _bottomCheckoutPanel(double total) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(
          color: AppColors.softGold.withOpacity(0.45),
        ),
      ),
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PriceLine(
            label: "Total",
            value: "₱${total.toStringAsFixed(2)}",
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: cart.items.isEmpty ? null : placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coffeeBrown,
                foregroundColor: AppColors.creamWhite,
                disabledBackgroundColor:
                    AppColors.mutedForeground.withOpacity(0.25),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "PLACE ORDER",
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),
        ],
      ),
    ),
  );
}

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        _IconButtonBox(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Checkout",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 13,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final String value;

  const _PriceLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 15,
            color: AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppColors.darkEspresso,
          ),
        ),
      ],
    );
  }
}

class _IconButtonBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconButtonBox({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.softGold.withOpacity(0.35),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.darkEspresso,
        ),
      ),
    );
  }
}