import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> diffuse = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 64,
      offset: const Offset(0, 24),
    ),
  ];

  static List<BoxShadow> diffuseLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.18),
      blurRadius: 48,
      offset: const Offset(0, 16),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.20),
      blurRadius: 96,
      offset: const Offset(0, 40),
    ),
  ];
}
