import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class HeroSection extends StatefulWidget {
  final VoidCallback? onExploreMenu;

  const HeroSection({super.key, this.onExploreMenu});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController fadeController;
  late AnimationController floatController;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    fadeController.dispose();
    floatController.dispose();
    super.dispose();
  }

  final List<_CategoryChipData> chips = const [
    _CategoryChipData("Dishes", Icons.restaurant, 0),
    _CategoryChipData("Dessert", Icons.icecream, 0.2),
    _CategoryChipData("Drinks", Icons.local_cafe, 0.4),
    _CategoryChipData("Platter", Icons.soup_kitchen, 0.6),
    _CategoryChipData("Snacks", Icons.local_pizza, 0.8),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 900;

    return Container(
      color: AppColors.warmBeige,
      constraints: BoxConstraints(minHeight: isDesktop ? 720 : 640),
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16,
        isDesktop ? 0 : 24,
        isDesktop ? 24 : 16,
        isDesktop ? 80 : 56,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -240,
            top: 0,
            child: Container(
              height: 640,
              width: 640,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.parchment.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.parchment.withOpacity(0.9),
                    blurRadius: 90,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1152),
              child: isDesktop
                  ? Row(
                      children: [
                        Expanded(flex: 6, child: _leftContent(context)),
                        const SizedBox(width: 48),
                        Expanded(flex: 4, child: _rightContent(isDesktop)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _leftContent(context),
                        const SizedBox(height: 48),
                        _rightContent(isDesktop),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leftContent(BuildContext context) {
    return FadeTransition(
      opacity: fadeController,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(-0.08, 0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Quezel's Cafe Hub", style: AppTextStyles.sectionLabel),
            const SizedBox(height: 16),
            Text(
              "BITE with SMILE & DRINK with Freshness",
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: MediaQuery.of(context).size.width >= 768 ? 72 : 42,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 576),
              child: Text(
                "Order your favorite artisanal coffee, breakfast, and halo-halo effortlessly. Experience our cozy lounge or grab flavor on the go with our smart ordering system.",
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: MediaQuery.of(context).size.width >= 768 ? 18 : 15,
                  color: AppColors.darkEspresso.withOpacity(0.82),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _HeroButton(
                  text: "Order Now",
                  backgroundColor: AppColors.darkEspresso,
                  textColor: AppColors.creamWhite,
                  borderColor: AppColors.darkEspresso,
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.signIn);
                  },
                ),
                _HeroButton(
                  text: "Explore Menu",
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.darkEspresso,
                  borderColor: AppColors.coffeeBrown,
                  onTap: widget.onExploreMenu ?? () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rightContent(bool isDesktop) {
    return FadeTransition(
      opacity: fadeController,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1).animate(
          CurvedAnimation(parent: fadeController, curve: Curves.easeOut),
        ),
        child: Column(
          children: [
            SizedBox(
              height: isDesktop ? 520 : 300,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -40,
                    top: -40,
                    child: Container(
                      height: 224,
                      width: 224,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softGold.withOpacity(0.2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.softGold.withOpacity(0.25),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimatedBuilder(
                    animation: floatController,
                    builder: (context, child) {
                      final y =
                          math.sin(floatController.value * 2 * math.pi) * -10;
                      return Transform.translate(
                        offset: Offset(0, y),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      "assets/images/logo1.png",
                      width: isDesktop ? 480 : 260,
                      height: isDesktop ? 480 : 260,
                      fit: BoxFit.contain,
                    ),
                  ),

                  if (isDesktop)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: SizedBox(
                        width: 180,
                        height: 340,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _FloatingChip(data: chips[0], right: -8, top: 16),
                            _FloatingChip(data: chips[1], right: -24, top: 64),
                            _FloatingChip(data: chips[2], right: -32, top: 112),
                            _FloatingChip(data: chips[3], right: -40, top: 160),
                            _FloatingChip(data: chips[4], right: -32, top: 208),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (!isDesktop)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: chips.map((chip) {
                  return _StaticChip(data: chip);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _HeroButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        child: AnimatedSlide(
          offset: hovered ? const Offset(0, -0.05) : Offset.zero,
          duration: const Duration(milliseconds: 180),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: widget.borderColor),
                boxShadow: AppShadows.diffuse,
              ),
              child: Text(
                widget.text,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: widget.textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingChip extends StatefulWidget {
  final _CategoryChipData data;
  final double right;
  final double top;

  const _FloatingChip({
    required this.data,
    required this.right,
    required this.top,
  });

  @override
  State<_FloatingChip> createState() => _FloatingChipState();
}

class _FloatingChipState extends State<_FloatingChip>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    Future.delayed(
      Duration(milliseconds: (widget.data.delay * 1000).toInt()),
      () {
        if (mounted) controller.repeat();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: widget.right,
      top: widget.top,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final y = math.sin(controller.value * 2 * math.pi) * -6;
          return Transform.translate(offset: Offset(0, y), child: child);
        },
        child: _StaticChip(data: widget.data),
      ),
    );
  }
}

class _StaticChip extends StatelessWidget {
  final _CategoryChipData data;

  const _StaticChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.softGold.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              color: AppColors.parchment,
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 15, color: AppColors.coffeeBrown),
          ),
          const SizedBox(width: 8),
          Text(
            data.label,
            style: AppTextStyles.buttonLabel.copyWith(
              fontSize: 12,
              color: AppColors.darkEspresso,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChipData {
  final String label;
  final IconData icon;
  final double delay;

  const _CategoryChipData(this.label, this.icon, this.delay);
}
