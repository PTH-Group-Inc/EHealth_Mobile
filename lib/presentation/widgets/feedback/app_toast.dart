import 'dart:async';
import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';

class AppToast {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void showSuccess(BuildContext context, String message) {
    _showTopToast(
      context,
      message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(BuildContext context, String message) {
    _showTopToast(
      context,
      message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_outline,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showTopToast(
      context,
      message,
      backgroundColor: AppColors.textDark,
      icon: Icons.info_outline,
    );
  }

  static void _showTopToast(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    // Cancel existing timer and remove existing overlay if any
    _timer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => _TopToastWidget(
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
        onDismiss: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );

    overlay.insert(_overlayEntry!);

    _timer = Timer(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}

class _TopToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onDismiss;

  const _TopToastWidget({
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Auto dismiss after duration
    Future.delayed(const Duration(milliseconds: 2700), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _offsetAnimation.value),
              child: child,
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(widget.icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
