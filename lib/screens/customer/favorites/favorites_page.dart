import 'package:flutter/material.dart';

import '../../../core/services/favorite_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/product.dart';
import '../../../widgets/bottom_nav.dart';
import '../cart/cart_page.dart';
import '../home/user_mobile_home.dart';
import '../product/product_detail_page.dart';
import '../profile/profile_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final favoriteService = FavoriteService.instance;

  @override
  void initState() {
    super.initState();
    favoriteService.addListener(_refresh);
  }

  @override
  void dispose() {
    favoriteService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
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
    final favorites = favoriteService.favorites;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar(context),
                  const SizedBox(height: 22),
                  const Text(
                    "Favorites",
                    style: TextStyle(
                      fontFamily: AppFonts.righteous,
                      fontSize: 32,
                      color: AppColors.darkEspresso,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Your saved Quezel's treats.",
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            Expanded(
              child: favorites.isEmpty
                  ? _emptyFavorites()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                      itemCount: favorites.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 230,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemBuilder: (context, index) {
                        return _FavoriteCard(product: favorites[index]);
                      },
                    ),
            ),
            CustomerBottomNav(
              activeItem: CustomerNavItem.favorites,
              onHomeTap: () => _openRoot(const UserMobileHome()),
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
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const UserMobileHome()),
              (route) => false,
            );
          },
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Favorites",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }

  Widget _emptyFavorites() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 38,
              color: AppColors.coffeeBrown,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "No favorites yet",
            style: TextStyle(
              fontFamily: AppFonts.righteous,
              fontSize: 24,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the heart icon on a product to save it here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Product product;

  const _FavoriteCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteService = FavoriteService.instance;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.softGold.withOpacity(0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  favoriteService.toggleFavorite(product);
                },
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 22,
                  color: AppColors.coffeeBrown,
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
