import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';

import '../../../core/services/order_service.dart';
import '../../../core/services/favorite_service.dart';

import '../cart/cart_page.dart';
import '../favorites/favorites_page.dart';
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

  final categories = const [
    "All",
    "Halo-Halo",
    "Crema",
    "Mais",
  ];

  final products = const [
    Product(
      name: "Halo-Halo Large",
      price: "₱78.00",
      kcal: "354 kcal",
      image: "assets/images/1.png",
    ),
    Product(
      name: "Halo-Halo Medium",
      price: "₱55.00",
      kcal: "285 kcal",
      image: "assets/images/2.png",
    ),
    Product(
      name: "Crema De Leche",
      price: "₱78.00",
      kcal: "320 kcal",
      image: "assets/images/3.png",
    ),
    Product(
      name: "Mais Con Yelo",
      price: "₱65.00",
      kcal: "260 kcal",
      image: "assets/images/4.png",
    ),
  ];

  List<Product> get filteredProducts {
    final selected = categories[selectedCategory].toLowerCase();
    final query = searchQuery.trim().toLowerCase();

    return products.where((product) {
      final name = product.name.toLowerCase();

      final matchesCategory =
          selected == "all" || name.contains(selected);

      final matchesSearch =
          query.isEmpty || name.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(),

                  const SizedBox(height: 28),

                  const Text(
                    "Fresh and Cool\nTreats for You",
                    style: TextStyle(
                      fontFamily: AppFonts.righteous,
                      fontSize: 34,
                      height: 1.1,
                      color: AppColors.darkEspresso,
                    ),
                  ),

                  const SizedBox(height: 22),

                  _searchBar(),

                  const SizedBox(height: 22),

                  _categoryTabs(),

                  const SizedBox(height: 20),

                  visibleProducts.isEmpty
                      ? _emptyProducts()
                      : GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount: visibleProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 230,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemBuilder: (context, index) {
                            return _ProductCard(
                              product: visibleProducts[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailPage(
                                      product:
                                          visibleProducts[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ],
              ),
            ),

            Positioned(
              left: 22,
              right: 22,
              bottom: 20,
              child: _BottomNav(
                onCartTap: openCart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
          child: Image.asset(
            "assets/images/logo3.png",
            height: 48,
            width: 48,
            fit: BoxFit.cover,
          ),
        ),

        const Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              "Quezel's",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),

        AnimatedBuilder(
          animation: OrderService.instance,
          builder: (context, _) {
            final totalOrders =
                OrderService.instance.orders.length;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const MyOrdersPage(),
                  ),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.local_shipping_outlined,
                    size: 30,
                    color: AppColors.darkEspresso,
                  ),

                  if (totalOrders > 0)
                    Positioned(
                      right: -10,
                      top: -8,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              AppColors.coffeeBrown,
                          borderRadius:
                              BorderRadius.circular(
                                  999),
                        ),
                        constraints:
                            const BoxConstraints(
                          minWidth: 20,
                          minHeight: 18,
                        ),
                        child: Text(
                          totalOrders > 99
                              ? "99+"
                              : totalOrders
                                  .toString(),
                          textAlign:
                              TextAlign.center,
                          style: const TextStyle(
                            fontFamily:
                                AppFonts.poppins,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 54,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.75),
              borderRadius:
                  BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  size: 22,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration:
                        const InputDecoration(
                      hintText: "Search here",
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontFamily:
                          AppFonts.poppins,
                      fontSize: 14,
                      color:
                          AppColors.darkEspresso,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        Container(
          height: 54,
          width: 54,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }

  Widget _emptyProducts() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 52,
              color: AppColors
                  .mutedForeground
                  .withOpacity(0.8),
            ),

            const SizedBox(height: 12),

            const Text(
              "No products found",
              style: TextStyle(
                fontFamily: AppFonts.righteous,
                fontSize: 24,
                color: AppColors.darkEspresso,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Try another keyword or category.",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryTabs() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final active =
              selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 22,
              ),
              decoration: BoxDecoration(
                color: active
                    ? AppColors.coffeeBrown
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(999),
                border: Border.all(
                  color:
                      AppColors.coffeeBrown,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontFamily:
                        AppFonts.poppins,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                    color: active
                        ? AppColors
                            .creamWhite
                        : AppColors
                            .darkEspresso,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.softGold
                .withOpacity(0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  FavoriteService.instance
                      .toggleFavorite(product);
                },
                child: AnimatedBuilder(
                  animation:
                      FavoriteService.instance,
                  builder: (context, _) {
                    final favorite =
                        FavoriteService.instance
                            .isFavorite(product);

                    return Container(
                      height: 32,
                      width: 32,
                      decoration:
                          const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        favorite
                            ? Icons
                                .favorite_rounded
                            : Icons
                                .favorite_border_rounded,
                        size: 18,
                        color: AppColors
                            .coffeeBrown,
                      ),
                    );
                  },
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: Image.asset(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Text(
              product.name,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  size: 14,
                  color:
                      AppColors.coffeeBrown,
                ),

                Text(
                  product.kcal,
                  style: const TextStyle(
                    fontFamily:
                        AppFonts.poppins,
                    fontSize: 11,
                    color: AppColors
                        .mutedForeground,
                  ),
                ),

                const Spacer(),

                Text(
                  product.price,
                  style: const TextStyle(
                    fontFamily:
                        AppFonts.poppins,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                    color: AppColors
                        .darkEspresso,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final VoidCallback onCartTap;

  const _BottomNav({
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkEspresso,
        borderRadius:
            BorderRadius.circular(999),
        boxShadow: AppShadows.diffuse,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          const _BottomIcon(
            icon: Icons.home_rounded,
            active: true,
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const FavoritesPage(),
                ),
              );
            },
            child: const _BottomIcon(
              icon:
                  Icons.favorite_border_rounded,
            ),
          ),

          GestureDetector(
            onTap: onCartTap,
            child: const _BottomIcon(
              icon:
                  Icons.shopping_cart_outlined,
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ProfilePage(),
                ),
              );
            },
            child: const _BottomIcon(
              icon:
                  Icons.person_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  final IconData icon;
  final bool active;

  const _BottomIcon({
    required this.icon,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        color: active
            ? AppColors.coffeeBrown
            : Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: active
            ? Colors.white
            : AppColors.darkEspresso,
      ),
    );
  }
}