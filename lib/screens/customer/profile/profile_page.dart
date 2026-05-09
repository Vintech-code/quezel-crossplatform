import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/delivery_location_service.dart';
import '../../../core/services/order_service.dart';
import '../home/user_mobile_home.dart';
import '../orders/my_orders_page.dart';
import '../orders/transaction_history_page.dart';
import 'delivery_address_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final locationService = DeliveryLocationService.instance;

  @override
  void initState() {
    super.initState();
    locationService.addListener(_refresh);
  }

  @override
  void dispose() {
    locationService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  String _formatKm(double km) {
    return km % 1 == 0 ? km.toStringAsFixed(0) : km.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final location = locationService.selectedLocation;
    final totalOrders = OrderService.instance.orders.length;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              const SizedBox(height: 22),

              const Text(
                "Profile",
                style: TextStyle(
                  fontFamily: AppFonts.righteous,
                  fontSize: 32,
                  color: AppColors.darkEspresso,
                ),
              ),

              const SizedBox(height: 18),

              _profileHeader(),

              const SizedBox(height: 14),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DeliveryAddressPage(),
                    ),
                  );
                },
                child: _InfoCard(
                  title: "Delivery Location",
                  value:
                      "${location.name} • ${_formatKm(location.km)} km • ₱${location.fee.toStringAsFixed(0)}",
                  icon: Icons.location_on_outlined,
                ),
              ),

              const SizedBox(height: 14),

              _InfoCard(
                title: "Total Orders",
                value: "$totalOrders order(s)",
                icon: Icons.receipt_long_outlined,
              ),

              const SizedBox(height: 18),

              _ProfileMenuItem(
                icon: Icons.local_shipping_outlined,
                title: "My Orders",
                subtitle: "Track active deliveries",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyOrdersPage(),
                    ),
                  );
                },
              ),

              _ProfileMenuItem(
                icon: Icons.history_rounded,
                title: "Order History",
                subtitle: "View all previous transactions",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransactionHistoryPage(),
                    ),
                  );
                },
              ),

              _ProfileMenuItem(
                icon: Icons.help_outline_rounded,
                title: "Help Center",
                subtitle: "Contact support for order concerns",
                onTap: () {},
              ),

              _ProfileMenuItem(
                icon: Icons.logout_rounded,
                title: "Logout",
                subtitle: "Sign out from your account",
                isDanger: true,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              size: 30,
              color: AppColors.coffeeBrown,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quezel Customer",
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkEspresso,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Delivery customer account",
                  style: TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const UserMobileHome(),
              ),
              (route) => false,
            );
          },
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.darkEspresso,
            ),
          ),
        ),

        const Expanded(
          child: Center(
            child: Text(
              "Profile",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),

        const SizedBox(width: 44),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.coffeeBrown,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 13,
                color: AppColors.mutedForeground,
              ),
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.darkEspresso,
              ),
            ),
          ),

          const SizedBox(width: 6),

          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.mutedForeground,
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDanger;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? AppColors.coffeeBrown : AppColors.darkEspresso;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.softGold.withOpacity(0.35),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.mutedForeground.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}