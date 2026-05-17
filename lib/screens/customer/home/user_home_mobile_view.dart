import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/user_address_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../widgets/adaptive_image.dart';
import '../../../widgets/bottom_nav.dart';

class UserHomeMobileView extends StatelessWidget {
  final Map<String, List<Product>> productSections;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<String> onMenuTap;
  final VoidCallback onViewAllMenuTap;
  final VoidCallback onProfileTap;
  final VoidCallback onMessagesTap;
  final VoidCallback onOrdersTap;

  const UserHomeMobileView({
    super.key,
    required this.productSections,
    required this.onProductTap,
    required this.onMenuTap,
    required this.onViewAllMenuTap,
    required this.onProfileTap,
    required this.onMessagesTap,
    required this.onOrdersTap,
  });

  List<Product> get _allProducts {
    return productSections.values.expand((products) => products).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _allProducts;
    final secondHeroProduct = products.length > 1
        ? products[1]
        : products.isNotEmpty
        ? products.first
        : null;
    final bestsellers = products.take(6).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 68),
        child: _FloatingMessagesButton(onTap: onMessagesTap),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(height: 292, color: AppColors.coffeeBrown),
                    Padding(
                      padding: const EdgeInsets.only(top: 124),
                      child: _HomeContentPanel(
                        productSections: productSections,
                        products: products,
                        secondHeroProduct: secondHeroProduct,
                        bestsellers: bestsellers,
                        onProductTap: onProductTap,
                        onMenuTap: onMenuTap,
                        onViewAllMenuTap: onViewAllMenuTap,
                        onOrdersTap: onOrdersTap,
                      ),
                    ),
                    _MobileHeroHeader(onProfileTap: onProfileTap),
                  ],
                ),
              ),
            ),
            CustomerBottomNav(
              activeItem: CustomerNavItem.home,
              onMenuTap: onViewAllMenuTap,
              onOrdersTap: onOrdersTap,
              onProfileTap: onProfileTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingMessagesButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FloatingMessagesButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.haloPurple,
      shape: const CircleBorder(),
      elevation: 10,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          height: 58,
          width: 58,
          child: Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _MobileHeroHeader extends StatelessWidget {
  final VoidCallback onProfileTap;

  const _MobileHeroHeader({required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 54, 28, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Join Quezel!",
                      style: AppTextStyles.navItem.copyWith(
                        fontFamily: AppFonts.quezelRound,
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Cool treats, burgers, and deals made for you.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navItem.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          FilledButton(
            onPressed: onProfileTap,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.coffeeBrown,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              "Register / Log in",
              style: AppTextStyles.navItem.copyWith(
                color: AppColors.coffeeBrown,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContentPanel extends StatelessWidget {
  final Map<String, List<Product>> productSections;
  final List<Product> products;
  final Product? secondHeroProduct;
  final List<Product> bestsellers;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<String> onMenuTap;
  final VoidCallback onViewAllMenuTap;
  final VoidCallback onOrdersTap;

  const _HomeContentPanel({
    required this.productSections,
    required this.products,
    required this.secondHeroProduct,
    required this.bestsellers,
    required this.onProductTap,
    required this.onMenuTap,
    required this.onViewAllMenuTap,
    required this.onOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 34),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: _AddressSummary(),
          ),
          const SizedBox(height: 42),
          _SectionHeader(title: "What's New"),
          const SizedBox(height: 18),
          _PromoCarousel(
            products: products.take(3).toList(),
            onProductTap: onProductTap,
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: _OrderBanner(product: secondHeroProduct, onTap: onOrdersTap),
          ),
          const SizedBox(height: 42),
          _SectionHeader(
            title: "Featured Menu",
            action: "View All",
            onActionTap: onViewAllMenuTap,
          ),
          const SizedBox(height: 20),
          _FeaturedMenuStrip(
            productSections: productSections,
            onMenuTap: onMenuTap,
          ),
          const SizedBox(height: 36),
          _DealsBand(onOrdersTap: onOrdersTap),
          const SizedBox(height: 42),
          _SectionHeader(title: "Bestsellers"),
          const SizedBox(height: 18),
          _BestSellerStrip(products: bestsellers, onProductTap: onProductTap),
          const SizedBox(height: 34),
          _BottomOrderBanner(onOrdersTap: onOrdersTap),
        ],
      ),
    );
  }
}

class _AddressSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UserAddressService.instance,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFFFFA24D),
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Deliver Today, ASAP",
                    style: AppTextStyles.navItem.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    UserAddressService.instance.hasCompleteAddress
                        ? UserAddressService.instance.fullAddress
                        : "Add Delivery Address",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.navItem.copyWith(
                      color: AppColors.mutedForeground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onActionTap;

  const _SectionHeader({required this.title, this.action, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.navItem.copyWith(
                fontFamily: AppFonts.quezelRound,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (action != null)
            InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  action!,
                  style: AppTextStyles.navItem.copyWith(
                    color: AppColors.coffeeBrown,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PromoCarousel extends StatefulWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  const _PromoCarousel({required this.products, required this.onProductTap});

  @override
  State<_PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<_PromoCarousel> {
  late final PageController controller;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 0.9);
    timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.products.length < 2 || !controller.hasClients) {
        return;
      }

      final nextPage = (controller.page?.round() ?? 0) + 1;
      controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();
    final colors = [
      AppColors.coffeeBrown,
      AppColors.haloPurple,
      const Color(0xFFFF7900),
    ];

    return SizedBox(
      height: 210,
      child: PageView.builder(
        controller: controller,
        padEnds: false,
        itemBuilder: (context, index) {
          final product = widget.products[index % widget.products.length];
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 28 : 8, right: 8),
            child: _PromoCard(
              product: product,
              color: colors[index % colors.length],
              onTap: () => widget.onProductTap(product),
            ),
          );
        },
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final Product product;
  final Color color;
  final VoidCallback onTap;

  const _PromoCard({
    required this.product,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: Colors.white,
                      fontSize: 30,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.price,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.navItem.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 132,
              height: 150,
              child: AdaptiveImage(path: product.image, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderBanner extends StatelessWidget {
  final Product? product;
  final VoidCallback onTap;

  const _OrderBanner({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      padding: const EdgeInsets.fromLTRB(18, 14, 22, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7900),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          if (product != null)
            Expanded(
              child: AdaptiveImage(path: product!.image, fit: BoxFit.contain),
            )
          else
            const Spacer(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Craving your Quezel favorites?",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navItem.copyWith(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.coffeeBrown,
                    minimumSize: const Size.fromHeight(42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    "Order Now!",
                    style: AppTextStyles.navItem.copyWith(
                      color: AppColors.coffeeBrown,
                      fontWeight: FontWeight.w900,
                    ),
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

class _FeaturedMenuStrip extends StatelessWidget {
  final Map<String, List<Product>> productSections;
  final ValueChanged<String> onMenuTap;

  const _FeaturedMenuStrip({
    required this.productSections,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final entries = productSections.entries
        .where((entry) => entry.value.isNotEmpty)
        .take(6)
        .toList();

    return SizedBox(
      height: 136,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: entries.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final product = entry.value.first;
          return GestureDetector(
            onTap: () => onMenuTap(entry.key),
            child: SizedBox(
              width: 104,
              child: Column(
                children: [
                  Expanded(
                    child: AdaptiveImage(
                      path: product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    entry.key,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.navItem.copyWith(
                      fontSize: 14,
                      height: 1.15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DealsBand extends StatelessWidget {
  final VoidCallback onOrdersTap;

  const _DealsBand({required this.onOrdersTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.parchment,
      padding: const EdgeInsets.fromLTRB(28, 34, 28, 42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore Deals",
            style: AppTextStyles.navItem.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: onOrdersTap,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 128,
                    decoration: const BoxDecoration(
                      color: AppColors.coffeeBrown,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(18),
                      ),
                    ),
                    child: const Icon(
                      Icons.delivery_dining_rounded,
                      color: Colors.white,
                      size: 72,
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Delivery deal available",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.navItem.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Text(
                          "Available for Quezel orders",
                          style: AppTextStyles.navItem.copyWith(
                            color: AppColors.mutedForeground,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BestSellerStrip extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  const _BestSellerStrip({required this.products, required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final product = products[index];
          return _BestSellerCard(
            product: product,
            onTap: () => onProductTap(product),
          );
        },
      ),
    );
  }
}

class _BestSellerCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _BestSellerCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 148,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 132,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AdaptiveImage(
                      path: product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.coffeeBrown,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.navItem.copyWith(
                fontSize: 16,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.price,
              style: AppTextStyles.navItem.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomOrderBanner extends StatelessWidget {
  final VoidCallback onOrdersTap;

  const _BottomOrderBanner({required this.onOrdersTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.coffeeBrown,
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Craving your Quezel favorites?",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.navItem.copyWith(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          FilledButton.icon(
            onPressed: onOrdersTap,
            icon: const Icon(Icons.chevron_right_rounded),
            label: const Text("Order Now!"),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.coffeeBrown,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              textStyle: AppTextStyles.navItem.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
