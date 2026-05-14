import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cart_service.dart';
import '../widgets/customer_icon_button.dart';
import '../widgets/customer_top_bar.dart';
import 'widgets/cart_empty_state.dart';
import 'widgets/cart_item_line.dart';
import 'widgets/cart_summary_panel.dart';
import '../checkout/checkout_page.dart';
import '../home/user_mobile_home.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(context),
                    const SizedBox(height: 24),

                    Text(
                      "My Cart",
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 32),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${cart.itemCount} item(s) ready for checkout",
                      style: AppTextStyles.paragraph,
                    ),

                    const SizedBox(height: 22),

                    Expanded(
                      child: cart.items.isEmpty
                          ? const CartEmptyState()
                          : _cartList(),
                    ),
                  ],
                ),
              ),
            ),

            if (cart.items.isNotEmpty)
              CartSummaryPanel(
                onCheckout: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CheckoutPage()),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return CustomerTopBar(
      leading: CustomerIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        iconSize: 21,
        bordered: false,
        onTap: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            return;
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const UserMobileHome()),
            (route) => false,
          );
        },
      ),
      title: "Cart",
      trailing: CustomerIconButton(
        icon: Icons.delete_outline_rounded,
        iconSize: 21,
        bordered: false,
        onTap: cart.items.isEmpty ? null : cart.clearCart,
      ),
    );
  }

  Widget _cartList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => Divider(
        height: 28,
        thickness: 1,
        color: AppColors.darkEspresso.withOpacity(0.10),
      ),
      itemBuilder: (context, index) {
        return CartItemLine(item: cart.items[index]);
      },
    );
  }
}
