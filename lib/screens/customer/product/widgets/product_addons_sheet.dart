import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/product.dart';
import '../../../../widgets/adaptive_image.dart';
import '../controllers/product_customization_controller.dart';

class ProductAddOnsSheet extends StatelessWidget {
  final ProductCustomizationController controller;

  const ProductAddOnsSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.all(14),
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          decoration: BoxDecoration(
            color: AppColors.creamWhite,
            borderRadius: BorderRadius.circular(28),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 42,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.softGold.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AdaptiveImage(
                        path: controller.product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Customize your order",
                        style: TextStyle(
                          fontFamily: AppFonts.righteous,
                          fontSize: 24,
                          color: AppColors.darkEspresso,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Choose extra flavors, sauces, or toppings before adding to cart.",
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 18),
                ...controller.product.addOns.map((addOn) {
                  return _AddOnTile(
                    addOn: addOn,
                    selected: controller.isAddOnSelected(addOn),
                    onTap: () => controller.toggleAddOn(addOn),
                  );
                }),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total: ${controller.formattedTotalPrice}",
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.darkEspresso,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.softGold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddOnTile extends StatelessWidget {
  final ProductAddOn addOn;
  final bool selected;
  final VoidCallback onTap;

  const _AddOnTile({
    required this.addOn,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.softGold.withOpacity(0.18) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.softGold
                : AppColors.softGold.withOpacity(0.35),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.softGold : Colors.transparent,
                border: Border.all(color: AppColors.softGold),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                addOn.name,
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkEspresso,
                ),
              ),
            ),
            Text(
              "+${addOn.price}",
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.coffeeBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
