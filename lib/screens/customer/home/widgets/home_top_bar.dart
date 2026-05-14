import 'package:flutter/material.dart';

import '../../../../core/services/order_service.dart';
import '../../../../core/services/user_address_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/theme/app_theme.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onOrdersTap;

  const HomeTopBar({
    super.key,
    required this.onProfileTap,
    required this.onOrdersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedBuilder(
          animation: UserProfileService.instance,
          builder: (context, _) {
            return GestureDetector(
              onTap: onProfileTap,
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
                    style: AppTextStyles.navItem.copyWith(
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
                      style: AppTextStyles.navItem.copyWith(
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
              onTap: onOrdersTap,
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
                      Icons.delivery_dining_outlined,
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
                          style: AppTextStyles.navLabel.copyWith(
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
}
