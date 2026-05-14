import 'package:flutter/material.dart';

import '../../../core/services/order_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../cart/cart_page.dart';
import '../home/user_mobile_home.dart';
import 'order_tracking_page.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final orderService = OrderService.instance;

  final tabs = const ["To Receive", "Completed", "Return/Refund", "Cancelled"];

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: tabs.length, vsync: this);

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

  void _reorder(Order order) {
    orderService.reorder(order);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final toReceiveOrders = orderService.orders
        .where((order) => OrderStatus.activeStatuses.contains(order.status))
        .toList();

    final completedOrders = orderService.orders
        .where((order) => order.status == OrderStatus.delivered)
        .toList();

    final refundOrders = orderService.orders
        .where((order) => OrderStatus.refundStatuses.contains(order.status))
        .toList();

    final cancelledOrders = orderService.orders
        .where((order) => order.status == OrderStatus.cancelled)
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
                    emptySubtitle: "Your active deliveries will appear here.",
                    emptyIcon: Icons.local_shipping_outlined,
                  ),
                  _ordersList(
                    orders: completedOrders,
                    emptyTitle: "No completed orders",
                    emptySubtitle: "Finished deliveries will appear here.",
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
                    emptySubtitle: "Cancelled orders will appear here.",
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _OrderCard(
          order: orders[index],
          onCancel: () => orderService.cancelOrder(orders[index].id),
          onRequestRefund: () => _openTracking(orders[index]),
          onReorder: () => _reorder(orders[index]),
          onTrack: () => _openTracking(orders[index]),
        );
      },
    );
  }

  void _openTracking(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderTrackingPage(orderId: order.id)),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        _IconButtonBox(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
              return;
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const UserMobileHome()),
              (route) => false,
            );
          },
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
        _IconButtonBox(
          icon: Icons.home_outlined,
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const UserMobileHome()),
              (route) => false,
            );
          },
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
        border: Border.all(color: AppColors.softGold.withValues(alpha: 0.45)),
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: AppColors.coffeeBrown,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.darkEspresso,
        labelPadding: const EdgeInsets.symmetric(horizontal: 14),
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
  final VoidCallback onCancel;
  final VoidCallback onRequestRefund;
  final VoidCallback onReorder;
  final VoidCallback onTrack;

  const _OrderCard({
    required this.order,
    required this.onCancel,
    required this.onRequestRefund,
    required this.onReorder,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final date =
        "${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}";
    final distance = order.deliveryKm % 1 == 0
        ? order.deliveryKm.toStringAsFixed(0)
        : order.deliveryKm.toStringAsFixed(1);

    return GestureDetector(
      onTap: onTrack,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.creamWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.softGold.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 22,
                  color: AppColors.coffeeBrown,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppFonts.poppins,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkEspresso,
                    ),
                  ),
                ),
                _StatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 14),
            _InfoRow(label: "Date", value: date),
            const SizedBox(height: 8),
            _InfoRow(label: "Payment", value: order.paymentMethod),
            const SizedBox(height: 8),
            _InfoRow(label: "Order Type", value: order.orderType),
            const SizedBox(height: 8),
            _InfoRow(
              label: "Address",
              value: "${order.deliveryLocation} • $distance km",
            ),
            const SizedBox(height: 12),
            _OrderTracking(status: order.status),
            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: AppColors.softGold.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 12),
            Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: AppFonts.poppins,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkEspresso,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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
            const SizedBox(height: 3),
            _InfoRow(
              label: "Subtotal",
              value: "₱${order.subtotal.toStringAsFixed(2)}",
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: "Delivery Fee",
              value: "₱${order.deliveryFee.toStringAsFixed(2)}",
            ),
            const SizedBox(height: 10),
            _InfoRow(
              label: "Total",
              value: "₱${order.total.toStringAsFixed(2)}",
              strong: true,
            ),
            _actions(),
          ],
        ),
      ),
    );
  }

  Widget _actions() {
    if (order.status == OrderStatus.pending ||
        order.status == OrderStatus.accepted) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: _OrderActionButton(
          label: "Cancel Order",
          icon: Icons.close_rounded,
          onTap: onCancel,
          outlined: true,
        ),
      );
    }

    if (order.status == OrderStatus.preparing) {
      return const Padding(
        padding: EdgeInsets.only(top: 14),
        child: _TrackingNote(
          icon: Icons.restaurant_menu_rounded,
          text: "Your order is being prepared.",
        ),
      );
    }

    if (order.status == OrderStatus.outForDelivery) {
      return const Padding(
        padding: EdgeInsets.only(top: 14),
        child: _TrackingNote(
          icon: Icons.delivery_dining_outlined,
          text: "Your order is on the way.",
        ),
      );
    }

    if (order.status == OrderStatus.delivered) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            Expanded(
              child: _OrderActionButton(
                label: "Reorder",
                icon: Icons.shopping_cart_outlined,
                onTap: onReorder,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _OrderActionButton(
                label: "Request Refund",
                icon: Icons.assignment_return_outlined,
                onTap: onRequestRefund,
                outlined: true,
              ),
            ),
          ],
        ),
      );
    }

    if (order.status == OrderStatus.cancelled) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: _OrderActionButton(
          label: "Reorder",
          icon: Icons.shopping_cart_outlined,
          onTap: onReorder,
        ),
      );
    }

    return const Padding(
      padding: EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.mutedForeground,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Your return or refund request is being reviewed.",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTracking extends StatelessWidget {
  final String status;

  const _OrderTracking({required this.status});

  @override
  Widget build(BuildContext context) {
    const steps = [
      OrderStatus.pending,
      OrderStatus.accepted,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    final currentIndex = steps.indexOf(status);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: steps.map((step) {
        final stepIndex = steps.indexOf(step);
        final isActive = currentIndex >= stepIndex && currentIndex >= 0;
        final color = isActive
            ? AppColors.coffeeBrown
            : AppColors.mutedForeground;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isActive ? 0.14 : 0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: color.withValues(alpha: isActive ? 0.65 : 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 13,
                color: color,
              ),
              const SizedBox(width: 5),
              Text(
                step,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TrackingNote extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrackingNote({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mutedForeground),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.softGold.withValues(alpha: 0.55)),
      ),
      child: Text(
        OrderStatus.label(status),
        style: const TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.darkEspresso,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;

  const _InfoRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: strong ? 14 : 13,
              fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: strong ? 17 : 13,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool outlined;

  const _OrderActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = outlined ? AppColors.darkEspresso : Colors.white;

    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: FittedBox(fit: BoxFit.scaleDown, child: Text(label)),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: outlined ? Colors.white : AppColors.coffeeBrown,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: outlined
                  ? AppColors.softGold.withValues(alpha: 0.55)
                  : AppColors.coffeeBrown,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _IconButtonBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconButtonBox({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.softGold.withValues(alpha: 0.45)),
        ),
        child: Icon(icon, size: 20, color: AppColors.darkEspresso),
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
                  color: AppColors.softGold.withValues(alpha: 0.45),
                ),
              ),
              child: Icon(icon, size: 38, color: AppColors.coffeeBrown),
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
