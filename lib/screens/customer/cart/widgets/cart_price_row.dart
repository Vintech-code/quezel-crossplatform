import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CartPriceRow extends StatelessWidget {
  final String label;
  final String value;

  const CartPriceRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.paragraph),
        Text(
          value,
          style: AppTextStyles.navItem.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
