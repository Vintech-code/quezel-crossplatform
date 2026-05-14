import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CheckoutInfoLine extends StatelessWidget {
  final String label;
  final String value;

  const CheckoutInfoLine({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.navItem.copyWith(
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
            style: AppTextStyles.navItem.copyWith(
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
