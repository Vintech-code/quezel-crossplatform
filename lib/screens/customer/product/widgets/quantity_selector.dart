import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyButton(
          icon: Icons.remove,
          onTap: onDecrease,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            quantity.toString().padLeft(2, "0"),
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _QtyButton(
          icon: Icons.add,
          filled: true,
          onTap: onIncrease,
        ),
      ],
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
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: filled ? AppColors.darkEspresso : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.darkEspresso.withOpacity(0.15),
          ),
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : AppColors.darkEspresso,
        ),
      ),
    );
  }
}