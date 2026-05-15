import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/order_service.dart';
import '../../../core/services/delivery_location_service.dart';
import '../../../widgets/adaptive_image.dart';
import '../../../core/services/product_catalog_service.dart';
import '../../../core/services/user_address_service.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../../models/cart_item.dart';
import '../widgets/customer_icon_button.dart';
import '../widgets/customer_top_bar.dart';
import 'widgets/checkout_info_line.dart';
import 'widgets/checkout_price_line.dart';
import 'widgets/checkout_section_card.dart';
import 'widgets/payment_option_tile.dart';
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
  final profileService = UserProfileService.instance;
  final productCatalog = ProductCatalogService.instance;

  final String selectedPaymentMethod = "GCash";

  final List<_PaymentOption> paymentOptions = const [
    _PaymentOption(
      label: "GCash",
      subtitle: "Default payment method",
      assetPath: "assets/images/gcash.jpg",
      enabled: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    cart.addListener(_refresh);
    deliveryService.addListener(_refresh);
    addressService.addListener(_refresh);
    profileService.addListener(_refresh);
  }

  @override
  void dispose() {
    cart.removeListener(_refresh);
    deliveryService.removeListener(_refresh);
    addressService.removeListener(_refresh);
    profileService.removeListener(_refresh);
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

    for (final item in cart.items) {
      if (!productCatalog.canOrder(item.product)) {
        _showCheckoutMessage("${item.product.name} is unavailable.");
        return;
      }
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
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      customerName: profileService.fullName,
      phoneNumber: addressService.phoneNumber,
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

                    Text(
                      "Checkout",
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 32),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Review your order before confirming payment.",
                      style: AppTextStyles.paragraph,
                    ),

                    const SizedBox(height: 18),

                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          CheckoutSectionCard(
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
                                        child: AdaptiveImage(
                                          path: item.product.image,
                                          fit: BoxFit.contain,
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          style: AppTextStyles.navItem.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                      Text(
                                        "x${item.quantity}",
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 12),

                          CheckoutSectionCard(
                            title: "Payment Method",
                            child: Column(
                              children: paymentOptions.map((option) {
                                final selected =
                                    selectedPaymentMethod == option.label;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: PaymentOptionTile(
                                    label: option.label,
                                    subtitle: option.subtitle,
                                    assetPath: option.assetPath,
                                    enabled: option.enabled,
                                    selected: selected,
                                    onTap: null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 12),

                          CheckoutSectionCard(
                            title: "Delivery Details",
                            child: Column(
                              children: [
                                CheckoutInfoLine(
                                  label: "Customer",
                                  value: profileService.fullName,
                                ),

                                const SizedBox(height: 8),

                                CheckoutInfoLine(
                                  label: "Phone",
                                  value: addressService.phoneNumber.isEmpty
                                      ? "Not provided"
                                      : addressService.phoneNumber,
                                ),

                                const SizedBox(height: 8),

                                CheckoutInfoLine(
                                  label: "Address",
                                  value: addressService.checkoutSummary,
                                ),

                                const SizedBox(height: 8),

                                CheckoutInfoLine(
                                  label: "Location",
                                  value: location.name,
                                ),

                                const SizedBox(height: 8),

                                CheckoutInfoLine(
                                  label: "Distance",
                                  value: "${location.km.toStringAsFixed(1)} km",
                                ),

                                const SizedBox(height: 8),

                                CheckoutInfoLine(
                                  label: "Delivery Fee",
                                  value: "₱${deliveryFee.toStringAsFixed(2)}",
                                ),

                                const SizedBox(height: 8),

                                CheckoutInfoLine(
                                  label: "Payment",
                                  value: selectedPaymentMethod,
                                ),

                                const SizedBox(height: 8),

                                const CheckoutInfoLine(
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
          top: BorderSide(color: AppColors.softGold.withValues(alpha: 0.45)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckoutPriceLine(
              label: "Subtotal",
              value: "₱${subtotal.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 6),

            CheckoutPriceLine(
              label: "Delivery Fee",
              value: "₱${deliveryFee.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 10),

            CheckoutPriceLine(
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
                child: Text(
                  "PLACE ORDER",
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: AppColors.creamWhite,
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
    return CustomerTopBar(
      leading: CustomerIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.pop(context),
      ),
      title: "Checkout",
      trailing: const SizedBox(width: 44, height: 44),
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
                        color: AppColors.softGold.withValues(alpha: 0.18),
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
                  "Add your phone number, postal code, and street address before placing an order.",
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
                            color: AppColors.softGold.withValues(alpha: 0.55),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Not now",
                          style: AppTextStyles.navItem.copyWith(
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
                        child: Text(
                          "Complete now",
                          style: AppTextStyles.navItem.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
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

  void _showCheckoutMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.darkEspresso,
          content: Text(
            message,
            style: AppTextStyles.navItem.copyWith(color: Colors.white),
          ),
        ),
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
