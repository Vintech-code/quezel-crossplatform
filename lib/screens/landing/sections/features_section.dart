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
    return Container(
      color: parchment,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 96),
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
                      child: const Column(
                        children: [
                          Text(
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
                          SizedBox(height: 16),
                          Text(
                            "Modern Convenience meets Cozy Comfort",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Righteous",
                              fontSize: 40,
                              color: darkEspresso,
                              height: 1.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 64),

                  Wrap(
                    spacing: 32,
                    runSpacing: 32,
                    children: List.generate(features.length, (index) {
                      final itemWidth =
                          (constraints.maxWidth - ((columns - 1) * 32)) /
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
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: creamWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: softGold.withOpacity(0.35),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 64,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
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
                  const SizedBox(height: 16),
                  Text(
                    widget.data.title,
                    style: const TextStyle(
                      fontFamily: "Righteous",
                      fontSize: 20,
                      color: darkEspresso,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.data.description,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      height: 1.7,
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