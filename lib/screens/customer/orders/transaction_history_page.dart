import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/order_service.dart';
import '../../../models/order.dart';
import '../home/user_mobile_home.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final orderService = OrderService.instance;

  @override
  void initState() {
    super.initState();
    orderService.addListener(_refresh);
  }

  @override
  void dispose() {
    orderService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final orders = orderService.orders;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              const SizedBox(height: 22),
              const Text(
                "My Orders",
                style: TextStyle(
                  fontFamily: AppFonts.righteous,
                  fontSize: 32,
                  color: AppColors.darkEspresso,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Track and review your Quezel’s orders.",
                style: TextStyle(
                  fontFamily: AppFonts.poppins,
                  fontSize: 14,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: orders.isEmpty
                    ? _emptyOrders()
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _OrderCard(order: orders[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        _IconButtonBox(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
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
          child: const Icon(
            Icons.home_outlined,
            size: 26,
            color: AppColors.darkEspresso,
          ),
        ),
      ],
    );
  }

  Widget _emptyOrders() {
    return Center(
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
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 38,
              color: AppColors.coffeeBrown,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "No orders yet",
            style: TextStyle(
              fontFamily: AppFonts.righteous,
              fontSize: 24,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your completed orders will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
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
    final date =
        "${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.45),
        ),
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
          const SizedBox(height: 12),
          _InfoRow(label: "Date", value: date),
          const SizedBox(height: 8),
          _InfoRow(label: "Payment", value: order.paymentMethod),
          const SizedBox(height: 8),
          _InfoRow(label: "Order Type", value: order.orderType),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Column(
            children: order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkEspresso,
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
          const SizedBox(height: 6),
          _InfoRow(
            label: "Total",
            value: "₱${order.total.toStringAsFixed(2)}",
            strong: true,
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.softGold.withOpacity(0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.55),
        ),
      ),
      child: Text(
        status,
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
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 13,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: strong ? 15 : 13,
            fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            color: AppColors.darkEspresso,
          ),
        ),
      ],
    );
  }
}

class _IconButtonBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconButtonBox({
    required this.icon,
    this.onTap,
  });

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
          border: Border.all(
            color: AppColors.softGold.withOpacity(0.35),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.darkEspresso,
        ),
      ),
    );
  }
}