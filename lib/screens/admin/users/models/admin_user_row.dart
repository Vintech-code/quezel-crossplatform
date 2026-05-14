import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AdminUserRow {
  final String name;
  final String email;
  final String role;
  final String status;
  final String lastOrder;
  final String initials;
  final Color accent;

  const AdminUserRow({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.lastOrder,
    required this.initials,
    required this.accent,
  });
}

const adminUserRows = [
  AdminUserRow(
    name: "Maria Santos",
    email: "maria.santos@email.com",
    role: "Customer",
    status: "Active",
    lastOrder: "Today",
    initials: "MS",
    accent: AppColors.coffeeBrown,
  ),
  AdminUserRow(
    name: "Joshua Cruz",
    email: "joshua.cruz@email.com",
    role: "Customer",
    status: "Active",
    lastOrder: "Yesterday",
    initials: "JC",
    accent: AppColors.softGold,
  ),
  AdminUserRow(
    name: "Tablon Rider",
    email: "rider01@quezel.com",
    role: "Rider",
    status: "On delivery",
    lastOrder: "1 hour ago",
    initials: "TR",
    accent: AppColors.mutedForeground,
  ),
  AdminUserRow(
    name: "Lea Antonio",
    email: "lea.antonio@email.com",
    role: "Customer",
    status: "Active",
    lastOrder: "2 days ago",
    initials: "LA",
    accent: AppColors.coffeeBrown,
  ),
];
