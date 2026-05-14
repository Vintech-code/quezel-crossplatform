import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../widgets/admin_shell.dart';
import '../widgets/admin_section_header.dart';
import '../widgets/admin_status_chip.dart';
import '../widgets/admin_surface_card.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      title: "Inventory Control",
      subtitle: "Keep track of ingredients and packaging supplies.",
      activeSection: AdminSection.inventory,
      body: [
        AdminSectionHeader(
          title: "Stock Alerts",
          trailing: "${_inventoryItems.length} tracked",
        ),
        const SizedBox(height: 12),
        ..._inventoryItems.map((item) => _InventoryCard(item: item)).toList(),
      ],
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final _InventoryItem item;

  const _InventoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final progress = item.current / item.target;
    final color = item.isCritical ? AppColors.coffeeBrown : AppColors.softGold;

    return AdminSurfaceCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.name,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkEspresso,
                ),
              ),
              const Spacer(),
              AdminStatusChip(label: item.status, color: color),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${item.current} ${item.unit} of ${item.target} ${item.unit}",
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.warmBeige,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.note,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _InventoryItem {
  final String name;
  final String unit;
  final double current;
  final double target;
  final String status;
  final String note;
  final bool isCritical;

  const _InventoryItem({
    required this.name,
    required this.unit,
    required this.current,
    required this.target,
    required this.status,
    required this.note,
    required this.isCritical,
  });
}

const _inventoryItems = [
  _InventoryItem(
    name: "Ube Topping",
    unit: "kg",
    current: 5,
    target: 20,
    status: "Critical",
    note: "Reorder today to avoid weekend shortage.",
    isCritical: true,
  ),
  _InventoryItem(
    name: "Shaved Ice",
    unit: "bags",
    current: 32,
    target: 50,
    status: "Low",
    note: "Monitor afternoon demand spike.",
    isCritical: false,
  ),
  _InventoryItem(
    name: "Cups 16oz",
    unit: "pcs",
    current: 240,
    target: 300,
    status: "Stable",
    note: "Supply is stable for the week.",
    isCritical: false,
  ),
  _InventoryItem(
    name: "Condensed Milk",
    unit: "cans",
    current: 18,
    target: 40,
    status: "Low",
    note: "Next delivery arrives tomorrow.",
    isCritical: false,
  ),
];
