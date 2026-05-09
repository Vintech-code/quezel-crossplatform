import 'package:flutter/foundation.dart';
import '../../models/delivery_location.dart';

class DeliveryLocationService extends ChangeNotifier {
  static final DeliveryLocationService instance =
      DeliveryLocationService._internal();

  DeliveryLocationService._internal();

  final List<DeliveryLocation> locations = const [
    DeliveryLocation(name: "Baloy", km: 3, fee: 60),
    DeliveryLocation(name: "Kisapat", km: 2, fee: 50),
    DeliveryLocation(name: "Sapong", km: 2, fee: 50),
    DeliveryLocation(name: "Palalan", km: 6, fee: 100),
    DeliveryLocation(name: "Agusan NHS", km: 2, fee: 50),
    DeliveryLocation(name: "Agusan Arca", km: 2.5, fee: 50),
    DeliveryLocation(name: "Agusan Sambulawan", km: 2.5, fee: 50),
    DeliveryLocation(name: "Puerto", km: 4, fee: 70),
    DeliveryLocation(name: "Bugo", km: 5, fee: 80),
    DeliveryLocation(name: "Greenville", km: 6, fee: 90),
    DeliveryLocation(name: "Sambag", km: 7, fee: 100),
    DeliveryLocation(name: "Cugman Merkado", km: 4.5, fee: 70),
    DeliveryLocation(name: "Cugman Chali Beach", km: 5, fee: 80),
    DeliveryLocation(name: "Cugman Bakas Grill", km: 5, fee: 80),
    DeliveryLocation(name: "Cugman G Resort Malasag", km: 11, fee: 150),
    DeliveryLocation(name: "Cugman Nature Spring", km: 5.5, fee: 90),
  ];

  DeliveryLocation _selectedLocation =
      const DeliveryLocation(name: "Baloy", km: 3, fee: 60);

  DeliveryLocation get selectedLocation => _selectedLocation;

  void setLocation(DeliveryLocation location) {
    _selectedLocation = location;
    notifyListeners();
  }
}