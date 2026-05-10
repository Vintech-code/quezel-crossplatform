import 'package:flutter/material.dart';

import '../../../core/services/favorite_service.dart';
import '../../../core/services/order_service.dart';
import '../../../core/services/user_address_service.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../widgets/bottom_nav.dart';
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
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "35 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "45 kcal"),
        IngredientItem(name: "Sweetened banana", calories: "60 kcal"),
        IngredientItem(name: "Sweet beans", calories: "55 kcal"),
        IngredientItem(name: "Nata de coco", calories: "35 kcal"),
        IngredientItem(name: "Leche flan", calories: "75 kcal"),
        IngredientItem(name: "Ube topping", calories: "49 kcal"),
      ],
    ),
    Product(
      name: "Halo-Halo Medium",
      price: "₱55.00",
      kcal: "285 kcal",
      image: "assets/images/2.png",
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "30 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "38 kcal"),
        IngredientItem(name: "Sweetened banana", calories: "48 kcal"),
        IngredientItem(name: "Sweet beans", calories: "42 kcal"),
        IngredientItem(name: "Nata de coco", calories: "28 kcal"),
        IngredientItem(name: "Leche flan", calories: "60 kcal"),
        IngredientItem(name: "Ube topping", calories: "39 kcal"),
      ],
    ),
    Product(
      name: "Crema De Leche",
      price: "₱78.00",
      kcal: "320 kcal",
      image: "assets/images/3.png",
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "35 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "45 kcal"),
        IngredientItem(name: "Cream milk", calories: "85 kcal"),
        IngredientItem(name: "Leche flan", calories: "90 kcal"),
        IngredientItem(name: "Caramel syrup", calories: "40 kcal"),
        IngredientItem(name: "Cheese topping", calories: "25 kcal"),
      ],
    ),
    Product(
      name: "Mais Con Yelo",
      price: "₱65.00",
      kcal: "260 kcal",
      image: "assets/images/4.png",
      ingredients: [
        IngredientItem(name: "Shaved ice", calories: "30 kcal"),
        IngredientItem(name: "Sweet corn", calories: "85 kcal"),
        IngredientItem(name: "Evaporated milk", calories: "45 kcal"),
        IngredientItem(name: "Condensed milk", calories: "55 kcal"),
        IngredientItem(name: "Cornflakes", calories: "30 kcal"),
        IngredientItem(name: "Cheese topping", calories: "15 kcal"),
      ],
    ),
  ];

  List<Product> get filteredProducts {
    final selected = categories[selectedCategory].toLowerCase();
    final query = searchQuery.trim().toLowerCase();

    return products.where((product) {
      final name = product.name.toLowerCase();
      final matchesCategory = selected == "all" || name.contains(selected);
      final matchesSearch = query.isEmpty || name.contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _openRoot(Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void _pushPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
              child: _topBar(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            physics: const NeverScrollableScrollPhysics(),
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
                                      builder: (_) => ProductDetailPage(
                                        product: visibleProducts[index],
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
            ),
            CustomerBottomNav(
              activeItem: CustomerNavItem.home,
              onFavoritesTap: () => _openRoot(const FavoritesPage()),
              onCartTap: () => _pushPage(const CartPage()),
              onProfileTap: () => _pushPage(const ProfilePage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedBuilder(
          animation: UserProfileService.instance,
          builder: (context, _) {
            return GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                  (route) => false,
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.softGold.withOpacity(0.55),
                    width: 1.4,
                  ),
                ),
                child: Center(
                  child: Text(
                    UserProfileService.instance.initials,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.coffeeBrown,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Flexible(
          child: AnimatedBuilder(
            animation: UserAddressService.instance,
            builder: (context, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined, size: 22),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      UserAddressService.instance.barangayAddress,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: OrderService.instance,
          builder: (context, _) {
            final totalOrders = OrderService.instance.orders.length;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: AppColors.creamWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      size: 28,
                      color: AppColors.darkEspresso,
                    ),
                  ),
                  if (totalOrders > 0)
                    Positioned(
                      right: -2,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.coffeeBrown,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 18,
                        ),
                        child: Text(
                          totalOrders > 99 ? "99+" : totalOrders.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
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
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "Search here",
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ],
      ),
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
              color: AppColors.mutedForeground.withOpacity(0.8),
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
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final active = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: active ? AppColors.softGold : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.softGold),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : AppColors.darkEspresso,
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.softGold.withOpacity(0.45),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  FavoriteService.instance.toggleFavorite(product);
                },
                child: AnimatedBuilder(
                  animation: FavoriteService.instance,
                  builder: (context, _) {
                    final favorite =
                        FavoriteService.instance.isFavorite(product);

                    return Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        favorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: AppColors.coffeeBrown,
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
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.darkEspresso,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.local_fire_department,
                  size: 14,
                  color: AppColors.coffeeBrown,
                ),
                Text(
                  product.kcal,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 11,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const Spacer(),
                Text(
                  product.price,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkEspresso,
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
