import 'package:flutter/material.dart';

import '../../../../core/services/cart_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/cart_item.dart';
import 'cart_qty_button.dart';

class CartItemLine extends StatelessWidget {
  final CartItem item;

  const CartItemLine({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            item.product.image,
            height: 72,
            width: 72,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.price,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffeeBrown,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CartQtyButton(
                      icon: Icons.remove,
                      onTap: () => cart.decrease(item),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        item.quantity.toString().padLeft(2, "0"),
                        style: AppTextStyles.navItem.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CartQtyButton(
                      icon: Icons.add,
                      filled: true,
                      onTap: () => cart.increase(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => cart.remove(item),
            child: const Icon(
              Icons.close_rounded,
              size: 22,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
