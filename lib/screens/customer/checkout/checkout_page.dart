import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/order_service.dart';
import '../../../core/services/delivery_location_service.dart';
import '../../../core/services/user_address_service.dart';
import '../../../models/order.dart';
import '../../../models/cart_item.dart';
import '../orders/my_orders_page.dart';
import '../profile/delivery_address_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final cart = CartService.instance;
  final deliveryService = DeliveryLocationService.instance;
  final addressService = UserAddressService.instance;

  String selectedPaymentMethod = "GCash";

  final List<_PaymentOption> paymentOptions = const [
    _PaymentOption(
      label: "GCash",
      subtitle: "Default payment method",
      assetPath: "assets/images/gcash.jpg",
      enabled: true,
    ),
    _PaymentOption(
      label: "Cash on Delivery",
      subtitle: "Coming soon",
      assetPath: "assets/images/logo1.png",
      enabled: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    cart.addListener(_refresh);
    deliveryService.addListener(_refresh);
    addressService.addListener(_refresh);
  }

  @override
  void dispose() {
    cart.removeListener(_refresh);
    deliveryService.removeListener(_refresh);
    addressService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void placeOrder() {
    if (!addressService.hasCompleteAddress) {
      _showAddressModal();
      return;
    }

    final location = deliveryService.selectedLocation;

    final subtotal = cart.subtotal;
    final deliveryFee = location.fee;
    final total = subtotal + deliveryFee;

    final orderItems = cart.items
        .map((item) => CartItem(product: item.product, quantity: item.quantity))
        .toList();

    final order = Order(
      id: "QZ-${DateTime.now().millisecondsSinceEpoch}",
      items: orderItems,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      deliveryLocation: addressService.checkoutSummary,
      deliveryKm: location.km,
      total: total,
      paymentMethod: selectedPaymentMethod,
      orderType: "Delivery",
      status: "Preparing",
      createdAt: DateTime.now(),
    );

    OrderService.instance.addOrder(order);

    cart.clearCart();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MyOrdersPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = deliveryService.selectedLocation;

    final subtotal = cart.subtotal;
    final deliveryFee = location.fee;
    final total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                            child: Column(
                              children: paymentOptions.map((option) {
                                final selected =
                                    selectedPaymentMethod == option.label;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _PaymentOptionTile(
                                    option: option,
                                    selected: selected,
                                    onTap: option.enabled
                                        ? () {
                                            setState(() {
                                              selectedPaymentMethod =
                                                  option.label;
                                            });
                                          }
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 12),

                          _sectionCard(
                            title: "Delivery Details",
                            child: Column(
                              children: [
                                _InfoLine(
                                  label: "Address",
                                  value: addressService.checkoutSummary,
                                ),

                                const SizedBox(height: 8),

                                _InfoLine(
                                  label: "Location",
                                  value: location.name,
                                ),

                                const SizedBox(height: 8),

                                _InfoLine(
                                  label: "Distance",
                                  value: "${location.km.toStringAsFixed(1)} km",
                                ),

                                const SizedBox(height: 8),

                                _InfoLine(
                                  label: "Delivery Fee",
                                  value: "₱${deliveryFee.toStringAsFixed(2)}",
                                ),

                                const SizedBox(height: 8),

                                _InfoLine(
                                  label: "Payment",
                                  value: selectedPaymentMethod,
                                ),

                                const SizedBox(height: 8),

                                const _InfoLine(
                                  label: "Order Type",
                                  value: "Delivery",
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

            _bottomPanel(subtotal, deliveryFee, total),
          ],
        ),
      ),
    );
  }

  Widget _bottomPanel(double subtotal, double deliveryFee, double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.softGold.withOpacity(0.45)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PriceLine(
              label: "Subtotal",
              value: "₱${subtotal.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 6),

            _PriceLine(
              label: "Delivery Fee",
              value: "₱${deliveryFee.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 10),

            _PriceLine(
              label: "Total",
              value: "₱${total.toStringAsFixed(2)}",
              strong: true,
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: cart.items.isEmpty ? null : placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.softGold,
                  foregroundColor: AppColors.creamWhite,
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

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.softGold.withOpacity(0.45)),
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

  Future<void> _showAddressModal() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: AppColors.softGold.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.coffeeBrown,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Complete your address",
                        style: TextStyle(
                          fontFamily: AppFonts.righteous,
                          fontSize: 22,
                          color: AppColors.darkEspresso,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Add your street, postal code, and phone number to place an order.",
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkEspresso,
                          side: BorderSide(
                            color: AppColors.softGold.withOpacity(0.55),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Not now",
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DeliveryAddressPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coffeeBrown,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Complete now",
                          style: TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PaymentOption {
  final String label;
  final String subtitle;
  final String assetPath;
  final bool enabled;

  const _PaymentOption({
    required this.label,
    required this.subtitle,
    required this.assetPath,
    required this.enabled,
  });
}

class _PaymentOptionTile extends StatelessWidget {
  final _PaymentOption option;
  final bool selected;
  final VoidCallback? onTap;

  const _PaymentOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = option.enabled
        ? AppColors.mutedForeground
        : AppColors.mutedForeground.withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.softGold.withOpacity(0.35)),
            ),
            child: Image.asset(
              option.assetPath,
              fit: BoxFit.contain,
              color: option.enabled ? null : Colors.grey,
              colorBlendMode: option.enabled ? null : BlendMode.saturation,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.label,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: option.enabled ? AppColors.darkEspresso : muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  option.subtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    color: muted,
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle, color: AppColors.softGold)
          else
            Icon(Icons.radio_button_unchecked, color: muted),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
  final bool strong;

  const _PriceLine({
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: strong ? 16 : 14,
            fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
            color: AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: strong ? 22 : 14,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
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

  const _IconButtonBox({required this.icon, this.onTap});

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
          border: Border.all(color: AppColors.softGold.withOpacity(0.35)),
        ),
        child: Icon(icon, size: 20, color: AppColors.darkEspresso),
      ),
    );
  }
}
