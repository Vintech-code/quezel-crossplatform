import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/adaptive_image.dart';

class ProductImageCard extends StatelessWidget {
  final String image;

  const ProductImageCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 305,
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: AdaptiveImage(path: image, fit: BoxFit.contain),
    );
  }
}
