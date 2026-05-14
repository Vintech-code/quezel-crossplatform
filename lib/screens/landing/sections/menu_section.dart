import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final ScrollController scrollController = ScrollController();

  final List<_MenuItemData> items = const [
    _MenuItemData(
      name: "Halo-Halo Large",
      category: "Dessert",
      detail: "Ube halaya, sweet beans, leche flan, shaved ice",
      price: "PHP 78.00",
      imagePath: "assets/images/1.png",
    ),
    _MenuItemData(
      name: "Halo-Halo Medium",
      category: "Dessert",
      detail: "Ube halaya, sweet beans, leche flan, shaved ice",
      price: "PHP 55.00",
      imagePath: "assets/images/2.png",
    ),
    _MenuItemData(
      name: "Crema De Leche",
      category: "Dessert",
      detail: "Creamy milk base with leche flan and toppings",
      price: "PHP 78.00",
      imagePath: "assets/images/3.png",
    ),
    _MenuItemData(
      name: "Mais Con Yelo",
      category: "Dessert",
      detail: "Sweet corn, shaved ice, creamy milk, and toppings",
      price: "PHP 65.00",
      imagePath: "assets/images/4.png",
    ),
    _MenuItemData(
      name: "Regular Burger Combo",
      category: "Combo",
      detail: "Regular burger paired with a large drink",
      price: "PHP 76.00",
      imagePath: "assets/images/regular_burger_combo.png",
    ),
    _MenuItemData(
      name: "Regular Sulit Pairs",
      category: "Combo",
      detail: "Regular burger, fries, and regular drink",
      price: "PHP 99.00",
      imagePath: "assets/images/regular_sulit_pairs.png",
    ),
    _MenuItemData(
      name: "Regular Supreme Combo",
      category: "Combo",
      detail: "Regular burger, halo-halo, fries, and drink",
      price: "PHP 152.00",
      imagePath: "assets/images/regular_supreme_combo.png",
    ),
    _MenuItemData(
      name: "Cheese Burger Combo",
      category: "Combo",
      detail: "Cheese burger, fries, and regular drink",
      price: "PHP 109.00",
      imagePath: "assets/images/cheese_burger_combo.png",
    ),
    _MenuItemData(
      name: "Cheese Sulit Pairs",
      category: "Combo",
      detail: "Cheese burger, fries, and regular drink",
      price: "PHP 109.00",
      imagePath: "assets/images/cheese_sulit_pairs.png",
    ),
    _MenuItemData(
      name: "Cheese Supreme Combo",
      category: "Combo",
      detail: "Cheese burger, halo-halo, fries, and drink",
      price: "PHP 152.00",
      imagePath: "assets/images/cheese_supreme_combo.png",
    ),
    _MenuItemData(
      name: "Iced Tea Large",
      category: "Drinks",
      detail: "Large iced tea refreshment",
      price: "PHP 20.00",
      imagePath: "assets/images/icedtea_large.png",
    ),
    _MenuItemData(
      name: "Iced Tea Regular",
      category: "Drinks",
      detail: "Classic iced tea",
      price: "PHP 35.00",
      imagePath: "assets/images/icedtea_regular.png",
    ),
    _MenuItemData(
      name: "Lemon Juice Large",
      category: "Drinks",
      detail: "Large lemon juice refreshment",
      price: "PHP 45.00",
      imagePath: "assets/images/lemonjuice_large.png",
    ),
    _MenuItemData(
      name: "Lemon Juice Regular",
      category: "Drinks",
      detail: "Fresh lemon juice",
      price: "PHP 35.00",
      imagePath: "assets/images/lemonjuice_regular.png",
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  int _columnsForWidth(double width) {
    if (width >= 1024) return 4;
    if (width >= 768) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 768;

    return Container(
      color: AppColors.warmBeige,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : AppSpacing.pageX,
        vertical: isNarrow ? 56 : 112,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktopGrid = constraints.maxWidth >= 768;
              final columns = _columnsForWidth(constraints.maxWidth);

              return Column(
                children: [
                  FadeTransition(
                    opacity: controller,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: controller,
                              curve: Curves.easeOut,
                            ),
                          ),
                      child: const _MenuHeader(),
                    ),
                  ),

                  SizedBox(height: isDesktopGrid ? 64 : 28),

                  if (isDesktopGrid)
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: List.generate(items.length, (index) {
                        final itemWidth =
                            (constraints.maxWidth - ((columns - 1) * 24)) /
                            columns;

                        return SizedBox(
                          width: itemWidth,
                          child: _AnimatedMenuCard(
                            data: items[index],
                            delay: index * 100,
                          ),
                        );
                      }),
                    )
                  else
                    SizedBox(
                      height: 370,
                      child: ListView.separated(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: items.length,
                        padding: const EdgeInsets.only(bottom: 12),
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: constraints.maxWidth * 0.78,
                            child: _AnimatedMenuCard(
                              data: items[index],
                              delay: index * 100,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const _HeaderText(), const _SeeFullMenuButton()],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _HeaderText(),
              SizedBox(height: 24),
              _SeeFullMenuButton(),
            ],
          );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText();

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("A taste of local", style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Text(
          "Curated Menu Highlights",
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: isNarrow ? 32 : 40,
          ),
        ),
      ],
    );
  }
}

