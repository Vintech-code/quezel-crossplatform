import 'package:flutter/material.dart';

import '../../../../core/services/favorite_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/product.dart';
import '../../../../models/product_availability.dart';

class HomeProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;
  final void Function(Product product) onProductTap;

  const HomeProductSection({
    super.key,
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
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
              ),
              const Spacer(),
              Text(
                "Swipe",
                style: AppTextStyles.navItem.copyWith(
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
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final product = products[index];

                return SizedBox(
                  width: 168,
                  child: _HomeProductCard(
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

class _HomeProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _HomeProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: product.canOrder ? 1 : 0.58,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.creamWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: product.availability.color.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (!product.canOrder)
                    Expanded(child: _AvailabilityBadge(product: product))
                  else
                    const Spacer(),
                  GestureDetector(
                    onTap: () {
                      FavoriteService.instance.toggleFavorite(product);
                    },
                    child: AnimatedBuilder(
                      animation: FavoriteService.instance,
                      builder: (context, _) {
                        final favorite = FavoriteService.instance.isFavorite(
                          product,
                        );

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
                ],
              ),
              Expanded(
                child: Center(
                  child: Image.asset(product.image, fit: BoxFit.contain),
                ),
              ),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
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
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                  ),
                  const Spacer(),
                  Text(
                    product.price,
                    style: AppTextStyles.navItem.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Stock: ${product.stock}",
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  final Product product;

  const _AvailabilityBadge({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: product.availability.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: product.availability.color.withValues(alpha: 0.55),
        ),
      ),
      child: Text(
        product.availability.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.navItem.copyWith(
          fontSize: 8,
          fontWeight: FontWeight.w800,
          color: product.availability.color,
        ),
      ),
    );
  }
}
