import 'package:flutter/foundation.dart';

import 'delivery_location_service.dart';

class UserAddressService extends ChangeNotifier {
  static final UserAddressService instance = UserAddressService._internal();

  UserAddressService._internal();

  String phoneNumber = "";
  String barangayAddress =
      DeliveryLocationService.instance.selectedLocation.name;
  String postalCode = "";
  String streetAddress = "";
  bool isDefaultAddress = true;
  String labelAs = "Home";

  bool get hasCompleteAddress {
    return phoneNumber.trim().isNotEmpty &&
        postalCode.trim().isNotEmpty &&
        streetAddress.trim().isNotEmpty;
  }

  String get locationSummary {
    final location = DeliveryLocationService.instance.selectedLocation;
    final distance = location.km % 1 == 0
        ? location.km.toStringAsFixed(0)
        : location.km.toStringAsFixed(1);

    return "${location.name} \u2022 $distance km \u2022 \u20B1${location.fee.toStringAsFixed(0)}";
  }

  String get fullAddress {
    final parts = [
      streetAddress.trim(),
      barangayAddress.trim(),
      postalCode.trim(),
    ].where((part) => part.isNotEmpty).toList();

    return parts.isEmpty ? barangayAddress : parts.join(", ");
  }

  String get profileSummary {
    if (!hasCompleteAddress) return locationSummary;

    return "$labelAs \u2022 $fullAddress";
  }

  String get checkoutSummary {
    if (!hasCompleteAddress) return barangayAddress;

    return "$fullAddress \u2022 $phoneNumber";
  }

  void updateAddress({
    required String phoneNumber,
    required String barangayAddress,
    required String postalCode,
    required String streetAddress,
    required bool isDefaultAddress,
    required String labelAs,
  }) {
    this.phoneNumber = phoneNumber;
    this.barangayAddress = barangayAddress;
    this.postalCode = postalCode;
    this.streetAddress = streetAddress;
    this.isDefaultAddress = isDefaultAddress;
    this.labelAs = labelAs;

    notifyListeners();
  }
}
