import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class ProductPriceSection extends StatelessWidget {
  final String price;
  final bool hasAddOns;
  final int selectedAddOnsCount;
  final VoidCallback onAddOnsTap;

  const ProductPriceSection({
    super.key,
    required this.price,
    required this.hasAddOns,
    required this.selectedAddOnsCount,
    required this.onAddOnsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            price,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: AppColors.coffeeBrown,
            ),
          ),
        ),
        if (hasAddOns)
          GestureDetector(
            onTap: onAddOnsTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selectedAddOnsCount == 0
                    ? AppColors.darkEspresso
                    : AppColors.softGold,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: selectedAddOnsCount == 0
                        ? Colors.white
                        : AppColors.darkEspresso,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selectedAddOnsCount == 0
                        ? "Add Ons"
                        : "$selectedAddOnsCount Added",
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: selectedAddOnsCount == 0
                          ? Colors.white
                          : AppColors.darkEspresso,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}