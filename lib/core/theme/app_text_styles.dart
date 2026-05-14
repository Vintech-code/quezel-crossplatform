import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';

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

  static const bodyLarge = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 16,
    height: 1.6,
    color: AppColors.mutedForeground,
  );

  static const bodySmall = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 12,
    height: 1.5,
    color: AppColors.mutedForeground,
  );

  static const buttonLabel = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.darkEspresso,
  );

  static const overline = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.2,
    color: AppColors.coffeeBrown,
  );

  static const navLabel = TextStyle(
    fontFamily: AppFonts.poppins,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.mutedForeground,
  );
}
