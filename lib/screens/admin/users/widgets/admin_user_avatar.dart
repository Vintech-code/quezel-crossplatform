import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AdminUserAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double radius;

  const AdminUserAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withOpacity(0.15),
      child: Text(
        initials,
        style: AppTextStyles.navItem.copyWith(
          fontSize: radius <= 18 ? 12 : 14,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
