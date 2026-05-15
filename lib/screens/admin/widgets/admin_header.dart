import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AdminHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const AdminHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.softGold.withOpacity(0.4)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(width: 12),
            Row(children: _buildActions()),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    final result = <Widget>[];

    for (var i = 0; i < actions.length; i += 1) {
      if (i > 0) {
        result.add(const SizedBox(width: 8));
      }
      result.add(actions[i]);
    }

    return result;
  }
}
