import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../widgets/admin_status_chip.dart';
import '../../widgets/admin_surface_card.dart';
import '../models/admin_user_row.dart';
import 'admin_user_avatar.dart';

class AdminUsersTable extends StatelessWidget {
  final List<AdminUserRow> rows;

  const AdminUsersTable({
    super.key,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(16),
      radius: 18,
      child: Column(
        children: [
          const _UsersTableHeader(),
          const SizedBox(height: 10),
          ...rows.map((row) => _UsersTableRow(row: row)),
        ],
      ),
    );
  }
}

class _UsersTableHeader extends StatelessWidget {
  const _UsersTableHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _HeaderCell(label: "User", flex: 3),
        _HeaderCell(label: "Role", flex: 2),
        _HeaderCell(label: "Status", flex: 2),
        _HeaderCell(label: "Last Order", flex: 2),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;

  const _HeaderCell({
    required this.label,
    required this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}

class _UsersTableRow extends StatelessWidget {
  final AdminUserRow row;

  const _UsersTableRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.softGold.withOpacity(0.35)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _UserIdentity(row: row),
          ),
          Expanded(
            flex: 2,
            child: Text(
              row.role,
              style: AppTextStyles.navItem.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AdminStatusChip(
                label: row.status,
                color: row.accent,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              row.lastOrder,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserIdentity extends StatelessWidget {
  final AdminUserRow row;

  const _UserIdentity({required this.row});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AdminUserAvatar(
          initials: row.initials,
          color: row.accent,
          radius: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkEspresso,
                ),
              ),
              Text(
                row.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
