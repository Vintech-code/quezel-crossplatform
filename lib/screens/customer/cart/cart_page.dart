import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/cart_service.dart';
import '../../../models/cart_item.dart';
import '../checkout/checkout_page.dart';

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBar(context),
                    const SizedBox(height: 22),

                    const Text(
                      "My Cart",
                      style: TextStyle(
                        fontFamily: AppFonts.righteous,
                        fontSize: 32,
                        color: AppColors.darkEspresso,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "${cart.itemCount} item(s) ready for checkout",
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14,
                        color: AppColors.mutedForeground,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Expanded(
                      child: cart.items.isEmpty
                          ? _emptyCart()
                          : _cartList(),
                    ),
                  ],
                ),
              ),
            ),

            if (cart.items.isNotEmpty)
              _bottomCheckoutPanel(),
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
              "Cart",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),

        _IconButtonBox(
          icon: Icons.delete_outline_rounded,
          onTap: cart.items.isEmpty ? null : cart.clearCart,
        ),
      ],
    );
  }

  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 38,
              color: AppColors.coffeeBrown,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Your cart is empty",
            style: TextStyle(
              fontFamily: AppFonts.righteous,
              fontSize: 24,
              color: AppColors.darkEspresso,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Add Quezel’s treats to start your order.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: cart.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _CartItemCard(item: cart.items[index]);
      },
    );
  }

  Widget _bottomCheckoutPanel() {
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
            _PriceRow(
              label: "Subtotal",
              value: "₱${cart.subtotal.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 6),

            const _PriceRow(
              label: "Payment",
              value: "GCash only",
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CheckoutPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coffeeBrown,
                  foregroundColor: AppColors.creamWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "CHECKOUT",
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
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;

  const _CartItemCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 78,
            width: 78,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset(
              item.product.image,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkEspresso,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.product.price,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffeeBrown,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _QtyButton(
                      icon: Icons.remove,
                      onTap: () => cart.decrease(item),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        item.quantity.toString().padLeft(2, "0"),
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    _QtyButton(
                      icon: Icons.add,
                      filled: true,
                      onTap: () => cart.increase(item),
                    ),
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => cart.remove(item),
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: filled ? AppColors.darkEspresso : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.darkEspresso.withOpacity(0.12),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: filled ? Colors.white : AppColors.darkEspresso,
        ),
      ),
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
      child: Opacity(
        opacity: onTap == null ? 0.45 : 1,
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
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({
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
            fontSize: 14,
            color: AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.darkEspresso,
          ),
        ),
      ],
    );
  }
}