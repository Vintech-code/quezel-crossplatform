import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/delivery_location_service.dart';
import '../../../core/services/user_address_service.dart';
import '../../../models/delivery_location.dart';

class DeliveryAddressPage extends StatefulWidget {
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  final locationService = DeliveryLocationService.instance;
  final addressService = UserAddressService.instance;

  late DeliveryLocation selectedLocation;

  final phoneController = TextEditingController();
  final postalController = TextEditingController();
  final streetController = TextEditingController();

  bool isDefault = true;
  String labelAs = "Home";

  @override
  void initState() {
    super.initState();

    selectedLocation = locationService.selectedLocation;

    phoneController.text = addressService.phoneNumber;
    postalController.text = addressService.postalCode;
    streetController.text = addressService.streetAddress;
    isDefault = addressService.isDefaultAddress;
    labelAs = addressService.labelAs;
  }

  @override
  void dispose() {
    phoneController.dispose();
    postalController.dispose();
    streetController.dispose();
    super.dispose();
  }

  void saveAddress() {
    locationService.setLocation(selectedLocation);

    addressService.updateAddress(
      phoneNumber: phoneController.text.trim(),
      barangayAddress: selectedLocation.name,
      postalCode: postalController.text.trim(),
      streetAddress: streetController.text.trim(),
      isDefaultAddress: isDefault,
      labelAs: labelAs,
    );

    Navigator.pop(context);
  }

  String formatKm(double km) {
    return km % 1 == 0 ? km.toStringAsFixed(0) : km.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _topBar(context),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontFamily: AppFonts.righteous,
                        fontSize: 32,
                        color: AppColors.darkEspresso,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Set your delivery location and complete address details.",
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 14,
                        color: AppColors.mutedForeground,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _section(
                      title: "Choose Location",
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.softGold.withOpacity(0.35),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<DeliveryLocation>(
                            value: selectedLocation,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            style: const TextStyle(
                              fontFamily: AppFonts.poppins,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkEspresso,
                            ),
                            items: locationService.locations.map((location) {
                              return DropdownMenuItem<DeliveryLocation>(
                                value: location,
                                child: Text(
                                  "${location.name} • ${formatKm(location.km)} km • ₱${location.fee.toStringAsFixed(0)}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (location) {
                              if (location == null) return;

                              setState(() {
                                selectedLocation = location;
                              });
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    _section(
                      title: "Address Details",
                      child: Column(
                        children: [
                          _TextInput(
                            label: "Phone Number",
                            hint: "09XXXXXXXXX",
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 12),
                          _TextInput(
                            label: "Postal Code",
                            hint: "Example: 9000",
                            controller: postalController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          _TextInput(
                            label: "Street Name / Building / House No.",
                            hint: "Enter complete address",
                            controller: streetController,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    _section(
                      title: "Address Settings",
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Set as default address",
                                  style: TextStyle(
                                    fontFamily: AppFonts.poppins,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkEspresso,
                                  ),
                                ),
                              ),
                              Switch(
                                value: isDefault,
                                activeColor: AppColors.coffeeBrown,
                                onChanged: (value) {
                                  setState(() {
                                    isDefault = value;
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Label as:",
                              style: TextStyle(
                                fontFamily: AppFonts.poppins,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkEspresso,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              _LabelChip(
                                label: "Home",
                                active: labelAs == "Home",
                                onTap: () {
                                  setState(() {
                                    labelAs = "Home";
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              _LabelChip(
                                label: "Work",
                                active: labelAs == "Work",
                                onTap: () {
                                  setState(() {
                                    labelAs = "Work";
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.coffeeBrown,
                      foregroundColor: AppColors.creamWhite,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "SAVE ADDRESS",
                      style: TextStyle(
                        fontFamily: AppFonts.poppins,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
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
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.darkEspresso,
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Address",
              style: TextStyle(
                fontFamily: AppFonts.poppins,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.darkEspresso,
              ),
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }

  Widget _section({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGold.withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppFonts.poppins,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: AppColors.darkEspresso,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _TextInput({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.darkEspresso,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.softGold.withOpacity(0.35),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.coffeeBrown,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _LabelChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.coffeeBrown : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? AppColors.coffeeBrown
                : AppColors.softGold.withOpacity(0.35),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.poppins,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: active ? Colors.white : AppColors.darkEspresso,
          ),
        ),
      ),
    );
  }
}