import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

enum CustomerNavItem {
  home,
  favorites,
  cart,
  profile,
}

class CustomerBottomNav extends StatelessWidget {
  final CustomerNavItem activeItem;
  final VoidCallback? onHomeTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const CustomerBottomNav({
    super.key,
    required this.activeItem,
    this.onHomeTap,
    this.onFavoritesTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.darkEspresso,
        border: Border(
          top: BorderSide(
            color: AppColors.softGold.withOpacity(0.5),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _NavButton(
              icon: Icons.home_rounded,
              label: "Home",
              active: activeItem == CustomerNavItem.home,
              onTap: activeItem == CustomerNavItem.home ? null : onHomeTap,
            ),
            _NavButton(
              icon: Icons.favorite_border_rounded,
              label: "Favorites",
              active: activeItem == CustomerNavItem.favorites,
              onTap: activeItem == CustomerNavItem.favorites
                  ? null
                  : onFavoritesTap,
            ),
            _NavButton(
              icon: Icons.shopping_cart_outlined,
              label: "Cart",
              active: activeItem == CustomerNavItem.cart,
              onTap: activeItem == CustomerNavItem.cart ? null : onCartTap,
            ),
            _NavButton(
              icon: Icons.person_outline_rounded,
              label: "Profile",
              active: activeItem == CustomerNavItem.profile,
              onTap:
                  activeItem == CustomerNavItem.profile ? null : onProfileTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              height: 2,
              width: active ? 28 : 0,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: AppColors.coffeeBrown,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              icon,
              size: 22,
              color: active ? AppColors.coffeeBrown : Colors.white,
            ),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 10,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.coffeeBrown : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
