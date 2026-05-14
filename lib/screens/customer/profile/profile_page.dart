import 'package:flutter/material.dart';

import '../../../core/services/order_service.dart';
import '../../../core/services/user_address_service.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/order_status.dart';
import '../widgets/customer_icon_button.dart';
import '../widgets/customer_top_bar.dart';
import '../../admin/dashboard/admin_dashboard.dart';
import '../home/user_mobile_home.dart';
import '../orders/my_orders_page.dart';
import '../orders/transaction_history_page.dart';
import 'delivery_address_page.dart';
import 'widgets/profile_edit_input.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_metric_tile.dart';

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
              Text(
                "Setup Profile",
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 16),
              ProfileEditInput(label: "Full Name", controller: nameController),
              const SizedBox(height: 12),
              ProfileEditInput(
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
                  child: Text(
                    "SAVE PROFILE",
                    style: AppTextStyles.navItem.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                      color: Colors.white,
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
    final completedOrders = orders.orders
        .where((order) => order.status == OrderStatus.delivered)
        .length;

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
                    Text(
                      "Profile",
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 32),
                    ),
                    const SizedBox(height: 18),
                    ProfileHeader(onEditProfile: _openEditProfile),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ProfileMetricTile(
                            label: "Orders",
                            value: totalOrders.toString(),
                            icon: Icons.receipt_long_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ProfileMetricTile(
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
                      child: ProfileInfoCard(
                        title: "Delivery Address",
                        value: addressService.profileSummary,
                        icon: Icons.delivery_dining_outlined,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ProfileMenuItem(
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
                    ProfileMenuItem(
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
                    ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: "Help Center",
                      subtitle: "Contact support for order concerns",
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.admin_panel_settings_outlined,
                      title: "Admin Panel",
                      subtitle: "Switch to admin overview",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminDashboard(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuItem(
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

  Widget _topBar(BuildContext context) {
    return CustomerTopBar(
      leading: CustomerIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const UserMobileHome()),
            (route) => false,
          );
        },
      ),
      title: "Profile",
      trailing: CustomerIconButton(
        icon: Icons.settings_outlined,
        onTap: _openEditProfile,
      ),
    );
  }
}
