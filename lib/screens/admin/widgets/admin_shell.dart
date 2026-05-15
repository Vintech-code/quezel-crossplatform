import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../analytics/analytics_page.dart';
import '../dashboard/admin_dashboard.dart';
import '../inventory/inventory_page.dart';
import '../orders/manage_orders_page.dart';
import '../products/manage_products_page.dart';
import '../users/manage_users_page.dart';
import 'admin_header.dart';
import 'admin_icon_button.dart';
import 'admin_top_bar.dart';

enum AdminSection { dashboard, products, orders, inventory, users, analytics }

class AdminShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final AdminSection activeSection;
  final List<Widget> body;

  const AdminShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.activeSection,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 960;

            if (isWide) {
              return Row(
                children: [
                  _AdminSidebar(
                    activeSection: activeSection,
                    onSelect: (section) => _openSection(context, section),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        AdminHeader(
                          title: title,
                          subtitle: subtitle,
                          actions: [
                            AdminIconButton(
                              icon: Icons.notifications_outlined,
                              onTap: () {},
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                            child: _AdminContent(body: body),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: AdminTopBar(
                    title: title,
                    onMenu: () => _showNavSheet(context),
                  ),
                ),
                AdminHeader(title: title, subtitle: subtitle),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                    child: _AdminContent(body: body),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showNavSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _adminNavItems
                .map(
                  (item) => _NavRowItem(
                    label: item.label,
                    icon: item.icon,
                    isActive: item.section == activeSection,
                    onTap: () {
                      Navigator.pop(context);
                      _openSection(context, item.section);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _openSection(BuildContext context, AdminSection section) {
    if (section == activeSection) {
      return;
    }

    Widget page;
    switch (section) {
      case AdminSection.dashboard:
        page = const AdminDashboard();
        break;
      case AdminSection.products:
        page = const ManageProductsPage();
        break;
      case AdminSection.orders:
        page = const ManageOrdersPage();
        break;
      case AdminSection.inventory:
        page = const InventoryPage();
        break;
      case AdminSection.users:
        page = const ManageUsersPage();
        break;
      case AdminSection.analytics:
        page = const AnalyticsPage();
        break;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _AdminContent extends StatelessWidget {
  final List<Widget> body;

  const _AdminContent({required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [...body],
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  final AdminSection activeSection;
  final ValueChanged<AdminSection> onSelect;

  const _AdminSidebar({required this.activeSection, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppColors.softGold.withOpacity(0.4)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quezel Admin", style: AppTextStyles.navLogo),
          const SizedBox(height: 18),
          ..._adminNavItems.map(
            (item) => _NavRowItem(
              label: item.label,
              icon: item.icon,
              isActive: item.section == activeSection,
              onTap: () => onSelect(item.section),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warmBeige,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.softGold.withOpacity(0.4)),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.shield_moon_outlined,
                  size: 18,
                  color: AppColors.coffeeBrown,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Staff access only",
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavRowItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavRowItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.coffeeBrown;
    final inactiveColor = AppColors.mutedForeground;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? activeColor.withOpacity(0.5) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isActive ? activeColor : inactiveColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminNavItem {
  final String label;
  final IconData icon;
  final AdminSection section;

  const _AdminNavItem({
    required this.label,
    required this.icon,
    required this.section,
  });
}

const _adminNavItems = [
  _AdminNavItem(
    label: "Dashboard",
    icon: Icons.dashboard_outlined,
    section: AdminSection.dashboard,
  ),
  _AdminNavItem(
    label: "Products",
    icon: Icons.inventory_2_outlined,
    section: AdminSection.products,
  ),
  _AdminNavItem(
    label: "Orders",
    icon: Icons.receipt_long_outlined,
    section: AdminSection.orders,
  ),
  _AdminNavItem(
    label: "Inventory",
    icon: Icons.warehouse_outlined,
    section: AdminSection.inventory,
  ),
  _AdminNavItem(
    label: "Users",
    icon: Icons.people_outline,
    section: AdminSection.users,
  ),
  _AdminNavItem(
    label: "Analytics",
    icon: Icons.insights_outlined,
    section: AdminSection.analytics,
  ),
];
