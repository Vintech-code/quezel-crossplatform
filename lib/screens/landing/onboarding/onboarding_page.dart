import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/delivery_location_service.dart';
import '../../../models/delivery_location.dart';
import '../../customer/home/user_mobile_home.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final pageController = PageController();
  final locationService = DeliveryLocationService.instance;

  int currentPage = 0;
  late DeliveryLocation selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = locationService.selectedLocation;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage == 2) {
      locationService.setLocation(selectedLocation);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const UserMobileHome(),
        ),
      );
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void skip() {
    locationService.setLocation(selectedLocation);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const UserMobileHome(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(child: _progressBar(0)),
                  const SizedBox(width: 8),
                  Expanded(child: _progressBar(1)),
                  const SizedBox(width: 8),
                  Expanded(child: _progressBar(2)),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: skip,
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  _IntroSlide(
                    icon: Icons.local_drink_outlined,
                    title: "Cool treats delivered to you",
                    subtitle:
                        "Order your Quezel’s favorites from home and wait for your rider to deliver it.",
                  ),
                  _IntroSlide(
                    icon: Icons.delivery_dining_outlined,
                    title: "Fast local delivery",
                    subtitle:
                        "Your order is prepared by Quezel’s and delivered by riders within covered areas.",
                  ),
                  _LocationSlide(
                    locations: locationService.locations,
                    selectedLocation: selectedLocation,
                    onSelect: (location) {
                      setState(() {
                        selectedLocation = location;
                      });
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coffeeBrown,
                    foregroundColor: AppColors.creamWhite,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    currentPage == 2 ? "START ORDERING" : "NEXT",
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressBar(int index) {
    final active = currentPage >= index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 4,
      decoration: BoxDecoration(
        color: active
            ? AppColors.coffeeBrown
            : AppColors.darkEspresso.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _IntroSlide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _IntroSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 190,
            width: 190,
            decoration: BoxDecoration(
              color: AppColors.creamWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.45),
              ),
            ),
            child: Icon(
              icon,
              size: 86,
              color: AppColors.coffeeBrown,
            ),
          ),
          const SizedBox(height: 42),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.righteous,
              fontSize: 34,
              height: 1.12,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              height: 1.6,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationSlide extends StatelessWidget {
  final List<DeliveryLocation> locations;
  final DeliveryLocation selectedLocation;
  final ValueChanged<DeliveryLocation> onSelect;

  const _LocationSlide({
    required this.locations,
    required this.selectedLocation,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose your location",
            style: TextStyle(
              fontFamily: AppFonts.righteous,
              fontSize: 32,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Your delivery fee will be set automatically based on your selected area.",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              height: 1.5,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 18),

          Expanded(
            child: ListView.separated(
              itemCount: locations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final location = locations[index];
                final active = selectedLocation.name == location.name;

                return GestureDetector(
                  onTap: () => onSelect(location),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: active ? Colors.white : AppColors.creamWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: active
                            ? AppColors.coffeeBrown
                            : AppColors.softGold.withOpacity(0.35),
                        width: active ? 1.4 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          active
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: active
                              ? AppColors.coffeeBrown
                              : AppColors.mutedForeground,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            location.name,
                            style: const TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkEspresso,
                            ),
                          ),
                        ),
                        Text(
                          "${location.km % 1 == 0 ? location.km.toStringAsFixed(0) : location.km.toStringAsFixed(1)} km",
                          style: const TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "₱${location.fee.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.coffeeBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}