import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/services/cart_service.dart';
import 'core/services/favorite_service.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/order_service.dart';
import 'screens/admin/dashboard/admin_dashboard.dart';
import 'screens/customer/home/user_mobile_home.dart';
import 'screens/landing/auth/sign_in_page.dart';
import 'screens/landing/auth/sign_up_page.dart';
import 'screens/landing/landing_page.dart';
import 'screens/landing/onboarding/onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorageService.instance.init();
  await Future.wait([
    CartService.instance.loadFromStorage(),
    FavoriteService.instance.loadFromStorage(),
    OrderService.instance.loadFromStorage(),
  ]);

  runApp(const QuezelApp());
}

class QuezelApp extends StatelessWidget {
  const QuezelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quezel",
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.warmBeige,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.coffeeBrown,
          primary: AppColors.coffeeBrown,
          secondary: AppColors.softGold,
          tertiary: AppColors.haloPurple,
          surface: AppColors.creamWhite,
        ),
        fontFamily: AppFonts.poppins,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.darkEspresso,
          displayColor: AppColors.darkEspresso,
        ),
      ),
      initialRoute: AppRoutes.landing,
      routes: {
        AppRoutes.landing: (context) => const LandingPage(),
        AppRoutes.signIn: (context) => const SignInPage(),
        AppRoutes.signUp: (context) => const SignUpPage(),
        AppRoutes.onboarding: (context) => const OnboardingPage(),
        AppRoutes.userDashboard: (context) => const UserMobileHome(),
        AppRoutes.adminDashboard: (context) => const AdminDashboard(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LandingPage());
      },
    );
  }
}
