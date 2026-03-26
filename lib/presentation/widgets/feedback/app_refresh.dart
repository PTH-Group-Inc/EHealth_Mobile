import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';

class AppRefresh extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const AppRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.success,
      backgroundColor: Colors.white,
      child: child,
    );
  }
}
