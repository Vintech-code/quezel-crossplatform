import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/order_service.dart';
import '../../../models/order.dart';
import '../home/user_mobile_home.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final orderService = OrderService.instance;

  final tabs = const [
    "To Receive",
    "Completed",
    "Return/Refund",
    "Cancelled",
  ];

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: tabs.length,
      vsync: this,
    );

    orderService.addListener(_refresh);
  }

  @override
  void dispose() {
    orderService.removeListener(_refresh);
    tabController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final toReceiveOrders = orderService.orders
        .where((o) => o.status == "Preparing")
        .toList();

    final completedOrders = orderService.orders
        .where((o) => o.status == "Completed")
        .toList();

    final refundOrders = orderService.orders
        .where((o) => o.status == "Refund")
        .toList();

    final cancelledOrders = orderService.orders
        .where((o) => o.status == "Cancelled")
        .toList();

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  _topBar(context),

                  const SizedBox(height: 22),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "My Orders",
                      style: TextStyle(
                        fontFamily: AppFonts.righteous,
                        fontSize: 32,
                        color: AppColors.darkEspresso,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Track your deliveries and order activities.",
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  _tabBar(),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _ordersList(
                    orders: toReceiveOrders,
                    emptyTitle: "No orders to receive",
                    emptySubtitle:
                        "Your active deliveries will appear here.",
                    emptyIcon: Icons.local_shipping_outlined,
                  ),

                  _ordersList(
                    orders: completedOrders,
                    emptyTitle: "No completed orders",
                    emptySubtitle:
                        "Finished deliveries will appear here.",
                    emptyIcon: Icons.check_circle_outline_rounded,
                  ),

                  _ordersList(
                    orders: refundOrders,
                    emptyTitle: "No return/refund requests",
                    emptySubtitle:
                        "Returned or refunded orders will appear here.",
                    emptyIcon: Icons.assignment_return_outlined,
                  ),

                  _ordersList(
                    orders: cancelledOrders,
                    emptyTitle: "No cancelled orders",
                    emptySubtitle:
                        "Cancelled orders will appear here.",
                    emptyIcon: Icons.cancel_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ordersList({
    required List<Order> orders,
    required String emptyTitle,
    required String emptySubtitle,
    required IconData emptyIcon,
  }) {
    if (orders.isEmpty) {
      return _OrdersPlaceholder(
        icon: emptyIcon,
        title: emptyTitle,
        subtitle: emptySubtitle,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _OrderCard(order: orders[index]);
      },
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
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
              "Orders",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),

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
              Icons.home_outlined,
              size: 20,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.35),
        ),
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.coffeeBrown,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.darkEspresso,
        labelStyle: const TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.coffeeBrown,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  order.id,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkEspresso,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.softGold.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Column(
            children: order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      "x${item.quantity}",
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 13,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  color: AppColors.mutedForeground,
                ),
              ),

              Text(
                "₱${order.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontWeight: FontWeight.w900,
                  color: AppColors.darkEspresso,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrdersPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OrdersPlaceholder({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.softGold.withOpacity(0.35),
                ),
              ),
              child: Icon(
                icon,
                size: 38,
                color: AppColors.coffeeBrown,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.righteous,
                fontSize: 24,
                color: AppColors.darkEspresso,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}