import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class RiderMessagesPage extends StatelessWidget {
  const RiderMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = _riderThreads;

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
                  return _RiderThreadCard(thread: thread);
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
            "Rider Messages",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
        _IconCircleButton(icon: Icons.notifications_outlined, onTap: () {}),
      ],
    );
  }
}

class _RiderThreadCard extends StatelessWidget {
  final _RiderThread thread;

  const _RiderThreadCard({required this.thread});

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

class _RiderThread {
  final String title;
  final String preview;
  final String time;
  final String tag;
  final int unreadCount;
  final IconData icon;
  final Color accent;

  const _RiderThread({
    required this.title,
    required this.preview,
    required this.time,
    required this.tag,
    required this.unreadCount,
    required this.icon,
    required this.accent,
  });
}

const _riderThreads = [
  _RiderThread(
    title: "Dispatch",
    preview: "New assignment: Pick up order QZL-1194 in 12 mins.",
    time: "11:20 AM",
    tag: "Pickup",
    unreadCount: 2,
    icon: Icons.flag_outlined,
    accent: AppColors.coffeeBrown,
  ),
  _RiderThread(
    title: "Customer Notes",
    preview: "Delivery note: Leave at the guard house.",
    time: "10:41 AM",
    tag: "Delivery",
    unreadCount: 1,
    icon: Icons.delivery_dining_outlined,
    accent: AppColors.softGold,
  ),
  _RiderThread(
    title: "Route Updates",
    preview: "Traffic alert: Use the southern access road.",
    time: "Yesterday",
    tag: "Route",
    unreadCount: 0,
    icon: Icons.alt_route_outlined,
    accent: AppColors.mutedForeground,
  ),
  _RiderThread(
    title: "Completed",
    preview: "You completed 8 drops today. Great job.",
    time: "Mon",
    tag: "Summary",
    unreadCount: 0,
    icon: Icons.verified_outlined,
    accent: AppColors.softGold,
  ),
];
