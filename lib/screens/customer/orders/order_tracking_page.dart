import 'package:flutter/material.dart';

import '../../../core/services/order_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../widgets/customer_icon_button.dart';
import '../widgets/customer_top_bar.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final orderService = OrderService.instance;
  final refundNotesController = TextEditingController();

  String selectedReason = "Wrong or missing item";
  bool hasProofPlaceholder = false;

  final refundReasons = const [
    "Wrong or missing item",
    "Damaged item",
    "Order arrived late",
    "Payment concern",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    orderService.addListener(_refresh);
  }

  @override
  void dispose() {
    orderService.removeListener(_refresh);
    refundNotesController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Order? get order {
    for (final item in orderService.orders) {
      if (item.id == widget.orderId) return item;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentOrder = order;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              CustomerTopBar(
                leading: CustomerIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                title: "Tracking",
                trailing: const SizedBox(width: 44, height: 44),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: currentOrder == null
                    ? const Center(child: Text("Order not found"))
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 20),
                        children: [
                          _TrackingHeader(order: currentOrder),
                          const SizedBox(height: 12),
                          _TimelineCard(status: currentOrder.status),
                          const SizedBox(height: 12),
                          _ItemsCard(order: currentOrder),
                          const SizedBox(height: 12),
                          if (_canRequestRefund(currentOrder.status))
                            _RefundRequestCard(
                              reasons: refundReasons,
                              selectedReason: selectedReason,
                              notesController: refundNotesController,
                              hasProofPlaceholder: hasProofPlaceholder,
                              onReasonChanged: (value) {
                                if (value == null) return;
                                setState(() => selectedReason = value);
                              },
                              onProofChanged: (value) {
                                setState(() => hasProofPlaceholder = value);
                              },
                              onSubmit: () => _submitRefund(currentOrder),
                            ),
                          if (OrderStatus.refundStatuses.contains(
                            currentOrder.status,
                          ))
                            _RefundStatusCard(order: currentOrder),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _canRequestRefund(String status) {
    return status == OrderStatus.delivered ||
        status == OrderStatus.cancelled ||
        status == OrderStatus.refundRejected;
  }

  void _submitRefund(Order order) {
    orderService.requestRefund(
      order.id,
      reason: selectedReason,
      notes: refundNotesController.text.trim(),
      hasProofPlaceholder: hasProofPlaceholder,
    );
  }
}

class _TrackingHeader extends StatelessWidget {
  final Order order;

  const _TrackingHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    return _TrackingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.id,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 10),
          _InfoLine(label: "Name", value: order.customerName),
          _InfoLine(label: "Phone", value: order.phoneNumber),
          _InfoLine(label: "Address", value: order.deliveryLocation),
          _InfoLine(label: "Payment", value: order.paymentMethod),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final String status;

  const _TimelineCard({required this.status});

  @override
  Widget build(BuildContext context) {
    const steps = [
      OrderStatus.pending,
      OrderStatus.accepted,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
      OrderStatus.cancelled,
      OrderStatus.refundRequested,
      OrderStatus.refundApproved,
      OrderStatus.refundRejected,
    ];
    final currentIndex = steps.indexOf(status);

    return _TrackingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Timeline",
            style: AppTextStyles.navItem.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          ...steps.map((step) {
            final index = steps.indexOf(step);
            final isActive = currentIndex >= index && currentIndex >= 0;
            final isCurrent = step == status;
            return _TimelineStep(
              label: OrderStatus.label(step),
              active: isActive,
              current: isCurrent,
              isLast: index == steps.length - 1,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final String label;
  final bool active;
  final bool current;
  final bool isLast;

  const _TimelineStep({
    required this.label,
    required this.active,
    required this.current,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.coffeeBrown : AppColors.mutedForeground;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              active ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 19,
              color: color,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: color.withValues(alpha: active ? 0.35 : 0.16),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              current ? "$label - current" : label,
              style: AppTextStyles.navItem.copyWith(
                fontSize: 13,
                fontWeight: current ? FontWeight.w900 : FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final Order order;

  const _ItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _TrackingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Items",
            style: AppTextStyles.navItem.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(item.product.name)),
                  Text("x${item.quantity}"),
                ],
              ),
            ),
          ),
          const Divider(),
          _InfoLine(
            label: "Total",
            value: "Php ${order.total.toStringAsFixed(2)}",
            strong: true,
          ),
        ],
      ),
    );
  }
}

class _RefundRequestCard extends StatelessWidget {
  final List<String> reasons;
  final String selectedReason;
  final TextEditingController notesController;
  final bool hasProofPlaceholder;
  final ValueChanged<String?> onReasonChanged;
  final ValueChanged<bool> onProofChanged;
  final VoidCallback onSubmit;

  const _RefundRequestCard({
    required this.reasons,
    required this.selectedReason,
    required this.notesController,
    required this.hasProofPlaceholder,
    required this.onReasonChanged,
    required this.onProofChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return _TrackingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Request Refund",
            style: AppTextStyles.navItem.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedReason,
            items: reasons
                .map(
                  (reason) =>
                      DropdownMenuItem(value: reason, child: Text(reason)),
                )
                .toList(),
            onChanged: onReasonChanged,
            decoration: const InputDecoration(labelText: "Reason"),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Notes (optional)",
              border: OutlineInputBorder(),
            ),
          ),
          CheckboxListTile(
            value: hasProofPlaceholder,
            onChanged: (value) => onProofChanged(value ?? false),
            contentPadding: EdgeInsets.zero,
            title: const Text("Add proof image placeholder"),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.coffeeBrown,
                foregroundColor: Colors.white,
              ),
              child: const Text("Submit Refund Request"),
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundStatusCard extends StatelessWidget {
  final Order order;

  const _RefundStatusCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return _TrackingCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBadge(status: order.status),
          const SizedBox(height: 10),
          _InfoLine(label: "Reason", value: order.refundReason ?? "Not set"),
          _InfoLine(label: "Notes", value: order.refundNotes ?? "None"),
          _InfoLine(
            label: "Proof",
            value: order.hasRefundProofPlaceholder
                ? "Placeholder added"
                : "None",
          ),
        ],
      ),
    );
  }
}

class _TrackingCard extends StatelessWidget {
  final Widget child;

  const _TrackingCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.softGold.withValues(alpha: 0.45)),
      ),
      child: child,
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;

  const _InfoLine({
    required this.label,
    required this.value,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.navItem.copyWith(
                fontSize: strong ? 15 : 12,
                fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        OrderStatus.label(status),
        style: AppTextStyles.navItem.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
