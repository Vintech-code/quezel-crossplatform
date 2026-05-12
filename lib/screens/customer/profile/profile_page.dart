import 'package:flutter/material.dart';

import '../../../core/services/order_service.dart';
import '../../../core/services/user_address_service.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/theme/app_theme.dart';
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
  final addressService = UserAddressService.instance;
  final profileService = UserProfileService.instance;
  final orders = OrderService.instance;

  @override
  void initState() {
    super.initState();
    addressService.addListener(_refresh);
    profileService.addListener(_refresh);
    orders.addListener(_refresh);
  }

  @override
  void dispose() {
    addressService.removeListener(_refresh);
    profileService.removeListener(_refresh);
    orders.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _openEditProfile() {
    final nameController = TextEditingController(text: profileService.fullName);
    final emailController = TextEditingController(text: profileService.email);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            18,
            18,
            MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Setup Profile",
                style: TextStyle(
                  fontFamily: AppFonts.righteous,
                  fontSize: 26,
                  color: AppColors.darkEspresso,
                ),
              ),
              const SizedBox(height: 16),
              _EditInput(
                label: "Full Name",
                controller: nameController,
              ),
              const SizedBox(height: 12),
              _EditInput(
                label: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    profileService.updateProfile(
                      fullName: nameController.text,
                      email: emailController.text,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coffeeBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "SAVE PROFILE",
                    style: TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      emailController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalOrders = orders.orders.length;
    final completedOrders =
        orders.orders.where((order) => order.status == "Completed").length;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _topBar(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Row(
                      children: [
                        Expanded(
                          child: _MetricTile(
                            label: "Orders",
                            value: totalOrders.toString(),
                            icon: Icons.receipt_long_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricTile(
                            label: "Completed",
                            value: completedOrders.toString(),
                            icon: Icons.check_circle_outline_rounded,
                          ),
                        ),
                      ],
                    ),
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
                        title: "Delivery Address",
                        value: addressService.profileSummary,
                        icon: Icons.delivery_dining_outlined,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _ProfileMenuItem(
                      icon: Icons.delivery_dining_outlined,
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
          ],
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.55),
                width: 1.4,
              ),
            ),
            child: Center(
              child: Text(
                profileService.initials,
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.coffeeBrown,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileService.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkEspresso,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  profileService.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: _openEditProfile,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text("Edit Profile"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkEspresso,
                      side: BorderSide(
                        color: AppColors.softGold.withOpacity(0.55),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
              MaterialPageRoute(builder: (_) => const UserMobileHome()),
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
                fontWeight: FontWeight.w800,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: _openEditProfile,
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
              Icons.settings_outlined,
              size: 20,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Icon(icon, color: AppColors.coffeeBrown),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkEspresso,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
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
          Icon(icon, color: AppColors.coffeeBrown),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkEspresso,
                  ),
                ),
              ],
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
            Icon(icon, color: color),
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

class _EditInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _EditInput({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.darkEspresso,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.warmBeige,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.coffeeBrown,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
