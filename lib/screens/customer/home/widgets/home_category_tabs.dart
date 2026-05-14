import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomeCategoryTabs extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const HomeCategoryTabs({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final active = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: active ? AppColors.softGold : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.softGold),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : AppColors.darkEspresso,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
