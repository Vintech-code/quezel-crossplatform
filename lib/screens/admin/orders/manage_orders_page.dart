import 'package:flutter/material.dart';

import '../../../core/services/order_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../widgets/admin_shell.dart';
import '../widgets/admin_status_chip.dart';
import '../widgets/admin_surface_card.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  final orderService = OrderService.instance;
  String selectedFilter = _OrderFilterOption.all;

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
    final filteredOrders = _filteredOrders(orders);

    return AdminShell(
      title: "Order Flow",
      subtitle: "Review customer details and update mock order status.",
      activeSection: AdminSection.orders,
      body: [
        _OrderStageSummary(orders: orders),
        const SizedBox(height: 16),
        _OrderFilterTabs(
          selected: selectedFilter,
          onSelected: (filter) => setState(() => selectedFilter = filter),
        ),
        const SizedBox(height: 14),
        filteredOrders.isEmpty
            ? const _EmptyOrdersState()
            : _OrdersGrid(
                orders: filteredOrders,
                onAdvance: _advanceOrder,
                onReject: orderService.rejectOrder,
                onCancel: orderService.cancelOrder,
                onApproveRefund: orderService.approveRefund,
                onRejectRefund: orderService.rejectRefund,
              ),
      ],
    );
  }

  List<Order> _filteredOrders(List<Order> orders) {
    switch (selectedFilter) {
      case _OrderFilterOption.pending:
        return orders
            .where((order) => order.status == OrderStatus.pending)
            .toList();
      case _OrderFilterOption.preparing:
        return orders
            .where((order) => order.status == OrderStatus.preparing)
            .toList();
      case _OrderFilterOption.outForDelivery:
        return orders
            .where((order) => order.status == OrderStatus.outForDelivery)
            .toList();
      case _OrderFilterOption.delivered:
        return orders
            .where((order) => order.status == OrderStatus.delivered)
            .toList();
      case _OrderFilterOption.refundRequests:
        return orders
            .where((order) => order.status == OrderStatus.refundRequested)
            .toList();
      case _OrderFilterOption.cancelled:
        return orders
            .where((order) => order.status == OrderStatus.cancelled)
            .toList();
      default:
        return orders;
    }
  }

  void _advanceOrder(Order order) {
    switch (order.status) {
      case OrderStatus.pending:
        orderService.acceptOrder(order.id);
        break;
      case OrderStatus.accepted:
        orderService.markPreparing(order.id);
        break;
      case OrderStatus.preparing:
        orderService.markOutForDelivery(order.id);
        break;
      case OrderStatus.outForDelivery:
        orderService.markDelivered(order.id);
        break;
    }
  }
}

class _OrderFilterOption {
  static const all = "All";
  static const pending = "Pending";
  static const preparing = "Preparing";
  static const outForDelivery = "Out For Delivery";
  static const delivered = "Delivered";
  static const refundRequests = "Refund Requests";
  static const cancelled = "Cancelled";

  static const values = [
    all,
    pending,
    preparing,
    outForDelivery,
    delivered,
    refundRequests,
    cancelled,
  ];
}

