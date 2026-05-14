import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'admin_icon_button.dart';

class AdminTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onMenu;

  const AdminTopBar({
    super.key,
    required this.title,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AdminIconButton(icon: Icons.menu_rounded, onTap: onMenu),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.navItem.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
        AdminIconButton(
          icon: Icons.notifications_outlined,
          onTap: () {},
        ),
      ],
    );
  }
}
