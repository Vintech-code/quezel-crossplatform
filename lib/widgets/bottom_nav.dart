import 'package:flutter/material.dart';

import '../core/services/cart_service.dart';
import '../core/theme/app_theme.dart';

enum CustomerNavItem { home, menu, orders, profile, favorites, messages, cart }

class CustomerBottomNav extends StatelessWidget {
  final CustomerNavItem activeItem;
  final VoidCallback? onHomeTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onOrdersTap;
  final VoidCallback? onFavoritesTap;
  final VoidCallback? onMessagesTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const CustomerBottomNav({
    super.key,
    required this.activeItem,
    this.onHomeTap,
    this.onMenuTap,
    this.onOrdersTap,
    this.onFavoritesTap,
    this.onMessagesTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final menuActive =
        activeItem == CustomerNavItem.menu ||
        activeItem == CustomerNavItem.favorites;
    final ordersActive =
        activeItem == CustomerNavItem.orders ||
        activeItem == CustomerNavItem.cart;

    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        border: Border(
          top: BorderSide(color: AppColors.softGold.withValues(alpha: 0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
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
              icon: Icons.restaurant_menu_rounded,
              label: "Menu",
              active: menuActive,
              onTap: menuActive ? null : onMenuTap ?? onFavoritesTap,
            ),
            AnimatedBuilder(
              animation: CartService.instance,
              builder: (context, _) {
                return _NavButton(
                  icon: Icons.receipt_long_rounded,
                  label: "Orders",
                  active: ordersActive,
                  badgeCount: CartService.instance.itemCount,
                  onTap: ordersActive ? null : onOrdersTap ?? onCartTap,
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
    final inactiveColor = AppColors.softGold.withValues(alpha: 0.65);

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
