import 'package:flutter/material.dart';

import '../../../core/services/product_catalog_service.dart';
import '../../../data/customer_home_data.dart';
import '../../../models/product.dart';
import '../messages/customer_messages_page.dart';
import '../menu/customer_menu_page.dart';
import '../orders/my_orders_page.dart';
import '../product/product_detail_page.dart';
import '../profile/profile_page.dart';
import 'user_home_mobile_view.dart';
import 'user_home_web_view.dart';

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

  Map<String, List<Product>> get allProductSections {
    return productCatalog.customerSections;
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

  void _openProduct(Product product) {
    _pushPage(ProductDetailPage(product: product));
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    if (isWide) {
      return UserHomeWebView(
        categories: categories,
        selectedCategory: selectedCategory,
        visibleSections: filteredProductSections,
        onCategorySelected: (index) {
          setState(() {
            selectedCategory = index;
          });
        },
        onProductTap: _openProduct,
        onHomeTap: () {},
        onOrdersTap: () => _pushPage(const MyOrdersPage()),
        onCartTap: () => _pushPage(const MyOrdersPage()),
        onProfileTap: () => _openRoot(const ProfilePage()),
      );
    }

    return UserHomeMobileView(
      productSections: allProductSections,
      onProductTap: _openProduct,
      onProfileTap: () => _openRoot(const ProfilePage()),
      onMenuTap: (category) =>
          _pushPage(CustomerMenuPage(initialCategory: category)),
      onViewAllMenuTap: () => _pushPage(const CustomerMenuPage()),
      onMessagesTap: () => _pushPage(const CustomerMessagesPage()),
      onOrdersTap: () => _pushPage(const MyOrdersPage()),
    );
  }
}
