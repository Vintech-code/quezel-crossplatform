import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AdminStatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const AdminStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.7)),
      ),
      child: Text(
        label,
        style: AppTextStyles.navItem.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
