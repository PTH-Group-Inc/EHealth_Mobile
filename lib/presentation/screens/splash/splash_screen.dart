import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      useImmersiveMode: true,
      backgroundColor: AppColors.primaryBackground,
      splashScreenBody: const _AnimatedSplashBody(),
      duration: const Duration(milliseconds: 3500),
      nextScreen: const _RootDecisionWidget(),
    );
  }
}

class _AnimatedSplashBody extends StatefulWidget {
  const _AnimatedSplashBody();

  @override
  State<_AnimatedSplashBody> createState() => _AnimatedSplashBodyState();
}

class _AnimatedSplashBodyState extends State<_AnimatedSplashBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _iconMoveAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textMoveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Phase 1: Scale up (0.0 to 1.0 of the duration)
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    // Phase 2: Move icon up (0.5 to 0.8 of the duration)
    _iconMoveAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.5)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 0.9, curve: Curves.easeInOutCubic),
          ),
        );

    // Phase 2: Text fades in and moves down (0.6 to 1.0 of the duration)
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeIn),
      ),
    );

    _textMoveAnimation =
        Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: const Offset(0, 0.3),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Text "EHealth" that slides down from behind the icon
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FractionalTranslation(
                translation: _textMoveAnimation.value,
                child: Opacity(
                  opacity: _textOpacityAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        "EHealth",
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightAqua,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Icon that scales up and then moves up
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FractionalTranslation(
                translation: _iconMoveAnimation.value,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(25),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      image: const DecorationImage(
                        image: AssetImage("assets/icon-1024x1024.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RootDecisionWidget extends StatefulWidget {
  const _RootDecisionWidget();

  @override
  State<_RootDecisionWidget> createState() => _RootDecisionWidgetState();
}

class _RootDecisionWidgetState extends State<_RootDecisionWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
