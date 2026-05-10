import 'package:flutter/material.dart';

class FeaturesSection extends StatefulWidget {
  const FeaturesSection({super.key});

  @override
  State<FeaturesSection> createState() => _FeaturesSectionState();
}

class _FeaturesSectionState extends State<FeaturesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  static const parchment = Color(0xFFE8F9FD);
  static const creamWhite = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const coffeeBrown = Color(0xFFFF1E00);
  static const softGold = Color(0xFF59CE8F);
  static const mutedForeground = Color(0xFF4B5563);

  final List<_FeatureData> features = const [
    _FeatureData(
      title: "Seamless Ordering",
      description:
          "Order ahead for pickup or delivery with our intuitive app interface.",
      icon: Icons.smartphone,
    ),
    _FeatureData(
      title: "Smart POS System",
      description:
          "Fast, reliable point-of-sale for a smooth dine-in experience.",
      icon: Icons.credit_card,
    ),
    _FeatureData(
      title: "Artisanal Coffee",
      description:
          "Sourced directly, roasted locally, and brewed with precision.",
      icon: Icons.local_cafe,
    ),
    _FeatureData(
      title: "Local Favorites",
      description:
          "From our signature breakfast plates to our house-special Halo-Halo.",
      icon: Icons.restaurant,
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    controller.dispose();
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
      color: parchment,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : 24,
        vertical: isNarrow ? 56 : 88,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columnsForWidth(constraints.maxWidth);

              return Column(
                children: [
                  FadeTransition(
                    opacity: controller,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.08),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: controller,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "More than just a cafe",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              letterSpacing: 4.2,
                              color: coffeeBrown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Modern Convenience meets Cozy Comfort",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Righteous",
                              fontSize: isNarrow ? 32 : 40,
                              color: darkEspresso,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: isNarrow ? 28 : 56),

                  Wrap(
                    spacing: isNarrow ? 18 : 32,
                    runSpacing: isNarrow ? 18 : 32,
                    children: List.generate(features.length, (index) {
                      final itemWidth =
                          (constraints.maxWidth -
                                  ((columns - 1) * (isNarrow ? 18 : 32))) /
                              columns;

                      return SizedBox(
                        width: itemWidth,
                        child: _AnimatedFeatureCard(
                          delay: index * 100,
                          data: features[index],
                        ),
                      );
                    }),
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

class _AnimatedFeatureCard extends StatefulWidget {
  final int delay;
  final _FeatureData data;

  const _AnimatedFeatureCard({
    required this.delay,
    required this.data,
  });

  @override
  State<_AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<_AnimatedFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool hovered = false;

  static const creamWhite = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const softGold = Color(0xFF59CE8F);
  static const mutedForeground = Color(0xFF4B5563);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
      child: AnimatedScale(
        scale: hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: FadeTransition(
          opacity: controller,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: controller,
                curve: Curves.easeOut,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(isNarrow ? 20 : 28),
              decoration: BoxDecoration(
                color: creamWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: softGold.withOpacity(0.35),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 18,
                    spreadRadius: -8,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(isNarrow ? 10 : 12),
                    decoration: const BoxDecoration(
                      color: darkEspresso,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.data.icon,
                      size: 24,
                      color: softGold,
                    ),
                  ),
                  SizedBox(height: isNarrow ? 14 : 16),
                  Text(
                    widget.data.title,
                    style: TextStyle(
                      fontFamily: "Righteous",
                      fontSize: isNarrow ? 19 : 20,
                      color: darkEspresso,
                    ),
                  ),
                  SizedBox(height: isNarrow ? 10 : 16),
                  Text(
                    widget.data.description,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: isNarrow ? 13 : 14,
                      height: 1.55,
                      color: mutedForeground,
                    ),
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

class _FeatureData {
  final String title;
  final String description;
  final IconData icon;

  const _FeatureData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
