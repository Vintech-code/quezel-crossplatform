import 'package:flutter/material.dart';

import '../../../core/services/product_catalog_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/customer_home_data.dart';
import '../../../models/product.dart';
import '../../../widgets/adaptive_image.dart';
import '../../../widgets/bottom_nav.dart';
import '../home/user_mobile_home.dart';
import '../messages/customer_messages_page.dart';
import '../orders/my_orders_page.dart';
import '../product/product_detail_page.dart';
import '../profile/profile_page.dart';

class CustomerMenuPage extends StatefulWidget {
  final String initialCategory;

  const CustomerMenuPage({super.key, this.initialCategory = "All"});

  @override
  State<CustomerMenuPage> createState() => _CustomerMenuPageState();
}

class _CustomerMenuPageState extends State<CustomerMenuPage> {
  final catalog = ProductCatalogService.instance;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = customerCategories.contains(widget.initialCategory)
        ? widget.initialCategory
        : "All";
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

  List<Product> get visibleProducts {
    if (selectedCategory == "All") {
      return catalog.customerSections.values
          .expand((products) => products)
          .toList();
    }

    return catalog.customerSections[selectedCategory] ?? [];
  }

  void _openRoot(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final products = visibleProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 68),
        child: FloatingActionButton(
          onPressed: () => _push(const CustomerMessagesPage()),
          backgroundColor: AppColors.haloPurple,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.chat_bubble_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Menu",
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 30),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: customerCategories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final category = customerCategories[index];
                final active = category == selectedCategory;
                return ChoiceChip(
                  selected: active,
                  showCheckmark: false,
                  label: Text(category),
                  onSelected: (_) =>
                      setState(() => selectedCategory = category),
                  selectedColor: AppColors.coffeeBrown,
                  backgroundColor: AppColors.parchment,
                  labelStyle: AppTextStyles.navItem.copyWith(
                    color: active ? Colors.white : AppColors.darkEspresso,
                    fontWeight: FontWeight.w900,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                    side: BorderSide(
                      color: active
                          ? AppColors.coffeeBrown
                          : AppColors.softGold.withValues(alpha: 0.45),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.sizeOf(context).width >= 700 ? 3 : 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _MenuProductCard(
                  product: product,
                  onTap: () => _push(ProductDetailPage(product: product)),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomerBottomNav(
        activeItem: CustomerNavItem.menu,
        onHomeTap: () => _openRoot(const UserMobileHome()),
        onOrdersTap: () => _push(const MyOrdersPage()),
        onProfileTap: () => _push(const ProfilePage()),
      ),
    );
  }
}

class _MenuProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _MenuProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: AdaptiveImage(path: product.image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.navItem.copyWith(
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.price,
              style: AppTextStyles.navItem.copyWith(
                color: AppColors.coffeeBrown,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
