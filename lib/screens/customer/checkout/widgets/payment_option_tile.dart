import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class PaymentOptionTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final String assetPath;
  final bool enabled;
  final bool selected;
  final VoidCallback? onTap;

  const PaymentOptionTile({
    super.key,
    required this.label,
    required this.subtitle,
    required this.assetPath,
    required this.enabled,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final muted = enabled
        ? AppColors.mutedForeground
        : AppColors.mutedForeground.withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.softGold.withOpacity(0.35)),
            ),
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
              color: enabled ? null : Colors.grey,
              colorBlendMode: enabled ? null : BlendMode.saturation,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: enabled ? AppColors.darkEspresso : muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(color: muted),
                ),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle, color: AppColors.softGold)
          else
            Icon(Icons.radio_button_unchecked, color: muted),
        ],
      ),
    );
  }
}
