import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AdminIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const AdminIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.softGold.withOpacity(0.45)),
        ),
        child: Icon(icon, size: 20, color: AppColors.darkEspresso),
      ),
    );
  }
}
