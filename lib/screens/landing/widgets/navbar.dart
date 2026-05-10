import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final VoidCallback onTop;
  final VoidCallback onAbout;
  final VoidCallback onMenu;
  final VoidCallback onHowItWorks;
  final VoidCallback onFeatures;
  final VoidCallback onStories;

  const Navbar({
    super.key,
    required this.onTop,
    required this.onAbout,
    required this.onMenu,
    required this.onHowItWorks,
    required this.onFeatures,
    required this.onStories,
  });

  static const warmBeige = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const coffeeBrown = Color(0xFFFF1E00);

  void _openSectionMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: warmBeige,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        void closeAndRun(VoidCallback callback) {
          Navigator.pop(sheetContext);
          callback();
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetNavItem(
                  icon: Icons.home_rounded,
                  text: "Top",
                  onTap: () => closeAndRun(onTop),
                ),
                _SheetNavItem(
                  icon: Icons.info_outline_rounded,
                  text: "About",
                  onTap: () => closeAndRun(onAbout),
                ),
                _SheetNavItem(
                  icon: Icons.restaurant_menu_rounded,
                  text: "Menu",
                  onTap: () => closeAndRun(onMenu),
                ),
                _SheetNavItem(
                  icon: Icons.receipt_long_rounded,
                  text: "How it works",
                  onTap: () => closeAndRun(onHowItWorks),
                ),
                _SheetNavItem(
                  icon: Icons.auto_awesome_rounded,
                  text: "Features",
                  onTap: () => closeAndRun(onFeatures),
                ),
                _SheetNavItem(
                  icon: Icons.reviews_rounded,
                  text: "Stories",
                  onTap: () => closeAndRun(onStories),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 768;

    return Material(
      color: warmBeige,
      elevation: 0,
      child: Container(
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
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 24 : 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const ClipOval(
                    child: Image(
                      image: AssetImage("assets/images/logo3.png"),
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Quezel",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Righteous",
                        fontSize: 20,
                        color: darkEspresso,
                      ),
                    ),
                  ),
                  if (isDesktop) ...[
                    _NavItem(text: "About", onTap: onAbout),
                    const SizedBox(width: 28),
                    _NavItem(text: "Menu", onTap: onMenu),
                    const SizedBox(width: 28),
                    _NavItem(text: "How it works", onTap: onHowItWorks),
                    const SizedBox(width: 28),
                    _NavItem(text: "Stories", onTap: onStories),
                    const SizedBox(width: 20),
                  ],
                  IconButton(
                    tooltip: "Open section menu",
                    onPressed: () => _openSectionMenu(context),
                    style: IconButton.styleFrom(
                      backgroundColor: coffeeBrown,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(42, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.menu_rounded),
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

class _NavItem extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavItem({
    required this.text,
    required this.onTap,
  });

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
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: hovered ? softGold : darkEspresso,
          ),
        ),
      ),
    );
  }
}

class _SheetNavItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _SheetNavItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: Navbar.coffeeBrown.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Navbar.coffeeBrown, size: 20),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontFamily: "Poppins",
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Navbar.darkEspresso,
        ),
      ),
      onTap: onTap,
    );
  }
}
