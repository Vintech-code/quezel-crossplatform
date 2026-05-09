import 'package:flutter/material.dart';
import 'widgets/navbar.dart';
import 'sections/hero_section.dart';
import 'sections/features_section.dart';
import 'sections/footer.dart';
import 'sections/how_it_works_section.dart';
import 'sections/menu_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/about_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F9FD),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            HeroSection(),
            AboutSection(),
            MenuSection(),
            HowItWorksSection(),
            FeaturesSection(),
            TestimonialsSection(),
            Footer(),
          ],
        ),
      ),
    );
  }
}