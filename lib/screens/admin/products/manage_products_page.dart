import 'package:flutter/material.dart';
import '../../../core/services/product_catalog_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../models/product_availability.dart';
import '../../../widgets/adaptive_image.dart';
import '../widgets/admin_section_header.dart';
import '../widgets/admin_shell.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_surface_card.dart';
import 'product_editor_page.dart';

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

  void _openAddProductPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductEditorPage()),
    );
  }

  void _openEditProductPage(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductEditorPage(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = catalog.products;

    return AdminShell(
      title: "Product Management",
      subtitle: "Update availability for menu items without a backend.",
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
              label: "Unavailable",
              value: catalog.unavailableCount.toString(),
              icon: Icons.block_rounded,
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
        Row(
          children: [
            Text(
              "Menu Items",
              style: AppTextStyles.navItem.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
            const Spacer(),
            Text(
              "${products.length} products",
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _openAddProductPage,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text("Add product"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coffeeBrown,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ProductGrid(
          products: products,
          catalog: catalog,
          onEdit: _openEditProductPage,
        ),
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
  final ValueChanged<Product> onEdit;

  const _ProductGrid({
    required this.products,
    required this.catalog,
    required this.onEdit,
  });

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
            mainAxisExtent: 200,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            final category = catalog.categoryForProduct(product.name) ?? "Menu";
            return _ProductCard(
              product: product,
              category: category,
              catalog: catalog,
              onEdit: () => onEdit(product),
            );
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final String category;
  final ProductCatalogService catalog;
  final VoidCallback onEdit;

  const _ProductCard({
    required this.product,
    required this.category,
    required this.catalog,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(12),
      radius: AppRadius.md,
      child: Row(
        children: [
          Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              color: AppColors.warmBeige,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.softGold.withValues(alpha: 0.35),
              ),
            ),
            child: Center(
              child: AdaptiveImage(
                path: product.image,
                fit: BoxFit.contain,
                height: 72,
                width: 72,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(height: 4),
                Text(
                  product.description?.trim().isNotEmpty == true
                      ? product.description!
                      : "No description added",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      product.price,
                      style: AppTextStyles.navItem.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.coffeeBrown,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softGold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: AppColors.softGold.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.softGold.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.coffeeBrown,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 160,
                child: DropdownButtonFormField<ProductAvailability>(
                  initialValue: product.availability,
                  decoration: InputDecoration(
                    hintText: "Status",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                  ),
                  isExpanded: true,
                  items: ProductAvailability.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.label),
                    );
                  }).toList(),
                  onChanged: (status) {
                    if (status == null) return;
                    catalog.setAvailability(product, status);
                  },
                ),
              ),
            ],
          ),
        ],
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
