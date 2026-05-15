import 'package:flutter/material.dart';

import '../../../core/services/order_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/cart_item.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../../widgets/adaptive_image.dart';
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
    final pendingOrders = orders
        .where((order) => order.status == OrderStatus.pending)
        .toList();
    final pendingTotal = pendingOrders.fold<double>(
      0,
      (sum, order) => sum + order.total,
    );
    final filteredOrders = _filteredOrders(orders);

    return AdminShell(
      title: "Order Flow",
      subtitle: "Review customer details and update mock order status.",
      activeSection: AdminSection.orders,
      body: [
        if (pendingOrders.isNotEmpty)
          _NewOrderQueue(orders: pendingOrders, totalValue: pendingTotal),
        if (pendingOrders.isNotEmpty) const SizedBox(height: 12),
        _OrderStageSummary(orders: orders),
        const SizedBox(height: 12),
        _OrderFilterTabs(
          selected: selectedFilter,
          onSelected: (filter) => setState(() => selectedFilter = filter),
        ),
        const SizedBox(height: 10),
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

String _formatTime(DateTime value) {
  final hour = value.hour;
  final minute = value.minute;
  final isPm = hour >= 12;
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  final minuteText = minute.toString().padLeft(2, '0');
  return "$displayHour:$minuteText ${isPm ? 'PM' : 'AM'}";
}

class _NewOrderQueue extends StatelessWidget {
  final List<Order> orders;
  final double totalValue;

  const _NewOrderQueue({required this.orders, required this.totalValue});

  @override
  Widget build(BuildContext context) {
    final preview = orders.take(3).toList();
    final latest = orders.isEmpty ? null : orders.first.createdAt;

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.coffeeBrown.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.coffeeBrown.withOpacity(0.5),
                  ),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 18,
                  color: AppColors.coffeeBrown,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Incoming queue",
                      style: AppTextStyles.navItem.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Customer orders waiting for admin review",
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QueueMetric(
                label: "Pending",
                value: orders.length.toString(),
                tone: AppColors.softGold,
              ),
              _QueueMetric(
                label: "Queue value",
                value: "Php ${totalValue.toStringAsFixed(2)}",
                tone: AppColors.coffeeBrown,
              ),
              if (latest != null)
                _QueueMetric(
                  label: "Latest",
                  value: _formatTime(latest),
                  tone: AppColors.mutedForeground,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: preview.map((order) {
              return _QueuePreviewCard(order: order);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QueueMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color tone;

  const _QueueMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tone.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tone.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.navItem.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: tone,
            ),
          ),
        ],
      ),
    );
  }
}

class _QueuePreviewCard extends StatelessWidget {
  final Order order;

  const _QueuePreviewCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 220),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.warmBeige,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.softGold.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.customerName.isEmpty ? "Customer order" : order.customerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.navItem.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${order.items.length} items · ${order.orderType}",
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                "Php ${order.total.toStringAsFixed(2)}",
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                _formatTime(order.createdAt),
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
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
            padding: const EdgeInsets.only(right: 6),
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
    final cards = [
      _StageStatData(
        label: "Pending",
        count: _count(OrderStatus.pending),
        icon: Icons.schedule_rounded,
        color: AppColors.mutedForeground,
      ),
      _StageStatData(
        label: "Preparing",
        count: _count(OrderStatus.preparing),
        icon: Icons.restaurant_menu_rounded,
        color: AppColors.softGold,
      ),
      _StageStatData(
        label: "Out for Delivery",
        count: _count(OrderStatus.outForDelivery),
        icon: Icons.local_shipping_outlined,
        color: AppColors.coffeeBrown,
      ),
      _StageStatData(
        label: "Refunds",
        count: _count(OrderStatus.refundRequested),
        icon: Icons.assignment_return_outlined,
        color: AppColors.mutedForeground,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        if (isWide) {
          return Row(
            children: cards
                .map(
                  (card) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: card == cards.last ? 0 : 10,
                      ),
                      child: _StageStatCard(data: card),
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: cards.map((card) => _StageStatCard(data: card)).toList(),
        );
      },
    );
  }

  int _count(String status) {
    return orders.where((order) => order.status == status).length;
  }
}

class _StageStatData {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _StageStatData({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}

class _StageStatCard extends StatelessWidget {
  final _StageStatData data;

  const _StageStatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: data.color.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: data.color.withOpacity(0.5)),
            ),
            child: Icon(data.icon, size: 18, color: data.color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  data.count.toString(),
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkEspresso,
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
            mainAxisExtent: 360,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
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
      padding: const EdgeInsets.all(12),
      radius: 16,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _formatTime(order.createdAt),
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              ),
              const SizedBox(width: 8),
              AdminStatusChip(
                label: OrderStatus.label(order.status),
                color: _statusColor(order.status),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _InfoLine(icon: Icons.person_outline, value: order.customerName),
          const SizedBox(height: 5),
          _InfoLine(icon: Icons.phone_outlined, value: order.phoneNumber),
          const SizedBox(height: 5),
          _InfoLine(icon: Icons.place_outlined, value: order.deliveryLocation),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _MetaPill(label: order.orderType, color: AppColors.softGold),
              _MetaPill(
                label: order.paymentMethod,
                color: AppColors.coffeeBrown,
              ),
              _MetaPill(
                label: "${order.items.length} items",
                color: AppColors.mutedForeground,
              ),
            ],
          ),
          if (order.status == OrderStatus.refundRequested) ...[
            const SizedBox(height: 8),
            _RefundNote(order: order),
          ],
          const SizedBox(height: 10),
          Expanded(child: _OrderItemPreview(items: order.items)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "Php ${order.total.toStringAsFixed(2)}",
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 13,
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

class _OrderItemPreview extends StatelessWidget {
  final List<CartItem> items;

  const _OrderItemPreview({required this.items});

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.take(2).toList();
    final remaining = items.length - visibleItems.length;

    return Column(
      children: [
        for (final item in visibleItems) ...[
          _OrderItemRow(
            image: item.product.image,
            name: item.product.name,
            price: item.product.price,
            quantity: item.quantity,
          ),
          const SizedBox(height: 8),
        ],
        if (remaining > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "+$remaining more items",
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
            ),
          ),
      ],
    );
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
        Icon(icon, size: 14, color: AppColors.mutedForeground),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value.isEmpty ? "Not provided" : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.55)),
      ),
      child: Text(
        label,
        style: AppTextStyles.navItem.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
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
        "Refund reason: ${order.refundReason ?? "No reason"}",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 10,
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
            height: 38,
            width: 38,
            color: AppColors.warmBeige,
            child: AdaptiveImage(path: image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(price, style: AppTextStyles.bodySmall.copyWith(fontSize: 9)),
            ],
          ),
        ),
        Text(
          "x$quantity",
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
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
      height: 32,
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
            fontSize: 10,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.softGold.withValues(alpha: 0.55)),
      ),
      child: Text(
        OrderStatus.label(status),
        style: AppTextStyles.navItem.copyWith(
          fontSize: 10,
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
