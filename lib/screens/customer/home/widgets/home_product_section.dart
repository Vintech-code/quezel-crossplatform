import 'package:flutter/material.dart';

import '../../../../core/services/favorite_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/product.dart';
import '../../../../models/product_availability.dart';
import '../../../../widgets/adaptive_image.dart';

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
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    if (isWide) {
      return _WebHomeProductSection(
        title: title,
        products: products,
        onProductTap: onProductTap,
      );
    }

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

class _WebHomeProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;
  final void Function(Product product) onProductTap;

  const _WebHomeProductSection({
    required this.title,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1180 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 88),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 44,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$title Category",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 18,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 92),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1540),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 72),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisExtent: 360,
                crossAxisSpacing: 64,
                mainAxisSpacing: 76,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return _WebHomeProductCard(
                  product: product,
                  onTap: () => onProductTap(product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHomeProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _WebHomeProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final available = product.canOrder;

    return Opacity(
      opacity: available ? 1 : 0.58,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AdaptiveImage(
                      path: product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (product.savings != null)
                  Positioned(
                    right: 48,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.haloPurple,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        product.savings!,
                        style: AppTextStyles.navLabel.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            product.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.navItem.copyWith(
              fontSize: 24,
              height: 1.32,
              fontWeight: FontWeight.w900,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkEspresso,
                  side: const BorderSide(color: Color(0xFF9CA3AF)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  "View item",
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: available ? onTap : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.coffeeBrown,
                  disabledBackgroundColor: AppColors.mutedForeground,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 19,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  available ? "Order Now" : product.availability.label,
                  style: AppTextStyles.navItem.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
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
                  child: AdaptiveImage(
                    path: product.image,
                    fit: BoxFit.contain,
                  ),
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
