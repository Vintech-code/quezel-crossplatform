import 'package:flutter/material.dart';

import '../../../core/services/product_catalog_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../models/product_availability.dart';
import '../widgets/admin_section_header.dart';
import '../widgets/admin_shell.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_status_chip.dart';
import '../widgets/admin_surface_card.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final catalog = ProductCatalogService.instance;

  @override
  void initState() {
    super.initState();
    catalog.addListener(_refresh);
  }

  @override
  void dispose() {
    catalog.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final products = catalog.products;

    return AdminShell(
      title: "Product Management",
      subtitle: "Toggle availability and mock stock without a backend.",
      activeSection: AdminSection.products,
      body: [
        const AdminSectionHeader(
          title: "Availability",
          trailing: "Frontend mock state",
        ),
        const SizedBox(height: 12),
        _MetricRow(
          metrics: [
            _MetricCardData(
              label: "Available",
              value: catalog.availableCount.toString(),
              icon: Icons.inventory_2_outlined,
              accent: AppColors.softGold,
            ),
            _MetricCardData(
              label: "Low / Empty",
              value: catalog.lowStockCount.toString(),
              icon: Icons.warning_amber_rounded,
              accent: AppColors.coffeeBrown,
            ),
            _MetricCardData(
              label: "Hidden",
              value: catalog.hiddenCount.toString(),
              icon: Icons.visibility_off_outlined,
              accent: AppColors.mutedForeground,
            ),
          ],
        ),
        const SizedBox(height: 20),
        AdminSectionHeader(
          title: "Menu Items",
          trailing: "${products.length} products",
        ),
        const SizedBox(height: 12),
        _ProductGrid(products: products, catalog: catalog),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final List<_MetricCardData> metrics;

  const _MetricRow({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;
        final children = metrics
            .map(
              (metric) => AdminStatCard(
                value: metric.value,
                label: metric.label,
                icon: metric.icon,
                accent: metric.accent,
              ),
            )
            .toList();

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

class _ProductGrid extends StatelessWidget {
  final List<Product> products;
  final ProductCatalogService catalog;

  const _ProductGrid({required this.products, required this.catalog});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1100
            ? 3
            : width >= 720
            ? 2
            : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 235,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            return _ProductCard(product: products[index], catalog: catalog);
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final ProductCatalogService catalog;

  const _ProductCard({required this.product, required this.catalog});

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(14),
      radius: 16,
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 64,
                  width: 64,
                  color: AppColors.warmBeige,
                  child: Image.asset(product.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.navItem.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(product.price, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              AdminStatusChip(
                label: product.availability.label,
                color: product.availability.color,
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _StockButton(
                icon: Icons.remove_rounded,
                onTap: () => catalog.setStock(product, product.stock - 1),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Stock ${product.stock}",
                    style: AppTextStyles.navItem.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              _StockButton(
                icon: Icons.add_rounded,
                onTap: () => catalog.setStock(product, product.stock + 1),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<ProductAvailability>(
            initialValue: product.availability,
            decoration: InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: ProductAvailability.values.map((status) {
              return DropdownMenuItem(value: status, child: Text(status.label));
            }).toList(),
            onChanged: (status) {
              if (status == null) return;
              catalog.setAvailability(product, status);
            },
          ),
        ],
      ),
    );
  }
}

class _StockButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StockButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: AppColors.softGold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.softGold.withValues(alpha: 0.55)),
        ),
        child: Icon(icon, size: 18, color: AppColors.darkEspresso),
      ),
    );
  }
}

class _MetricCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const _MetricCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });
}
