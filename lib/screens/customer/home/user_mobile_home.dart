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
  "Palamig",
  "Burgers",
  "Fries",
  "Drinks",
  "Combos",
];

final Map<String, List<Product>> productSections = const {
  "Palamig": [
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
  ],

  "Burgers": [
    Product(
      name: "Regular Burger",
      price: "₱59.00",
      kcal: "360 kcal",
      image: "assets/images/burger_regular.png",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Burger bun", calories: "150 kcal"),
        IngredientItem(name: "Burger patty", calories: "180 kcal"),
        IngredientItem(name: "Burger sauce", calories: "30 kcal"),
      ],
    ),
    Product(
      name: "Cheese Burger",
      price: "₱69.00",
      kcal: "390 kcal",
      image: "assets/images/burger_cheese.png",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Burger bun", calories: "150 kcal"),
        IngredientItem(name: "Burger patty", calories: "180 kcal"),
        IngredientItem(name: "Cheese", calories: "60 kcal"),
      ],
    ),
    Product(
      name: "Bacon Lettuce Cheese Burger",
      price: "₱85.00",
      kcal: "430 kcal",
      image: "assets/images/burger_lettucecheese.png",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Burger bun", calories: "150 kcal"),
        IngredientItem(name: "Burger patty", calories: "180 kcal"),
        IngredientItem(name: "Bacon", calories: "70 kcal"),
        IngredientItem(name: "Lettuce", calories: "10 kcal"),
        IngredientItem(name: "Cheese", calories: "60 kcal"),
      ],
    ),
  ],

  "Fries": [
    Product(
      name: "Regular Fries Solo",
      price: "₱35.00",
      kcal: "270 kcal",
      image: "assets/images/fries_regular.png",
      addOns: [
        ProductAddOn(name: "Cheese Flavor Upgrade", price: "₱3.00", type: "Flavor"),
        ProductAddOn(name: "Sour Cream Flavor Upgrade", price: "₱5.00", type: "Flavor"),
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Potato fries", calories: "250 kcal"),
        IngredientItem(name: "Salt", calories: "20 kcal"),
      ],
    ),
    Product(
      name: "Fries with Cheese",
      price: "₱39.00",
      kcal: "310 kcal",
      image: "assets/images/fries_cheese.png",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Potato fries", calories: "250 kcal"),
        IngredientItem(name: "Cheese flavor", calories: "60 kcal"),
      ],
    ),
    Product(
      name: "Sour Cream Fries",
      price: "₱45.00",
      kcal: "300 kcal",
      image: "assets/images/fries_sourcream.png",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Potato fries", calories: "250 kcal"),
        IngredientItem(name: "Sour cream flavor", calories: "50 kcal"),
      ],
    ),
  ],

  "Drinks": [
    Product(
      name: "Solo Drinks Large",
      price: "₱20.00",
      kcal: "120 kcal",
      image: "assets/images/icedtea_large.png",
      ingredients: [
        IngredientItem(name: "Large drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Lemon Juice Large",
      price: "₱45.00",
      kcal: "140 kcal",
      image: "assets/images/lemonjuice_large.png",
      ingredients: [
        IngredientItem(name: "Lemon juice", calories: "25 kcal"),
        IngredientItem(name: "Sugar syrup", calories: "115 kcal"),
      ],
    ),
    Product(
      name: "Iced Tea Regular",
      price: "₱35.00",
      kcal: "120 kcal",
      image: "assets/images/icedtea_regular.png",
      ingredients: [
        IngredientItem(name: "Tea", calories: "15 kcal"),
        IngredientItem(name: "Sugar syrup", calories: "105 kcal"),
      ],
    ),
    Product(
      name: "Lemon Juice Regular",
      price: "₱35.00",
      kcal: "110 kcal",
      image: "assets/images/lemonjuice_regular.png",
      ingredients: [
        IngredientItem(name: "Lemon juice", calories: "20 kcal"),
        IngredientItem(name: "Sugar syrup", calories: "90 kcal"),
      ],
    ),
  ],

  "Combos": [
    Product(
      name: "Regular Burger with Large Drink",
      price: "₱76.00",
      kcal: "480 kcal",
      image: "assets/images/regular_burger_combo.png",
      savings: "Save ₱3",
      isCombo: true,
      description: "Regular burger paired with a large drink.",
      addOns: [
        ProductAddOn(name: "Egg Add-on", price: "₱16.00", type: "Add-on"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Regular burger", calories: "360 kcal"),
        IngredientItem(name: "Large drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Regular Burger Combo Meal",
      price: "₱99.00",
      kcal: "750 kcal",
      image: "assets/images/regular_sulit_pairs.png",
      savings: "Save ₱10",
      isCombo: true,
      description: "Regular burger with regular fries and regular drink.",
      addOns: [
        ProductAddOn(name: "Cheese Fries Upgrade", price: "₱3.00", type: "Flavor"),
        ProductAddOn(name: "Sour Cream Fries Upgrade", price: "₱5.00", type: "Flavor"),
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Regular burger", calories: "360 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Cheese Burger Combo Meal",
      price: "₱109.00",
      kcal: "780 kcal",
      image: "assets/images/cheese_burger_combo.png",
      savings: "Save ₱10",
      isCombo: true,
      description: "Cheese burger with regular fries and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Cheese burger", calories: "390 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Cheese Sulit Pairs",
      price: "₱109.00",
      kcal: "780 kcal",
      image: "assets/images/cheese_sulit_pairs.png",
      savings: "Save ₱10",
      isCombo: true,
      description: "Cheese burger with regular fries and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Cheese burger", calories: "390 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Supreme Regular Burger Combo",
      price: "₱152.00",
      kcal: "1035 kcal",
      image: "assets/images/regular_supreme_combo.png",
      savings: "Save ₱12",
      isCombo: true,
      description: "Regular burger, medium halo-halo, regular fries, and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Regular burger", calories: "360 kcal"),
        IngredientItem(name: "Medium halo-halo", calories: "285 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
    Product(
      name: "Cheese Supreme Combo",
      price: "₱152.00",
      kcal: "1065 kcal",
      image: "assets/images/cheese_supreme_combo.png",
      savings: "Save ₱12",
      isCombo: true,
      description: "Cheese burger, medium halo-halo, regular fries, and regular drink.",
      addOns: [
        ProductAddOn(name: "Fries Hot Sauce", price: "₱9.00", type: "Sauce"),
        ProductAddOn(name: "Spicy Burger Sauce", price: "₱5.00", type: "Sauce"),
      ],
      ingredients: [
        IngredientItem(name: "Cheese burger", calories: "390 kcal"),
        IngredientItem(name: "Medium halo-halo", calories: "285 kcal"),
        IngredientItem(name: "Regular fries", calories: "270 kcal"),
        IngredientItem(name: "Regular drink", calories: "120 kcal"),
      ],
    ),
  ],
};

  Map<String, List<Product>> get filteredProductSections {
    final selected = categories[selectedCategory];
    final query = searchQuery.trim().toLowerCase();

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
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
                    visibleSections.isEmpty
                        ? _emptyProducts()
                        : Column(
                            children: visibleSections.entries.map((section) {
                              return _ProductSection(
                                title: section.key,
                                products: section.value,
                                onProductTap: (product) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailPage(
                                        product: product,
                                      ),
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
}

class _ProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;
  final void Function(Product product) onProductTap;

  const _ProductSection({
    required this.title,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppFonts.righteous,
                  fontSize: 24,
                  color: AppColors.darkEspresso,
                ),
              ),
              const Spacer(),
              const Text(
                "Swipe",
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: AppColors.mutedForeground,
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 238,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 4),
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final product = products[index];

                return SizedBox(
                  width: 168,
                  child: _ProductCard(
                    product: product,
                    onTap: () => onProductTap(product),
                  ),
                );
              },
            ),
          ),
        ],
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