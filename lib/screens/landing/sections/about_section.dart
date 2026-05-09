import 'dart:async';
import 'package:flutter/material.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  late AnimationController leftController;
  late AnimationController rightController;
  Timer? timer;

  int activeIndex = 0;

  static const creamWhite = Color(0xFFE8F9FD);
  static const parchment = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const coffeeBrown = Color(0xFFFF1E00);
  static const softGold = Color(0xFF59CE8F);
  static const mutedForeground = Color(0xFF4B5563);

  final List<_AboutImageData> aboutImages = const [
    _AboutImageData(path: "assets/images/pic1.jpg", alt: "Photo 1"),
    _AboutImageData(path: "assets/images/pic2.jpg", alt: "Photo 2"),
    _AboutImageData(path: "assets/images/pic3.jpg", alt: "Photo 3"),
    _AboutImageData(path: "assets/images/pic4.jpg", alt: "Photo 4"),
    _AboutImageData(path: "assets/images/pic5.jpg", alt: "Photo 5"),
    _AboutImageData(path: "assets/images/pic6.jpg", alt: "Photo 6"),
  ];

  @override
  void initState() {
    super.initState();

    leftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    rightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) rightController.forward();
    });

    timer = Timer.periodic(const Duration(milliseconds: 3600), (_) {
      if (!mounted) return;
      setState(() {
        activeIndex = (activeIndex + 1) % aboutImages.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    leftController.dispose();
    rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: creamWhite,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 128),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1152),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1024;

              return isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 10, child: _imageSection()),
                        const SizedBox(width: 64),
                        Expanded(flex: 12, child: _textSection()),
                      ],
                    )
                  : Column(
                      children: [
                        _imageSection(),
                        const SizedBox(height: 64),
                        _textSection(),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _imageSection() {
    return FadeTransition(
      opacity: leftController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.08, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: leftController, curve: Curves.easeOut),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -56,
              bottom: -56,
              child: Container(
                height: 192,
                width: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: softGold.withOpacity(0.20),
                  boxShadow: [
                    BoxShadow(
                      color: softGold.withOpacity(0.25),
                      blurRadius: 80,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            AspectRatio(
              aspectRatio: 4 / 5,
              child: Container(
                decoration: BoxDecoration(
                  color: parchment,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: softGold.withOpacity(0.25),
                    width: 1,
                  ),
                  boxShadow: [
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
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Stack(
                        children: List.generate(aboutImages.length, (index) {
                          final isActive = index == activeIndex;

                          return Positioned.fill(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOut,
                              opacity: isActive ? 1 : 0,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOut,
                                scale: isActive ? 1 : 1.05,
                                child: SizedBox.expand(
                                  child: Image.asset(
                                    aboutImages[index].path,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                darkEspresso.withOpacity(0.28),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 32,
                      right: 32,
                      bottom: 32,
                      child: Text(
                        "Since 2025",
                        style: TextStyle(
                          fontFamily: "Righteous",
                          fontSize: 40,
                          color: creamWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: -48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(aboutImages.length, (index) {
                  final isActive = index == activeIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                    child: AnimatedScale(
                      scale: isActive ? 1.10 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? softGold : Colors.transparent,
                          border: Border.all(color: softGold, width: 1),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textSection() {
    return FadeTransition(
      opacity: rightController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: rightController, curve: Curves.easeOut),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Our Story",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 4.2,
                color: coffeeBrown,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "More than a cafe.\nA community hub.",
              style: TextStyle(
                fontFamily: "Righteous",
                fontSize: 48,
                height: 1.1,
                color: darkEspresso,
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Quezel’s started with a simple idea inspired by the hot weather — to create refreshing treats that people could enjoy and cool down with. What began with halo-halo soon expanded into customer favorites like Mais Con Yelo and Crema de Leche.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                height: 1.7,
                color: mutedForeground,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "As Quezel’s grew, the founders realized people also loved affordable snacks and combo meals, leading to the addition of burgers, fries, and hotdog sandwiches to the menu.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                height: 1.7,
                color: mutedForeground,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "The name “Quezel’s” comes from the combination of the founders’ names, Jeque Jhon Roxas and Hazel Ann Cababaros — representing their passion, partnership, and shared dream of serving the community with food made from the heart.",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                height: 1.7,
                color: mutedForeground,
              ),
            ),
            SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: _StatBlock(value: "100%", label: "Local Beans"),
                ),
                SizedBox(width: 32),
                Expanded(
                  child: _StatBlock(value: "Fast", label: "Smart Ordering"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String value;
  final String label;

  const _StatBlock({
    required this.value,
    required this.label,
  });

  static const darkEspresso = Color(0xFF000000);
  static const softGold = Color(0xFF59CE8F);
  static const mutedForeground = Color(0xFF4B5563);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: softGold, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: "Righteous",
              fontSize: 30,
              color: darkEspresso,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.8,
              color: mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutImageData {
  final String path;
  final String alt;

  const _AboutImageData({
    required this.path,
    required this.alt,
  });
}