import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class HomeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const HomeSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.softGold.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: "Search here",
                border: InputBorder.none,
              ),
              style: AppTextStyles.navItem.copyWith(
                fontSize: 14,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
