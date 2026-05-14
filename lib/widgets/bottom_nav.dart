import 'package:flutter/material.dart';

import '../core/services/cart_service.dart';
import '../core/theme/app_theme.dart';

enum CustomerNavItem { home, favorites, messages, cart, profile }

class CustomerBottomNav extends StatelessWidget {
  final CustomerNavItem activeItem;
  final VoidCallback? onHomeTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onMessagesTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const CustomerBottomNav({
    super.key,
    required this.activeItem,
    this.onHomeTap,
    this.onFavoritesTap,
    this.onMessagesTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        border: Border(
          top: BorderSide(color: AppColors.softGold.withOpacity(0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, -2),
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
              icon: Icons.chat_bubble_outline_rounded,
              label: "Messages",
              active: activeItem == CustomerNavItem.messages,
              onTap: activeItem == CustomerNavItem.messages
                  ? null
                  : onMessagesTap,
            ),
            AnimatedBuilder(
              animation: CartService.instance,
              builder: (context, _) {
                return _NavButton(
                  icon: Icons.shopping_cart_outlined,
                  label: "Cart",
                  active: activeItem == CustomerNavItem.cart,
                  badgeCount: CartService.instance.itemCount,
                  onTap: activeItem == CustomerNavItem.cart ? null : onCartTap,
                );
              },
            ),
            _NavButton(
              icon: Icons.person_outline_rounded,
              label: "Profile",
              active: activeItem == CustomerNavItem.profile,
              onTap: activeItem == CustomerNavItem.profile
                  ? null
                  : onProfileTap,
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
  final int badgeCount;
  final VoidCallback? onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = AppColors.softGold.withOpacity(0.65);

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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: active ? AppColors.coffeeBrown : inactiveColor,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -10,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.coffeeBrown,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.creamWhite,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        badgeCount > 99 ? "99+" : badgeCount.toString(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.navLabel.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.navLabel.copyWith(
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                color: active ? AppColors.coffeeBrown : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
