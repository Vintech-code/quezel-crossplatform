import 'package:flutter/material.dart';
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
      price: "₱78.00",
      imagePath: "assets/images/1.png",
    ),
    _MenuItemData(
      name: "Halo-Halo Medium",
      category: "Dessert",
      detail: "Ube halaya, sweet beans, leche flan, shaved ice",
      price: "₱55.00",
      imagePath: "assets/images/2.png",
    ),
    _MenuItemData(
      name: "Crema De Leche",
      category: "Dessert",
      detail: "Creamy milk base with leche flan and toppings",
      price: "₱78.00",
      imagePath: "assets/images/3.png",
    ),
    _MenuItemData(
      name: "Mais Con Yelo",
      category: "Dessert",
      detail: "Sweet corn, shaved ice, creamy milk, and toppings",
      price: "₱65.00",
      imagePath: "assets/images/4.png",
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

  void scrollMenu(double offset) {
    scrollController.animateTo(
      (scrollController.offset + offset).clamp(
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  int _columnsForWidth(double width) {
    if (width >= 1024) return 4;
    if (width >= 768) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.warmBeige,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageX,
        vertical: 128,
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
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: controller,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: _MenuHeader(
                        showDesktopArrows: isDesktopGrid,
                        onLeft: () => scrollMenu(-300),
                        onRight: () => scrollMenu(300),
                      ),
                    ),
                  ),

                  SizedBox(height: isDesktopGrid ? 64 : 32),

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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 470,
                          child: ListView.separated(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: items.length,
                            padding: const EdgeInsets.only(bottom: 24),
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 24),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: constraints.maxWidth * 0.80,
                                child: _AnimatedMenuCard(
                                  data: items[index],
                                  delay: index * 100,
                                ),
                              );
                            },
                          ),
                        ),

                        Positioned(
                          left: 0,
                          child: _ArrowButton(
                            icon: Icons.chevron_left,
                            filled: false,
                            onTap: () => scrollMenu(-300),
                          ),
                        ),

                        Positioned(
                          right: 0,
                          child: _ArrowButton(
                            icon: Icons.chevron_right,
                            filled: true,
                            onTap: () => scrollMenu(300),
                          ),
                        ),
                      ],
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
  final bool showDesktopArrows;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const _MenuHeader({
    required this.showDesktopArrows,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _HeaderText(),
              Row(
                children: [
                  const _SeeFullMenuButton(),
                  if (showDesktopArrows) ...[
                    const SizedBox(width: 16),
                    _SmallArrowButton(
                      icon: Icons.chevron_left,
                      filled: false,
                      onTap: onLeft,
                    ),
                    const SizedBox(width: 8),
                    _SmallArrowButton(
                      icon: Icons.chevron_right,
                      filled: true,
                      onTap: onRight,
                    ),
                  ],
                ],
              ),
            ],
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "A taste of local",
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            letterSpacing: 4.2,
            fontWeight: FontWeight.w500,
            color: AppColors.coffeeBrown,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Curated Menu Highlights",
          style: TextStyle(
            fontFamily: AppFonts.righteous,
            fontSize: 40,
            color: AppColors.darkEspresso,
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
            border: Border.all(
              color: AppColors.coffeeBrown,
              width: 2,
            ),
          ),
          child: const Text(
            "See Full Menu",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedMenuCard extends StatefulWidget {
  final _MenuItemData data;
  final int delay;

  const _AnimatedMenuCard({
    required this.data,
    required this.delay,
  });

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
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, hovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.softGold.withOpacity(0.25),
          ),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: -15,
                    offset: const Offset(0, 20),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: FadeTransition(
          opacity: controller,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOut),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _MenuImage(imagePath: widget.data.imagePath),
                  const SizedBox(height: 24),

                  Text(
                    widget.data.category.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 12,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.softGold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.data.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.righteous,
                      fontSize: 18,
                      color: AppColors.darkEspresso,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Star(),
                      _Star(),
                      _Star(),
                      _Star(),
                      _Star(),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.data.detail,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.mutedForeground,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    widget.data.price,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkEspresso,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _AddToCartButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/auth/sign-in");
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
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _CircleBorder(size: 144, opacity: 0.40),
          _CircleBorder(size: 176, opacity: 0.20),
          _CircleBorder(size: 208, opacity: 0.10),
          Container(
            height: 128,
            width: 128,
            decoration: BoxDecoration(
              color: AppColors.parchment,
              shape: BoxShape.circle,
              boxShadow: AppShadows.diffuse,
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBorder extends StatelessWidget {
  final double size;
  final double opacity;

  const _CircleBorder({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.softGold.withOpacity(opacity),
        ),
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
      child: Icon(
        Icons.star,
        size: 14,
        color: AppColors.softGold,
      ),
    );
  }
}

class _AddToCartButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddToCartButton({
    required this.onTap,
  });

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: hovered ? AppColors.coffeeBrown : AppColors.parchment,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.coffeeBrown),
        ),
        child: Text(
          "Add to Cart",
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color:
                hovered ? AppColors.creamWhite : AppColors.darkEspresso,
          ),
        ),
      ),
    );
  }
}

class _SmallArrowButton extends StatefulWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _SmallArrowButton({
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  State<_SmallArrowButton> createState() => _SmallArrowButtonState();
}

class _SmallArrowButtonState extends State<_SmallArrowButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.05 : 1,
        duration: const Duration(milliseconds: 160),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.filled
                  ? AppColors.coffeeBrown
                  : AppColors.creamWhite,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.coffeeBrown),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: widget.filled
                  ? AppColors.creamWhite
                  : AppColors.darkEspresso,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _ArrowButton({
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SmallArrowButton(
      icon: icon,
      filled: filled,
      onTap: onTap,
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