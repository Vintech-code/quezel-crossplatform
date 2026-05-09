import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<_StepData> steps = const [
    _StepData(
      step: "01",
      title: "Browse",
      detail:
          "Explore our digital menu from your phone or the counter kiosk.",
    ),
    _StepData(
      step: "02",
      title: "Order & Pay",
      detail:
          "Select your items, customize to your liking, and pay seamlessly.",
    ),
    _StepData(
      step: "03",
      title: "Track",
      detail:
          "Get real-time updates on your order status while you wait.",
    ),
    _StepData(
      step: "04",
      title: "Enjoy",
      detail:
          "Pick up at the counter or have it served straight to your table.",
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
      color: AppColors.warmBeige,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageX,
        vertical: 128,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxWidth,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
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
                      child: Column(
                        children: [
                          const Text(
                            "Simple & Fast",
                            style: AppTextStyles.sectionLabel,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "How Quezel's Works",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFonts.righteous,
                              fontSize: 40,
                              color: AppColors.darkEspresso,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  Stack(
                    children: [
                      if (columns == 4)
                        Positioned(
                          top: 28,
                          left: constraints.maxWidth * 0.12,
                          right: constraints.maxWidth * 0.12,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.softGold.withOpacity(0.30),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: List.generate(steps.length, (index) {
                          final width =
                              (constraints.maxWidth -
                                      ((columns - 1) * 24)) /
                                  columns;

                          return SizedBox(
                            width: width,
                            child: _AnimatedStepCard(
                              delay: index * 150,
                              data: steps[index],
                            ),
                          );
                        }),
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

class _AnimatedStepCard extends StatefulWidget {
  final int delay;
  final _StepData data;

  const _AnimatedStepCard({
    required this.delay,
    required this.data,
  });

  @override
  State<_AnimatedStepCard> createState() => _AnimatedStepCardState();
}

class _AnimatedStepCardState extends State<_AnimatedStepCard>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool hovered = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    Future.delayed(
      Duration(milliseconds: widget.delay),
      () {
        if (mounted) controller.forward();
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
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(
          0,
          hovered ? -5 : 0,
          0,
        ),
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
                color: AppColors.creamWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.softGold.withOpacity(0.25),
                  width: 1,
                ),
                boxShadow: AppShadows.diffuse,
              ),
              child: Column(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: AppColors.parchment,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.softGold,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.data.step,
                        style: const TextStyle(
                          fontFamily: AppFonts.righteous,
                          fontSize: 20,
                          color: AppColors.darkEspresso,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    widget.data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.righteous,
                      fontSize: 28,
                      color: AppColors.darkEspresso,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    widget.data.detail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14,
                      height: 1.7,
                      color: AppColors.mutedForeground,
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

class _StepData {
  final String step;
  final String title;
  final String detail;

  const _StepData({
    required this.step,
    required this.title,
    required this.detail,
  });
}