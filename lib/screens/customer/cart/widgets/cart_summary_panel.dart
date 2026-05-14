import 'package:flutter/material.dart';

import '../../../../core/services/cart_service.dart';
import '../../../../core/theme/app_theme.dart';
import 'cart_price_row.dart';

class CartSummaryPanel extends StatelessWidget {
  final VoidCallback onCheckout;

  const CartSummaryPanel({super.key, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        border: Border(
          top: BorderSide(color: AppColors.darkEspresso.withOpacity(0.12)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CartPriceRow(
                label: "Subtotal",
                value: "₱${cart.subtotal.toStringAsFixed(2)}",
              ),
              const SizedBox(height: 6),
              const CartPriceRow(label: "Payment", value: "GCash only"),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.softGold,
                    foregroundColor: AppColors.creamWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "CHECKOUT",
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
      ),
    );
  }
}
