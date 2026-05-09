import 'package:flutter/foundation.dart';
import 'delivery_location_service.dart';

class UserAddressService extends ChangeNotifier {
  static final UserAddressService instance = UserAddressService._internal();

  UserAddressService._internal();

  String phoneNumber = "";
  String barangayAddress = DeliveryLocationService.instance.selectedLocation.name;
  String postalCode = "";
  String streetAddress = "";
  bool isDefaultAddress = true;
  String labelAs = "Home";

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