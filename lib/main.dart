import 'package:flutter/material.dart';
import 'screens/landing/landing_page.dart';
import 'screens/landing/auth/sign_in_page.dart';
import 'screens/landing/auth/sign_up_page.dart';
import 'screens/landing/onboarding/onboarding_page.dart';
import 'screens/customer/home/user_mobile_home.dart';

void main() {
  runApp(const QuezelApp());
}

class QuezelApp extends StatelessWidget {
  const QuezelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quezel",
      initialRoute: "/",
      routes: {
        "/": (context) => const LandingPage(),
        "/auth/sign-in": (context) => const SignInPage(),
        "/auth/sign-up": (context) => const SignUpPage(),
        "/user/onboarding": (context) => const OnboardingPage(),
        "/user/dashboard": (context) => const UserMobileHome(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const LandingPage(),
        );
      },
    );
  }
}