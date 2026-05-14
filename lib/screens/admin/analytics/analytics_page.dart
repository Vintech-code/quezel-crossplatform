import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/admin_shell.dart';
import '../widgets/admin_section_header.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_surface_card.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      title: "Sales Analytics",
      subtitle: "Review revenue, bestsellers, and peak hours.",
      activeSection: AdminSection.analytics,
      body: [
        _KpiRow(items: _analyticsKpis),
        const SizedBox(height: 18),
        _ChartCard(),
        const SizedBox(height: 18),
        const AdminSectionHeader(
          title: "Top Categories",
          trailing: "Last 7 days",
        ),
        const SizedBox(height: 12),
        ..._categoryRows.map((row) => _CategoryRow(row: row)).toList(),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  final List<_KpiCardData> items;

  const _KpiRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final children = items.map((item) => _KpiCard(item: item)).toList();

        if (isWide) {
          return Row(
            children: children
                .map(
                  (child) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: child == children.last ? 0 : 12,
                      ),
                      child: child,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: children
              .map(
                (child) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final _KpiCardData item;

  const _KpiCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return AdminStatCard(
      value: item.value,
      label: item.label,
      icon: item.icon,
      accent: item.accent,
    );
  }
}

class _ChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(16),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weekly Revenue",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.warmBeige,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.softGold.withOpacity(0.45)),
            ),
            child: Center(
              child: Text(
                "Revenue chart placeholder",
                style: AppTextStyles.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final _CategoryRowData row;

  const _CategoryRow({required this.row});

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      radius: 16,
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.name,
              style: AppTextStyles.navItem.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
          Text(
            row.orders,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(width: 12),
          Text(
            row.revenue,
            style: AppTextStyles.navItem.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.coffeeBrown,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _KpiCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });
}

class _CategoryRowData {
  final String name;
  final String orders;
  final String revenue;

  const _CategoryRowData({
    required this.name,
    required this.orders,
    required this.revenue,
  });
}

const _analyticsKpis = [
  _KpiCardData(
    label: "Weekly Revenue",
    value: "Php 48,920",
    icon: Icons.payments_outlined,
    accent: AppColors.coffeeBrown,
  ),
  _KpiCardData(
    label: "Average Order",
    value: "Php 164",
    icon: Icons.shopping_bag_outlined,
    accent: AppColors.softGold,
  ),
  _KpiCardData(
    label: "Repeat Customers",
    value: "62%",
    icon: Icons.repeat_rounded,
    accent: AppColors.mutedForeground,
  ),
];

const _categoryRows = [
  _CategoryRowData(
    name: "Palamig",
    orders: "318 orders",
    revenue: "Php 24,120",
  ),
  _CategoryRowData(name: "Snacks", orders: "182 orders", revenue: "Php 12,430"),
  _CategoryRowData(name: "Drinks", orders: "96 orders", revenue: "Php 8,220"),
];
