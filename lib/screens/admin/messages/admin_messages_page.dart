import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AdminMessagesPage extends StatelessWidget {
  const AdminMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = _adminThreads;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: _topBar(context),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                itemCount: threads.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final thread = threads[index];
                  return _AdminThreadCard(thread: thread);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        _IconCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            "Admin Messages",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
        _IconCircleButton(icon: Icons.search_rounded, onTap: () {}),
      ],
    );
  }
}

class _AdminThreadCard extends StatelessWidget {
  final _AdminThread thread;

  const _AdminThreadCard({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.softGold.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ThreadAvatar(icon: thread.icon, accent: thread.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        thread.title,
                        style: const TextStyle(
                          fontFamily: AppFonts.poppins,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkEspresso,
                        ),
                      ),
                    ),
                    Text(
                      thread.time,
                      style: const TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  thread.preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 13,
                    color: AppColors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _ThreadTag(label: thread.tag, color: thread.accent),
                    if (thread.unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      _UnreadBadge(count: thread.unreadCount),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreadAvatar extends StatelessWidget {
  final IconData icon;
  final Color accent;

  const _ThreadAvatar({required this.icon, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: accent.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: accent.withOpacity(0.7)),
      ),
      child: Icon(icon, size: 22, color: accent),
    );
  }
}

class _ThreadTag extends StatelessWidget {
  final String label;
  final Color color;

  const _ThreadTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withOpacity(0.8)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;

  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.coffeeBrown,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        count > 99 ? "99+" : count.toString(),
        style: const TextStyle(
          fontFamily: AppFonts.poppins,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.softGold.withOpacity(0.45)),
        ),
        child: Icon(icon, size: 20, color: AppColors.darkEspresso),
      ),
    );
  }
}

class _AdminThread {
  final String title;
  final String preview;
  final String time;
  final String tag;
  final int unreadCount;
  final IconData icon;
  final Color accent;

  const _AdminThread({
    required this.title,
    required this.preview,
    required this.time,
    required this.tag,
    required this.unreadCount,
    required this.icon,
    required this.accent,
  });
}

const _adminThreads = [
  _AdminThread(
    title: "Order Alerts",
    preview: "New order: QZL-1189 needs approval.",
    time: "11:02 AM",
    tag: "Orders",
    unreadCount: 3,
    icon: Icons.receipt_long_outlined,
    accent: AppColors.coffeeBrown,
  ),
  _AdminThread(
    title: "Inventory",
    preview: "Low stock: Ube leche topping at 6 units.",
    time: "10:21 AM",
    tag: "Inventory",
    unreadCount: 1,
    icon: Icons.inventory_2_outlined,
    accent: AppColors.softGold,
  ),
  _AdminThread(
    title: "Customer Issues",
    preview: "Refund review: Order QZL-1168 pending.",
    time: "Yesterday",
    tag: "Support",
    unreadCount: 0,
    icon: Icons.support_agent_outlined,
    accent: AppColors.mutedForeground,
  ),
  _AdminThread(
    title: "Rider Updates",
    preview: "Tablon: 4 deliveries completed this morning.",
    time: "Mon",
    tag: "Riders",
    unreadCount: 0,
    icon: Icons.directions_bike_outlined,
    accent: AppColors.softGold,
  ),
];
