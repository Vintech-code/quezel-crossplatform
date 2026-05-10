import 'package:flutter/material.dart';

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

  static const warmBeige = Color(0xFFE8F9FD);
  static const coffeeBrown = Color(0xFFFF1E00);
  static const softGold = Color(0xFF59CE8F);
  static const darkText = Color(0xFF101010);
  static const mutedText = Color(0xFF4B5563);

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/");
  }

  void _demoContinue(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/user/onboarding");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShort = size.height < 720;
    final logoHeight = isShort ? 96.0 : 120.0;

    return Scaffold(
      backgroundColor: warmBeige,
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
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: softGold.withOpacity(0.12),
                          border: Border(
                            top: BorderSide(
                              color: softGold.withOpacity(0.28),
                              width: 1,
                            ),
                          ),
                        ),
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
                                    color: darkText,
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
                                style: const TextStyle(
                                  fontFamily: "Righteous",
                                  fontSize: 40,
                                  height: 1,
                                  color: darkText,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                  color: mutedText,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                modeLabel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.2,
                                  color: coffeeBrown,
                                ),
                              ),
                              SizedBox(height: isShort ? 34 : 62),
                              _AuthButton(
                                label: "Continue With Facebook",
                                icon: const Text(
                                  "f",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
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
                                    fontFamily: "Poppins",
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
                                  color: darkText,
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
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: mutedText,
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
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: coffeeBrown,
                                        decoration: TextDecoration.underline,
                                        decorationColor: coffeeBrown,
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
        shadowColor: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AuthChoicePage.softGold.withOpacity(0.36),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 34,
                  child: Center(child: icon),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AuthChoicePage.darkText,
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
            color: AuthChoicePage.softGold.withOpacity(0.48),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            "or",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AuthChoicePage.mutedText,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.4,
            color: AuthChoicePage.softGold.withOpacity(0.48),
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
          color: AuthChoicePage.coffeeBrown.withOpacity(0.06),
          border: Border.all(
            color: AuthChoicePage.coffeeBrown.withOpacity(0.08),
          ),
        ),
      ),
    );
  }
}
