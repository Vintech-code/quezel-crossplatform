import 'package:flutter/material.dart';

class AppColors {
  static const warmBeige = Color(0xFFE8F9FD);
  static const creamWhite = Color(0xFFE8F9FD);
  static const parchment = Color(0xFFE8F9FD);
  static const darkEspresso = Color(0xFF000000);
  static const coffeeBrown = Color(0xFFFF1E00);
  static const softGold = Color(0xFF59CE8F);
  static const mutedForeground = Color(0xFF4B5563);
}

class AppFonts {
  static const poppins = "Poppins";
  static const righteous = "Righteous";
}

class AppSpacing {
  static const pageX = 24.0;
  static const sectionY = 96.0;
  static const maxWidth = 1152.0;
}

class AppRadius {
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const full = 999.0;
}

class AppShadows {
  static List<BoxShadow> diffuse = [
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
  ];

  static List<BoxShadow> diffuseLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.18),
      blurRadius: 48,
      offset: const Offset(0, 16),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.20),
      blurRadius: 96,
      offset: const Offset(0, 40),
    ),
  ];
}

class AppTextStyles {
  static const navLogo = TextStyle(
    fontFamily: AppFonts.righteous,
    fontSize: 20,
    letterSpacing: 0.8,
    color: AppColors.darkEspresso,
  );

  static const navItem = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.darkEspresso,
  );

  static const sectionLabel = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 14,
    letterSpacing: 4.2,
    fontWeight: FontWeight.w600,
    color: AppColors.coffeeBrown,
  );

  static const sectionTitle = TextStyle(
    fontFamily: AppFonts.righteous,
    fontSize: 40,
    height: 1.15,
    color: AppColors.darkEspresso,
  );

  static const cardTitle = TextStyle(
    fontFamily: AppFonts.righteous,
    fontSize: 20,
    color: AppColors.darkEspresso,
  );

  static const paragraph = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 14,
    height: 1.7,
    color: AppColors.mutedForeground,
  );
}