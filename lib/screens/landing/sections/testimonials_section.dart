import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() =>
      _TestimonialsSectionState();
}

class _TestimonialsSectionState
    extends State<TestimonialsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final List<_TestimonialData> testimonials = const [
    _TestimonialData(
      quote:
          "A quiet sanctuary with the most thoughtful espresso service in town.",
      name: "Mira L.",
      title: "Designer",
    ),
    _TestimonialData(
      quote:
          "The tasting flight feels like a tiny coffee ceremony. I come weekly.",
      name: "Jonas P.",
      title: "Creative director",
    ),
    _TestimonialData(
      quote:
          "Warm, slow, intentional. The playlist alone is worth a visit.",
      name: "Nina S.",
      title: "Writer",
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
    super.dispose();
  }

  int _columnsForWidth(double width) {
    if (width >= 768) return 3;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 768;

    return Container(
      color: AppColors.warmBeige,
      padding: EdgeInsets.symmetric(
        horizontal: isNarrow ? 16 : AppSpacing.pageX,
        vertical: isNarrow ? 56 : 88,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxWidth,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columnsForWidth(
                constraints.maxWidth,
              );

              return Column(
                children: [
                  FadeTransition(
                    opacity: controller,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.04),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: controller,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: _SectionHeader(
                        isDesktop: constraints.maxWidth >= 768,
                      ),
                    ),
                  ),

                  SizedBox(height: isNarrow ? 28 : 40),

                  Wrap(
                    spacing: isNarrow ? 18 : 24,
                    runSpacing: isNarrow ? 18 : 24,
                    children: List.generate(
                      testimonials.length,
                      (index) {
                        final width =
                            (constraints.maxWidth -
                                    ((columns - 1) * (isNarrow ? 18 : 24))) /
                                columns;

                        return SizedBox(
                          width: width,
                          child: _AnimatedTestimonialCard(
                            data: testimonials[index],
                            delay: index * 120,
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

class _SectionHeader extends StatelessWidget {
  final bool isDesktop;

  const _SectionHeader({
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: const [
          _HeaderText(),
          Text(
            "4.9 average rating",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      );
    }

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderText(),
        SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "4.9 average rating",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
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
        const Text(
          "Guest stories",
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            letterSpacing: 4.2,
            color: AppColors.coffeeBrown,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "What people are saying",
          style: TextStyle(
            fontFamily: AppFonts.righteous,
            fontSize: isNarrow ? 30 : 34,
            color: AppColors.darkEspresso,
          ),
        ),
      ],
    );
  }
}

class _AnimatedTestimonialCard extends StatefulWidget {
  final _TestimonialData data;
  final int delay;

  const _AnimatedTestimonialCard({
    required this.data,
    required this.delay,
  });

  @override
  State<_AnimatedTestimonialCard> createState() =>
      _AnimatedTestimonialCardState();
}

class _AnimatedTestimonialCardState
    extends State<_AnimatedTestimonialCard>
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
    final isNarrow = MediaQuery.of(context).size.width < 768;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(
          0,
          hovered ? -4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(
            AppRadius.lg,
          ),
          border: Border.all(
            color: AppColors.softGold.withOpacity(
              0.20,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              spreadRadius: -8,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: FadeTransition(
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
            child: Padding(
              padding: EdgeInsets.all(isNarrow ? 20 : 24),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "\"${widget.data.quote}\"",
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: isNarrow ? 16 : 18,
                      height: 1.55,
                      color:
                          AppColors.darkEspresso,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  SizedBox(height: isNarrow ? 18 : 24),

                  Text(
                    widget.data.name,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          AppColors.darkEspresso,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.data.title,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 12,
                      color:
                          AppColors.mutedForeground,
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

class _TestimonialData {
  final String quote;
  final String name;
  final String title;

  const _TestimonialData({
    required this.quote,
    required this.name,
    required this.title,
  });
}
