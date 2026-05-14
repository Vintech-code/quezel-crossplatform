import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/order_service.dart';
import '../../../core/services/product_catalog_service.dart';
import '../../../models/order_status.dart';
import '../../customer/home/user_mobile_home.dart';
import '../analytics/analytics_page.dart';
import '../inventory/inventory_page.dart';
import '../orders/manage_orders_page.dart';
import '../products/manage_products_page.dart';
import '../users/manage_users_page.dart';
import '../widgets/admin_shell.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_surface_card.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final orders = OrderService.instance;
  final catalog = ProductCatalogService.instance;

  @override
  void initState() {
    super.initState();
    orders.addListener(_refresh);
    catalog.addListener(_refresh);
  }

  @override
  void dispose() {
    orders.removeListener(_refresh);
    catalog.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _count(OrderStatus.pending);
    final preparingCount = _count(OrderStatus.preparing);
    final outForDeliveryCount = _count(OrderStatus.outForDelivery);
    final deliveredCount = _count(OrderStatus.delivered);
    final refundCount = _count(OrderStatus.refundRequested);

    return AdminShell(
      title: "Admin Panel",
      subtitle: "Monitor orders, inventory, and customer updates in one place.",
      activeSection: AdminSection.dashboard,
      body: [
        _AdminInsightRow(
          items: [
            _AdminInsight(
              label: "Pending Orders",
              value: pendingCount.toString(),
              icon: Icons.receipt_long_outlined,
              accent: AppColors.coffeeBrown,
            ),
            _AdminInsight(
              label: "Preparing",
              value: preparingCount.toString(),
              icon: Icons.restaurant_menu_rounded,
              accent: AppColors.softGold,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _AdminInsightRow(
          items: [
            _AdminInsight(
              label: "Delivered",
              value: deliveredCount.toString(),
              icon: Icons.verified_outlined,
              accent: AppColors.coffeeBrown,
            ),
            _AdminInsight(
              label: "Refund Requests",
              value: refundCount.toString(),
              icon: Icons.assignment_late_outlined,
              accent: AppColors.softGold,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _AdminInsightRow(
          items: [
            _AdminInsight(
              label: "Low Stock",
              value: catalog.lowStockCount.toString(),
              icon: Icons.inventory_2_outlined,
              accent: AppColors.coffeeBrown,
            ),
            _AdminInsight(
              label: "Delivery Queue",
              value: outForDeliveryCount.toString(),
              icon: Icons.local_shipping_outlined,
              accent: AppColors.mutedForeground,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _ActionCard(
          title: "Customer Panel",
          subtitle: "Preview the customer ordering flow.",
          icon: Icons.storefront_outlined,
          accent: AppColors.coffeeBrown,
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const UserMobileHome()),
              (route) => false,
            );
          },
        ),
        const SizedBox(height: 12),
        _ActionCard(
          title: "Product Management",
          subtitle: "Update pricing, photos, and product visibility.",
          icon: Icons.inventory_2_outlined,
          accent: AppColors.softGold,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageProductsPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _ActionCard(
          title: "Order Management",
          subtitle: "Review incoming and in-progress orders.",
          icon: Icons.fact_check_outlined,
          accent: AppColors.mutedForeground,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageOrdersPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _ActionCard(
          title: "Inventory Control",
          subtitle: "Track stock alerts and supplier requests.",
          icon: Icons.kitchen_outlined,
          accent: AppColors.softGold,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InventoryPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _ActionCard(
          title: "User Management",
          subtitle: "View customer and rider accounts.",
          icon: Icons.people_outline,
          accent: AppColors.mutedForeground,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageUsersPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        _ActionCard(
          title: "Sales Analytics",
          subtitle: "Track revenue and top-performing items.",
          icon: Icons.insights_outlined,
          accent: AppColors.softGold,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnalyticsPage()),
            );
          },
        ),
      ],
    );
  }

  int _count(String status) {
    return orders.orders.where((order) => order.status == status).length;
  }
}

class _AdminInsightRow extends StatelessWidget {
  final List<_AdminInsight> items;

  const _AdminInsightRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: item == items.last ? 0 : 12),
                child: AdminStatCard(
                  value: item.value,
                  label: item.label,
                  icon: item.icon,
                  accent: item.accent,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AdminSurfaceCard(
        padding: const EdgeInsets.all(16),
        radius: 18,
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.7)),
              ),
              child: Icon(icon, size: 22, color: accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.navItem.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkEspresso,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminInsight {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _AdminInsight({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });
}
