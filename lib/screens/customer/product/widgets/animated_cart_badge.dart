import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class AnimatedCartBadge extends StatelessWidget {
  final int count;
  final Animation<double> scaleAnimation;
  final VoidCallback onTap;

  const AnimatedCartBadge({
    super.key,
    required this.count,
    required this.scaleAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          width: 56,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.darkEspresso,
                  ),
                ),
              ),
              if (count > 0)
                Positioned(
                  right: -2,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.coffeeBrown,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: AppColors.warmBeige,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      count > 99 ? "99+" : count.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}