class _SeeFullMenuButton extends StatefulWidget {
  const _SeeFullMenuButton();

  @override
  State<_SeeFullMenuButton> createState() => _SeeFullMenuButtonState();
}

class _SeeFullMenuButtonState extends State<_SeeFullMenuButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.05 : 1,
        duration: const Duration(milliseconds: 160),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: hovered ? AppColors.parchment : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: AppColors.coffeeBrown, width: 2),
          ),
          child: const Text("See Full Menu", style: AppTextStyles.buttonLabel),
        ),
      ),
    );
  }
}

class _AnimatedMenuCard extends StatefulWidget {
  final _MenuItemData data;
  final int delay;

  const _AnimatedMenuCard({required this.data, required this.delay});

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool hovered = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 768;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, hovered ? -5 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.softGold.withOpacity(0.25)),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 22,
                    spreadRadius: -10,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: FadeTransition(
          opacity: controller,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: controller, curve: Curves.easeOut),
                ),
            child: Padding(
              padding: EdgeInsets.all(isNarrow ? 16 : 24),
              child: Column(
                children: [
                  _MenuImage(imagePath: widget.data.imagePath),
                  SizedBox(height: isNarrow ? 14 : 24),

                  Text(
                    widget.data.category.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.navItem.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.softGold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.data.name,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                  ),

                  const SizedBox(height: 6),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_Star(), _Star(), _Star(), _Star(), _Star()],
                  ),

                  SizedBox(height: isNarrow ? 8 : 12),

                  Text(
                    widget.data.detail,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.paragraph.copyWith(
                      fontSize: isNarrow ? 12 : 14,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: isNarrow ? 12 : 24),

                  Text(
                    widget.data.price,
                    style: AppTextStyles.buttonLabel.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _AddToCartButton(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.signIn);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuImage extends StatelessWidget {
  final String imagePath;

  const _MenuImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 768;
    final imageHeight = isNarrow ? 116.0 : 180.0;
    final imageSize = isNarrow ? 86.0 : 128.0;

    return SizedBox(
      height: imageHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _CircleBorder(size: isNarrow ? 100 : 144, opacity: 0.32),
          _CircleBorder(size: isNarrow ? 124 : 176, opacity: 0.16),
          Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(
              color: AppColors.parchment,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}

class _CircleBorder extends StatelessWidget {
  final double size;
  final double opacity;

  const _CircleBorder({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.softGold.withOpacity(opacity)),
      ),
    );
  }
}

class _Star extends StatelessWidget {
  const _Star();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Icon(Icons.star, size: 14, color: AppColors.softGold),
    );
  }
}

class _AddToCartButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddToCartButton({required this.onTap});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: hovered ? AppColors.coffeeBrown : AppColors.parchment,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.coffeeBrown),
        ),
        child: Text(
          "Add to Cart",
          style: AppTextStyles.buttonLabel.copyWith(
            fontSize: 12,
            letterSpacing: 0.6,
            color: hovered ? AppColors.creamWhite : AppColors.darkEspresso,
          ),
        ),
      ),
    );
  }
}

class _MenuItemData {
  final String name;
  final String category;
  final String detail;
  final String price;
  final String imagePath;

  const _MenuItemData({
    required this.name,
    required this.category,
    required this.detail,
    required this.price,
    required this.imagePath,
  });
}
