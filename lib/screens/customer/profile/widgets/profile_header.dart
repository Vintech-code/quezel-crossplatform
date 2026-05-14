import 'package:flutter/material.dart';

import '../../../../core/services/user_profile_service.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  final VoidCallback onEditProfile;

  const ProfileHeader({super.key, required this.onEditProfile});

  @override
  Widget build(BuildContext context) {
    final profileService = UserProfileService.instance;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.softGold.withOpacity(0.45)),
      ),
      child: Row(
        children: [
          Container(
            height: 66,
            width: 66,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.55),
                width: 1.4,
              ),
            ),
            child: Center(
              child: Text(
                profileService.initials,
                style: AppTextStyles.navItem.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.coffeeBrown,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileService.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navItem.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.darkEspresso,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  profileService.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: onEditProfile,
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text("Edit Profile"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkEspresso,
                      side: BorderSide(
                        color: AppColors.softGold.withOpacity(0.55),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: AppTextStyles.navItem.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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
