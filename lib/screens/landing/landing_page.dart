import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'widgets/navbar.dart';
import 'sections/hero_section.dart';
import 'sections/features_section.dart';
import 'sections/footer.dart';
import 'sections/how_it_works_section.dart';
import 'sections/menu_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/about_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _storiesKey = GlobalKey();
  bool _showScrollTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final shouldShow =
        _scrollController.hasClients && _scrollController.offset > 420;
    if (shouldShow != _showScrollTop) {
      setState(() => _showScrollTop = shouldShow);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeOutCubic,
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    const headerHeight = 66.0;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      floatingActionButton: AnimatedScale(
        scale: _showScrollTop ? 1 : 0,
        duration: const Duration(milliseconds: 180),
        child: IgnorePointer(
          ignoring: !_showScrollTop,
          child: AnimatedOpacity(
            opacity: _showScrollTop ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: FloatingActionButton.small(
              heroTag: "landing-scroll-top",
              backgroundColor: AppColors.coffeeBrown,
              foregroundColor: Colors.white,
              elevation: 4,
              onPressed: _scrollToTop,
              child: const Icon(Icons.keyboard_arrow_up_rounded),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _LandingHeaderDelegate(
                height: headerHeight,
                child: Navbar(
                  onTop: _scrollToTop,
                  onAbout: () => _scrollTo(_aboutKey),
                  onMenu: () => _scrollTo(_menuKey),
                  onHowItWorks: () => _scrollTo(_howItWorksKey),
                  onFeatures: () => _scrollTo(_featuresKey),
                  onStories: () => _scrollTo(_storiesKey),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _heroKey,
                child: HeroSection(onExploreMenu: () => _scrollTo(_menuKey)),
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(key: _aboutKey, child: const AboutSection()),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(key: _menuKey, child: const MenuSection()),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _howItWorksKey,
                child: const HowItWorksSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _featuresKey,
                child: const FeaturesSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: KeyedSubtree(
                key: _storiesKey,
                child: const TestimonialsSection(),
              ),
            ),
            const SliverToBoxAdapter(child: Footer()),
          ],
        ),
      ),
    );
  }
}

class _LandingHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  const _LandingHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _LandingHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
