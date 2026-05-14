import 'package:flutter/material.dart';

import '../models/admin_user_row.dart';
import 'admin_user_card.dart';

class AdminUsersGrid extends StatelessWidget {
  final List<AdminUserRow> rows;

  const AdminUsersGrid({
    super.key,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 720 ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 140,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            return AdminUserCard(user: rows[index]);
          },
        );
      },
    );
  }
}
