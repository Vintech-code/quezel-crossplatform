import 'package:flutter/material.dart';

import '../../../data/customer_home_data.dart';
import '../../../core/services/product_catalog_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../home/widgets/home_category_tabs.dart';
import '../home/widgets/home_empty_state.dart';
import '../home/widgets/home_product_section.dart';
import '../home/widgets/home_search_bar.dart';
import '../home/widgets/home_top_bar.dart';
import '../../../widgets/bottom_nav.dart';
import '../cart/cart_page.dart';
import '../favorites/favorites_page.dart';
import '../messages/customer_messages_page.dart';
import '../orders/my_orders_page.dart';
import '../product/product_detail_page.dart';
import '../profile/profile_page.dart';

class UserMobileHome extends StatefulWidget {
  const UserMobileHome({super.key});

  @override
  State<UserMobileHome> createState() => _UserMobileHomeState();
}

class _UserMobileHomeState extends State<UserMobileHome> {
  int selectedCategory = 0;
  String searchQuery = "";

  final List<String> categories = customerCategories;
  final productCatalog = ProductCatalogService.instance;

  @override
  void initState() {
    super.initState();
    productCatalog.addListener(_refresh);
  }

  @override
  void dispose() {
    productCatalog.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Map<String, List<Product>> get filteredProductSections {
    final selected = categories[selectedCategory];
    final query = searchQuery.trim().toLowerCase();
    final productSections = productCatalog.customerSections;

    final entries = selected == "All"
        ? productSections.entries
        : productSections.entries.where((entry) => entry.key == selected);

    final filtered = <String, List<Product>>{};

    for (final entry in entries) {
      final products = entry.value.where((product) {
        final name = product.name.toLowerCase();
        return query.isEmpty || name.contains(query);
      }).toList();

      if (products.isNotEmpty) {
        filtered[entry.key] = products;
      }
    }

    return filtered;
  }

  void _openRoot(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void _pushPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final visibleSections = filteredProductSections;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
              child: HomeTopBar(
                onProfileTap: () => _openRoot(const ProfilePage()),
                onOrdersTap: () => _pushPage(const MyOrdersPage()),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Fresh and Cool\nTreats for You",
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 34,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 22),
                    HomeSearchBar(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 22),
                    HomeCategoryTabs(
                      categories: categories,
                      selectedIndex: selectedCategory,
                      onSelected: (index) {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    visibleSections.isEmpty
                        ? const HomeEmptyState()
                        : Column(
                            children: visibleSections.entries.map((section) {
                              return HomeProductSection(
                                title: section.key,
                                products: section.value,
                                onProductTap: (product) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailPage(product: product),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
            CustomerBottomNav(
              activeItem: CustomerNavItem.home,
              onFavoritesTap: () => _openRoot(const FavoritesPage()),
              onMessagesTap: () => _pushPage(const CustomerMessagesPage()),
              onCartTap: () => _pushPage(const CartPage()),
              onProfileTap: () => _pushPage(const ProfilePage()),
            ),
          ],
        ),
      ),
    );
  }
}
