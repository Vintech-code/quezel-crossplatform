import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomeEmptyState extends StatelessWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 52,
              color: AppColors.mutedForeground.withOpacity(0.8),
            ),
            const SizedBox(height: 12),
            Text(
              "No products found",
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 6),
            const Text(
              "Try another keyword or category.",
              style: AppTextStyles.paragraph,
            ),
          ],
        ),
      ),
    );
  }
}
