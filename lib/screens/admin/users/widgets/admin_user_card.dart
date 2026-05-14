import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../widgets/admin_status_chip.dart';
import '../../widgets/admin_surface_card.dart';
import '../models/admin_user_row.dart';
import 'admin_user_avatar.dart';

class AdminUserCard extends StatelessWidget {
  final AdminUserRow user;

  const AdminUserCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(14),
      radius: 16,
      child: Row(
        children: [
          AdminUserAvatar(
            initials: user.initials,
            color: user.accent,
            radius: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkEspresso,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 6),
                Text(
                  user.lastOrder,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          AdminStatusChip(label: user.role, color: user.accent),
        ],
      ),
    );
  }
}
