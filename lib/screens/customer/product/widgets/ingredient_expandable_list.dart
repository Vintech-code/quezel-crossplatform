import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/product.dart';

class IngredientExpandableList extends StatefulWidget {
  final List<IngredientItem> ingredients;

  const IngredientExpandableList({super.key, required this.ingredients});

  @override
  State<IngredientExpandableList> createState() =>
      _IngredientExpandableListState();
}

class _IngredientExpandableListState extends State<IngredientExpandableList> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final visibleIngredients = showAll
        ? widget.ingredients
        : widget.ingredients.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ingredients",
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.darkEspresso,
          ),
        ),
        const SizedBox(height: 12),
        Column(children: visibleIngredients.map(_ingredientRow).toList()),
        if (widget.ingredients.length > 3)
          GestureDetector(
            onTap: () => setState(() => showAll = !showAll),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                showAll ? "Show less" : "Show more",
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffeeBrown,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _ingredientRow(IngredientItem ingredient) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            height: 7,
            width: 7,
            decoration: const BoxDecoration(
              color: AppColors.coffeeBrown,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ingredient.name,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
