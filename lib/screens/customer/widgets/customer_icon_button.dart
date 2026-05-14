import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class CustomerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final bool bordered;
  final Color backgroundColor;
  final Color borderColor;

  const CustomerIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.iconSize = 20,
    this.bordered = true,
    this.backgroundColor = Colors.white,
    this.borderColor = AppColors.softGold,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.45 : 1,
        child: Container(
          height: size,
          width: size,
          decoration: bordered
              ? BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor.withOpacity(0.35)),
                )
              : const BoxDecoration(),
          child: Center(
            child: Icon(icon, size: iconSize, color: AppColors.darkEspresso),
          ),
        ),
      ),
    );
  }
}
