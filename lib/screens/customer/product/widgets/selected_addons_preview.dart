import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/product.dart';

class SelectedAddOnsPreview extends StatelessWidget {
  final List<ProductAddOn> selectedAddOns;

  const SelectedAddOnsPreview({
    super.key,
    required this.selectedAddOns,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedAddOns.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: selectedAddOns.map((addOn) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.softGold.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.55),
              ),
            ),
            child: Text(
              "${addOn.name} +${addOn.price}",
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.coffeeBrown,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}