import 'package:flutter/foundation.dart';

class UserProfileService extends ChangeNotifier {
  static final UserProfileService instance = UserProfileService._internal();

  UserProfileService._internal();

  String fullName = "Quezel Customer";
  String email = "customer@quezel.app";

  String get initials {
    final parts = fullName
        .trim()
        .split(RegExp(r"\s+"))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return "QC";
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();

    return "${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}"
        .toUpperCase();
  }

  void updateProfile({
    required String fullName,
    required String email,
  }) {
    this.fullName =
        fullName.trim().isEmpty ? "Quezel Customer" : fullName.trim();
    this.email = email.trim().isEmpty ? "customer@quezel.app" : email.trim();
    notifyListeners();
  }
}
