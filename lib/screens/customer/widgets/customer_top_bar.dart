import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class CustomerTopBar extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget trailing;

  const CustomerTopBar({
    super.key,
    required this.leading,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        Expanded(
          child: Center(
            child: Text(
              title,
              style: AppTextStyles.navItem.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),
        trailing,
      ],
    );
  }
}
