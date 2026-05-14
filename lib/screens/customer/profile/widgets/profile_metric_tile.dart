import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProfileMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.softGold.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.coffeeBrown),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkEspresso,
                  ),
                ),
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
