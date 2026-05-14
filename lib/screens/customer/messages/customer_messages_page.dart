import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../widgets/bottom_nav.dart';
import '../cart/cart_page.dart';
import '../favorites/favorites_page.dart';
import '../home/user_mobile_home.dart';
import '../profile/profile_page.dart';

class CustomerMessagesPage extends StatelessWidget {
  const CustomerMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final threads = _customerThreads;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        bottom: false,
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
                  return _MessageThreadCard(thread: thread);
                },
              ),
            ),
            CustomerBottomNav(
              activeItem: CustomerNavItem.messages,
              onHomeTap: () => _openRoot(context, const UserMobileHome()),
              onFavoritesTap: () => _openRoot(context, const FavoritesPage()),
              onCartTap: () => _pushPage(context, const CartPage()),
              onProfileTap: () => _pushPage(context, const ProfilePage()),
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
              return;
            }

            _openRoot(context, const UserMobileHome());
          },
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            "Messages",
            style: TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
        _IconCircleButton(icon: Icons.tune_rounded, onTap: () {}),
      ],
    );
  }

  void _openRoot(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _MessageThreadCard extends StatelessWidget {
  final _MessageThread thread;

  const _MessageThreadCard({required this.thread});

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

class _MessageThread {
  final String title;
  final String preview;
  final String time;
  final String tag;
  final int unreadCount;
  final IconData icon;
  final Color accent;

  const _MessageThread({
    required this.title,
    required this.preview,
    required this.time,
    required this.tag,
    required this.unreadCount,
    required this.icon,
    required this.accent,
  });
}

const _customerThreads = [
  _MessageThread(
    title: "Quezel Support",
    preview: "Order help: We can swap toppings before your order ships.",
    time: "10:28 AM",
    tag: "Support",
    unreadCount: 2,
    icon: Icons.headset_mic_outlined,
    accent: AppColors.coffeeBrown,
  ),
  _MessageThread(
    title: "Delivery Updates",
    preview: "Status: Rider is on the way with Order QZL-1182.",
    time: "9:12 AM",
    tag: "Order",
    unreadCount: 1,
    icon: Icons.local_shipping_outlined,
    accent: AppColors.softGold,
  ),
  _MessageThread(
    title: "New Promos",
    preview: "Try the Mais Con Yelo bundle with the new toppings.",
    time: "Yesterday",
    tag: "Promo",
    unreadCount: 0,
    icon: Icons.local_offer_outlined,
    accent: AppColors.mutedForeground,
  ),
  _MessageThread(
    title: "Favorites Reminder",
    preview: "Your saved Halo-Halo looks ready for another order.",
    time: "Mon",
    tag: "Tips",
    unreadCount: 0,
    icon: Icons.favorite_border_rounded,
    accent: AppColors.coffeeBrown,
  ),
];
