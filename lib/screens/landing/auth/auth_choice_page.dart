import 'package:flutter/material.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class AuthChoicePage extends StatelessWidget {
  final String modeLabel;
  final String title;
  final String subtitle;
  final String alternateText;
  final String alternateActionText;
  final String alternateRoute;

  const AuthChoicePage({
    super.key,
    required this.modeLabel,
    required this.title,
    required this.subtitle,
    required this.alternateText,
    required this.alternateActionText,
    required this.alternateRoute,
  });

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.landing);
  }

  void _demoContinue(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShort = size.height < 720;
    final logoHeight = isShort ? 96.0 : 120.0;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 36,
                      right: -84,
                      child: _BackgroundRibbon(
                        width: 260,
                        height: 58,
                        turns: -0.08,
                      ),
                    ),
                    const Positioned(
                      left: -64,
                      top: 180,
                      child: _BackgroundRibbon(
                        width: 190,
                        height: 42,
                        turns: 0.08,
                      ),
                    ),

                    Positioned(
                      top: 95,
                      left: 28,
                      child: _FloatingCircle(
                        size: 46,
                        color: AppColors.softGold,
                        opacity: 0.18,
                      ),
                    ),
                    Positioned(
                      top: 245,
                      right: 32,
                      child: _FloatingCircle(
                        size: 74,
                        color: AppColors.coffeeBrown,
                        opacity: 0.08,
                      ),
                    ),
                    Positioned(
                      bottom: 180,
                      left: -28,
                      child: _FloatingCircle(
                        size: 110,
                        color: AppColors.softGold,
                        opacity: 0.13,
                      ),
                    ),
                    Positioned(
                      bottom: 90,
                      right: 24,
                      child: _FloatingCircle(
                        size: 64,
                        color: AppColors.coffeeBrown,
                        opacity: 0.08,
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      left: -70,
                      child: _FloatingCircle(
                        size: 220,
                        color: Colors.white,
                        opacity: 0.55,
                      ),
                    ),
                    Positioned(
                      bottom: -100,
                      right: -80,
                      child: _FloatingCircle(
                        size: 260,
                        color: AppColors.softGold,
                        opacity: 0.10,
                      ),
                    ),

                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  tooltip: "Back to home",
                                  onPressed: () => _goHome(context),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.darkEspresso,
                                    size: 24,
                                  ),
                                ),
                              ),
                              SizedBox(height: isShort ? 18 : 40),

                              Image.asset(
                                "assets/images/logo3.png",
                                height: logoHeight,
                                fit: BoxFit.contain,
                              ),

                              const SizedBox(height: 22),

                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.sectionTitle.copyWith(
                                  fontSize: 40,
                                  height: 1,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.paragraph.copyWith(
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                modeLabel,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.overline,
                              ),

                              SizedBox(height: isShort ? 34 : 62),

                              _AuthButton(
                                label: "Continue With Facebook",
                                icon: const Text(
                                  "f",
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1877F2),
                                  ),
                                ),
                                onTap: () => _demoContinue(context),
                              ),

                              const SizedBox(height: 12),

                              _AuthButton(
                                label: "Continue With Google",
                                icon: const Text(
                                  "G",
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF4285F4),
                                  ),
                                ),
                                onTap: () => _demoContinue(context),
                              ),

                              const SizedBox(height: 18),

                              const _DividerOr(),

                              const SizedBox(height: 18),

                              _AuthButton(
                                label: "Continue With Mobile Number",
                                icon: const Icon(
                                  Icons.phone_rounded,
                                  color: AppColors.darkEspresso,
                                  size: 22,
                                ),
                                onTap: () => _demoContinue(context),
                              ),

                              const SizedBox(height: 18),

                              Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                    alternateText,
                                    style: AppTextStyles.paragraph.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        alternateRoute,
                                      );
                                    },
                                    child: Text(
                                      alternateActionText,
                                      style: AppTextStyles.navItem.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.coffeeBrown,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.coffeeBrown,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _AuthButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.softGold.withOpacity(0.36)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(width: 34, child: Center(child: icon)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.buttonLabel.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkEspresso,
                    ),
                  ),
                ),
                const SizedBox(width: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerOr extends StatelessWidget {
  const _DividerOr();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.4,
            color: AppColors.softGold.withOpacity(0.48),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            "or",
            style: AppTextStyles.paragraph.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.4,
            color: AppColors.softGold.withOpacity(0.48),
          ),
        ),
      ],
    );
  }
}

class _BackgroundRibbon extends StatelessWidget {
  final double width;
  final double height;
  final double turns;

  const _BackgroundRibbon({
    required this.width,
    required this.height,
    required this.turns,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: turns * 6.283185307179586,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.coffeeBrown.withOpacity(0.06),
          border: Border.all(color: AppColors.coffeeBrown.withOpacity(0.08)),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}

class _FloatingCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _FloatingCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(opacity),
        ),
      ),
    );
  }
}
