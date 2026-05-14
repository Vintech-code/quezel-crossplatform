import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'admin_surface_card.dart';

class AdminStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color accent;

  const AdminStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: accent.withOpacity(0.7)),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkEspresso,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
