import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/admin_section_header.dart';
import '../widgets/admin_shell.dart';
import 'models/admin_user_row.dart';
import 'widgets/admin_users_grid.dart';
import 'widgets/admin_users_table.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      title: "User Management",
      subtitle: "Monitor customer and rider accounts in one view.",
      activeSection: AdminSection.users,
      body: [
        AdminSectionHeader(
          title: "Latest Signups",
          trailing: "${adminUserRows.length} profiles",
        ),
        const SizedBox(height: AppSpacing.sm),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            if (isWide) {
              return const AdminUsersTable(rows: adminUserRows);
            }
            return const AdminUsersGrid(rows: adminUserRows);
          },
        ),
      ],
    );
  }
}
