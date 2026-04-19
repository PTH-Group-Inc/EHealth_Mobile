import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;
  final double? height;
  final bool isCompact;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionLabel,
    this.height,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.all(isCompact ? 12 : 20),
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 0 : 16,
        vertical: isCompact ? 0 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isCompact ? 20 : 28),
        boxShadow: isCompact ? null : AppShadow.cardShadow,
        border: Border.all(
          color: AppColors.primaryBorder.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isCompact ? 16 : 24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: isCompact ? 32 : 56,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: isCompact ? 12 : 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompact ? 16 : 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textHeader,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: isCompact ? 4 : 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 14,
                  color: AppColors.textSlate,
                  height: isCompact ? 1.3 : 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onAction != null && actionLabel != null) ...[
                SizedBox(height: isCompact ? 16 : 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: isCompact ? 12 : 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
                      ),
                    ),
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: isCompact ? 13 : 15,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
