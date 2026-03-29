import 'package:flutter/material.dart';

class AppShadow {
  /// Soft shadow for cards and containers
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ];

  /// More subtle shadow for input fields
  static List<BoxShadow> get inputShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ];

  /// Deeper shadow for floating elements or focused states
  static List<BoxShadow> get floatingShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
      
  /// Multi-layer dynamic shadow used in some historical parts
  static List<BoxShadow> get deepShadow => [
        BoxShadow(
          color: const Color.fromRGBO(50, 50, 93, 0.25),
          blurRadius: 5,
          spreadRadius: -1,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.3),
          blurRadius: 3,
          spreadRadius: -1,
          offset: const Offset(0, 1),
        ),
      ];
}
