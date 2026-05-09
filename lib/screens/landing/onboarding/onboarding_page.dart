import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 4,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.coffeeBrown,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        "/user/dashboard",
                      );
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Image.asset(
                "assets/images/logo1.png",
                height: 390,
                fit: BoxFit.contain,
              ),

              const Spacer(),

              const Text(
                "Cool treats and\nsnacks near you",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.righteous,
                  fontSize: 34,
                  height: 1.15,
                  color: AppColors.darkEspresso,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Order your Quezel’s favorites anytime. Halo-halo, crema, mais con yelo, burgers, fries, and more.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.darkEspresso.withOpacity(0.78),
                ),
              ),

              const SizedBox(height: 34),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      "/user/dashboard",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coffeeBrown,
                    foregroundColor: AppColors.creamWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    "GET STARTED",
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}