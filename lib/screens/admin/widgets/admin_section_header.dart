import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String trailing;

  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.navItem.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.darkEspresso,
          ),
        ),
        const Spacer(),
        Text(
          trailing,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
