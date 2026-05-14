import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class CartQtyButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const CartQtyButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: filled ? AppColors.darkEspresso : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: filled
                ? AppColors.darkEspresso
                : AppColors.darkEspresso.withOpacity(0.22),
          ),
        ),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Icon(
            icon,
            size: 17,
            color: filled ? Colors.white : AppColors.darkEspresso,
          ),
        ),
      ),
    );
  }
}
