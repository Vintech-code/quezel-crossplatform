import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProductInfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProductInfoItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.coffeeBrown,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}