class _OrderFilterTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const _OrderFilterTabs({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _OrderFilterOption.values.map((filter) {
          final active = filter == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              selected: active,
              label: Text(filter),
              onSelected: (_) => onSelected(filter),
              selectedColor: AppColors.coffeeBrown,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: AppColors.softGold.withValues(alpha: 0.45),
              ),
              labelStyle: AppTextStyles.navItem.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : AppColors.darkEspresso,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OrderStageSummary extends StatelessWidget {
  final List<Order> orders;

  const _OrderStageSummary({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StageChip(
          label: "Pending",
          count: _count(OrderStatus.pending),
          icon: Icons.schedule_rounded,
          color: AppColors.mutedForeground,
        ),
        _StageChip(
          label: "Preparing",
          count: _count(OrderStatus.preparing),
          icon: Icons.restaurant_menu_rounded,
          color: AppColors.softGold,
        ),
        _StageChip(
          label: "Delivered",
          count: _count(OrderStatus.delivered),
          icon: Icons.verified_rounded,
          color: AppColors.coffeeBrown,
        ),
        _StageChip(
          label: "Refunds",
          count: _count(OrderStatus.refundRequested),
          icon: Icons.assignment_return_outlined,
          color: AppColors.mutedForeground,
        ),
      ],
    );
  }

  int _count(String status) {
    return orders.where((order) => order.status == status).length;
  }
}

class _StageChip extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _StageChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 7),
          Text(
            "$label  $count",
            style: AppTextStyles.navItem.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersGrid extends StatelessWidget {
  final List<Order> orders;
  final ValueChanged<Order> onAdvance;
  final ValueChanged<String> onReject;
  final ValueChanged<String> onCancel;
  final ValueChanged<String> onApproveRefund;
  final ValueChanged<String> onRejectRefund;

  const _OrdersGrid({
    required this.orders,
    required this.onAdvance,
    required this.onReject,
    required this.onCancel,
    required this.onApproveRefund,
    required this.onRejectRefund,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1180
            ? 3
            : width >= 820
            ? 2
            : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: 390,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final order = orders[index];
            return _OrderCard(
              order: order,
              onAdvance: () => onAdvance(order),
              onReject: () => onReject(order.id),
              onCancel: () => onCancel(order.id),
              onApproveRefund: () => onApproveRefund(order.id),
              onRejectRefund: () => onRejectRefund(order.id),
            );
          },
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onAdvance;
  final VoidCallback onReject;
  final VoidCallback onCancel;
  final VoidCallback onApproveRefund;
  final VoidCallback onRejectRefund;

  const _OrderCard({
    required this.order,
    required this.onAdvance,
    required this.onReject,
    required this.onCancel,
    required this.onApproveRefund,
    required this.onRejectRefund,
  });

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.all(14),
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AdminStatusChip(
                label: OrderStatus.label(order.status),
                color: _statusColor(order.status),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _InfoLine(icon: Icons.person_outline, value: order.customerName),
          const SizedBox(height: 6),
          _InfoLine(icon: Icons.phone_outlined, value: order.phoneNumber),
          const SizedBox(height: 6),
          _InfoLine(icon: Icons.place_outlined, value: order.deliveryLocation),
          const SizedBox(height: 6),
          _InfoLine(
            icon: Icons.payments_outlined,
            value: "${order.paymentMethod} | ${order.orderType}",
          ),
          if (order.status == OrderStatus.refundRequested) ...[
            const SizedBox(height: 8),
            _RefundNote(order: order),
          ],
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return _OrderItemRow(
                  image: item.product.image,
                  name: item.product.name,
                  price: item.product.price,
                  quantity: item.quantity,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                "Php ${order.total.toStringAsFixed(2)}",
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              _AdminOrderActions(
                order: order,
                onAdvance: onAdvance,
                onReject: onReject,
                onCancel: onCancel,
                onApproveRefund: onApproveRefund,
                onRejectRefund: onRejectRefund,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.cancelled:
      case OrderStatus.refundRejected:
        return AppColors.mutedForeground;
      case OrderStatus.accepted:
      case OrderStatus.outForDelivery:
      case OrderStatus.refundRequested:
        return AppColors.coffeeBrown;
      default:
        return AppColors.softGold;
    }
  }
}

class _AdminOrderActions extends StatelessWidget {
  final Order order;
  final VoidCallback onAdvance;
  final VoidCallback onReject;
  final VoidCallback onCancel;
  final VoidCallback onApproveRefund;
  final VoidCallback onRejectRefund;

  const _AdminOrderActions({
    required this.order,
    required this.onAdvance,
    required this.onReject,
    required this.onCancel,
    required this.onApproveRefund,
    required this.onRejectRefund,
  });

  @override
  Widget build(BuildContext context) {
    if (order.status == OrderStatus.pending) {
      return Row(
        children: [
          _IconAction(icon: Icons.close_rounded, onTap: onReject),
          const SizedBox(width: 8),
          _SmallActionButton(label: "Accept", onTap: onAdvance),
        ],
      );
    }

    if (order.status == OrderStatus.refundRequested) {
      return Row(
        children: [
          _IconAction(icon: Icons.close_rounded, onTap: onRejectRefund),
          const SizedBox(width: 8),
          _SmallActionButton(label: "Approve", onTap: onApproveRefund),
        ],
      );
    }

    if (order.status == OrderStatus.accepted ||
        order.status == OrderStatus.preparing ||
        order.status == OrderStatus.outForDelivery) {
      return Row(
        children: [
          if (order.status == OrderStatus.accepted) ...[
            _IconAction(icon: Icons.close_rounded, onTap: onCancel),
            const SizedBox(width: 8),
          ],
          _SmallActionButton(label: _nextLabel(order.status), onTap: onAdvance),
        ],
      );
    }

    return _DonePill(status: order.status);
  }

  String _nextLabel(String status) {
    switch (status) {
      case OrderStatus.accepted:
        return "Start Preparing";
      case OrderStatus.preparing:
        return "Out For Delivery";
      case OrderStatus.outForDelivery:
        return "Delivered";
      default:
        return "Update";
    }
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoLine({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.mutedForeground),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value.isEmpty ? "Not provided" : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _RefundNote extends StatelessWidget {
  final Order order;

  const _RefundNote({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.coffeeBrown.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "Refund: ${order.refundReason ?? "No reason"}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final int quantity;

  const _OrderItemRow({
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 42,
            width: 42,
            color: AppColors.warmBeige,
            child: Image.asset(image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                price,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
        Text(
          "x$quantity",
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _IconAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: AppColors.mutedForeground.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.mutedForeground.withValues(alpha: 0.45),
          ),
        ),
        child: const Icon(
          Icons.close_rounded,
          size: 18,
          color: AppColors.mutedForeground,
        ),
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SmallActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coffeeBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class _DonePill extends StatelessWidget {
  final String status;

  const _DonePill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.softGold.withValues(alpha: 0.55)),
      ),
      child: Text(
        OrderStatus.label(status),
        style: AppTextStyles.navItem.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState();

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
      radius: 18,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: AppColors.softGold.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.coffeeBrown,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "No orders in this view",
              style: AppTextStyles.navItem.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Customer checkout orders and refund requests will appear here.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
