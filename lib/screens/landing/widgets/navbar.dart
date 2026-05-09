import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isOpen = false;

  static const warmBeige = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const coffeeBrown = Color(0xFFFF1E00);
  static const softGold = Color(0xFF59CE8F);
  static const creamWhite = Color(0xFFE8F9FD);
  static const parchment = Color(0xFFE8F9FD);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Material(
      color: warmBeige,
      elevation: 0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: warmBeige,
              border: Border(
                bottom: BorderSide(
                  color: darkEspresso.withOpacity(0.12),
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1152),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          ClipOval(
                            child: Image(
                              image: AssetImage("assets/images/logo3.png"),
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Quezel",
                            style: TextStyle(
                              fontFamily: "Righteous",
                              fontSize: 20,
                              letterSpacing: 0.8,
                              color: darkEspresso,
                            ),
                          ),
                        ],
                      ),

                      if (isDesktop)
                        Row(
                          children: const [
                            _NavItem(text: "About"),
                            SizedBox(width: 32),
                            _NavItem(text: "Menu"),
                            SizedBox(width: 32),
                            _NavItem(text: "How it works"),
                            SizedBox(width: 32),
                            _NavItem(text: "Stories"),
                          ],
                        ),

                      if (!isDesktop)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isOpen = !isOpen;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: coffeeBrown,
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  top: isOpen ? 19 : 12,
                                  child: AnimatedRotation(
                                    duration: const Duration(milliseconds: 300),
                                    turns: isOpen ? 0.125 : 0,
                                    child: _MenuLine(),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: isOpen ? 0 : 1,
                                  child: _MenuLine(),
                                ),
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  top: isOpen ? 19 : 26,
                                  child: AnimatedRotation(
                                    duration: const Duration(milliseconds: 300),
                                    turns: isOpen ? -0.125 : 0,
                                    child: _MenuLine(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (!isDesktop)
            Positioned(
              left: 0,
              right: 0,
              top: 65,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isOpen ? 1 : 0,
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: isOpen ? Offset.zero : const Offset(0, -0.08),
                  child: IgnorePointer(
                    ignoring: !isOpen,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: creamWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: coffeeBrown,
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
                        children: const [
                          _MobileNavItem(text: "About"),
                          _MobileNavItem(text: "Menu"),
                          _MobileNavItem(text: "How it works"),
                          _MobileNavItem(text: "Stories"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String text;

  const _NavItem({required this.text});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool hovered = false;

  static const darkEspresso = Color(0xFF000000);
  static const softGold = Color(0xFF59CE8F);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: hovered ? softGold : darkEspresso,
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatefulWidget {
  final String text;

  const _MobileNavItem({required this.text});

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool hovered = false;

  static const darkEspresso = Color(0xFF000000);
  static const parchment = Color(0xFFE8F9FD);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: hovered ? parchment : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkEspresso,
          ),
        ),
      ),
    );
  }
}

class _MenuLine extends StatelessWidget {
  _MenuLine();

  static const darkEspresso = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: 20,
      decoration: BoxDecoration(
        color: darkEspresso,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}