import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CartEmptyState extends StatelessWidget {
  const CartEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 54,
            color: AppColors.coffeeBrown,
          ),
          const SizedBox(height: 18),
          Text(
            "Your cart is empty",
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add Quezel’s treats to start your order.",
            textAlign: TextAlign.center,
            style: AppTextStyles.paragraph,
          ),
        ],
      ),
    );
  }
}
