import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    return FadeTransition(
      opacity: controller,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeOut),
        ),
        child: Container(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
  decoration: BoxDecoration(
    color: AppColors.warmBeige,
    border: Border(
      top: BorderSide(
        color: AppColors.softGold.withOpacity(0.4),
        width: 0.5,
      ),
    ),
  ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSpacing.maxWidth,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = _columnsForWidth(constraints.maxWidth);
                  final itemWidth =
                      (constraints.maxWidth - ((columns - 1) * 40)) / columns;

                  return Column(
                    children: [
                      Wrap(
                        spacing: 40,
                        runSpacing: 40,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            child: const _FooterBrand(),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: const _FooterLinks(
                              title: "Explore",
                              items: [
                                "Menu",
                                "How it Works",
                                "About",
                                "Order Now",
                              ],
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: const _FooterLinks(
                              title: "Contact",
                              items: [
                                "Cagayan de Oro, Philippines",
                                "+63 912 345 6789",
                                "quezelscafe@gmail.com",
                              ],
                            ),
                          ),
                          SizedBox(
                            width: itemWidth,
                            child: const _FooterLinks(
                              title: "Opening Hours",
                              items: [
                                "Mon - Fri: 8:00 AM – 10:00 PM",
                                "Sat - Sun: 9:00 AM – 11:00 PM",
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      Container(
                        padding: const EdgeInsets.only(top: 24),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.darkEspresso.withOpacity(0.12),
                              width: 1,
                            ),
                          ),
                        ),
                        child: const _FooterBottom(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              "assets/images/logo3.png",
              height: 48,
              width: 48,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            const Text(
              "Quezel",
              style: TextStyle(
                fontFamily: AppFonts.righteous,
                fontSize: 20,
                color: AppColors.darkEspresso,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "A cozy café experience blending artisanal coffee, local flavors, and a modern ordering system.",
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            height: 1.7,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterLinks({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.darkEspresso,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _FooterTextItem(text: item),
          ),
        ),
      ],
    );
  }
}

class _FooterTextItem extends StatefulWidget {
  final String text;

  const _FooterTextItem({required this.text});

  @override
  State<_FooterTextItem> createState() => _FooterTextItemState();
}

class _FooterTextItemState extends State<_FooterTextItem> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 14,
          height: 1.5,
          color: hovered
              ? AppColors.darkEspresso
              : AppColors.mutedForeground,
        ),
      ),
    );
  }
}

class _FooterBottom extends StatelessWidget {
  const _FooterBottom();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    final content = [
      const _SocialIcons(),
      const Text(
        "© 2026 Quezel. All rights reserved.",
        style: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 12,
          color: AppColors.mutedForeground,
        ),
      ),
    ];

    return isDesktop
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: content,
          )
        : Column(
            children: [
              content[0],
              const SizedBox(height: 16),
              content[1],
            ],
          );
  }
}

class _SocialIcons extends StatelessWidget {
  const _SocialIcons();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialIcon(icon: Icons.camera_alt_outlined),
        SizedBox(width: 20),
        _SocialIcon(icon: Icons.facebook),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;

  const _SocialIcon({required this.icon});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedScale(
        scale: hovered ? 1.1 : 1,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          widget.icon,
          size: 18,
          color: hovered
              ? AppColors.darkEspresso
              : AppColors.mutedForeground,
        ),
      ),
    );
  }
}