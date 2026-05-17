import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/home_product_section.dart';

class UserHomeWebView extends StatelessWidget {
  final List<String> categories;
  final int selectedCategory;
  final Map<String, List<Product>> visibleSections;
  final ValueChanged<int> onCategorySelected;
  final ValueChanged<Product> onProductTap;
  final VoidCallback onHomeTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;

  const UserHomeWebView({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.visibleSections,
    required this.onCategorySelected,
    required this.onProductTap,
    required this.onHomeTap,
    required this.onOrdersTap,
    required this.onCartTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _WebMenuHeader(
              onHomeTap: onHomeTap,
              onOrdersTap: onOrdersTap,
              onCartTap: onCartTap,
              onProfileTap: onProfileTap,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 44, 0, 42),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Menu",
                      style: AppTextStyles.navItem.copyWith(
                        color: AppColors.coffeeBrown,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Menu",
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 72,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                    const SizedBox(height: 58),
                    _WebCategoryTabs(
                      categories: categories,
                      selectedIndex: selectedCategory,
                      onSelected: onCategorySelected,
                    ),
                    const SizedBox(height: 76),
                    visibleSections.isEmpty
                        ? const HomeEmptyState()
                        : Column(
                            children: visibleSections.entries.map((section) {
                              return HomeProductSection(
                                title: section.key,
                                products: section.value,
                                onProductTap: onProductTap,
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebMenuHeader extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onOrdersTap;
  final VoidCallback onCartTap;
  final VoidCallback onProfileTap;

  const _WebMenuHeader({
    required this.onHomeTap,
    required this.onOrdersTap,
    required this.onCartTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppColors.coffeeBrown,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1540),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Row(
              children: [
                Text(
                  "Quezel",
                  style: AppTextStyles.navLogo.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 0,
                  ),
                ),
                const Spacer(),
                _WebHeaderLink(label: "Home", onTap: onHomeTap),
                _WebHeaderLink(label: "Orders", onTap: onOrdersTap),
                _WebHeaderLink(label: "Orders", onTap: onCartTap),
                _WebHeaderLink(label: "Profile", onTap: onProfileTap),
                const SizedBox(width: 22),
                FilledButton(
                  onPressed: onCartTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.coffeeBrown,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    "Order now",
                    style: AppTextStyles.navItem.copyWith(
                      color: AppColors.coffeeBrown,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WebHeaderLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _WebHeaderLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      child: Text(
        label,
        style: AppTextStyles.navItem.copyWith(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _WebCategoryTabs extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _WebCategoryTabs({
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1540),
      child: SizedBox(
        height: 64,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 64),
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final active = selectedIndex == index;
            return TextButton(
              onPressed: () => onSelected(index),
              style: TextButton.styleFrom(
                backgroundColor: active
                    ? AppColors.coffeeBrown
                    : Colors.transparent,
                foregroundColor: active ? Colors.white : AppColors.darkEspresso,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Text(
                categories[index],
                style: AppTextStyles.navItem.copyWith(
                  color: active ? Colors.white : AppColors.darkEspresso,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
