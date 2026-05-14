import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CheckoutPriceLine extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;

  const CheckoutPriceLine({
    super.key,
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
          style: AppTextStyles.navItem.copyWith(
            fontSize: strong ? 16 : 14,
            fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
            color: AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.navItem.copyWith(
            fontSize: strong ? 22 : 14,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            color: AppColors.darkEspresso,
          ),
        ),
      ],
    );
  }
}
