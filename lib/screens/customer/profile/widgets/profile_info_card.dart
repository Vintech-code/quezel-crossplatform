import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProfileInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const ProfileInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.softGold.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.coffeeBrown),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkEspresso,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.mutedForeground,
          ),
        ],
      ),
    );
  }
}
