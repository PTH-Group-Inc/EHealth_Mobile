import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      useImmersiveMode: true,
      backgroundColor: AppColors.white,
      childWidget: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: Colors.white, width: 2),
          image: const DecorationImage(
            image: AssetImage("assets/icon-1024x1024.png"),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 2000),
      animationDuration: const Duration(milliseconds: 1000),
      onAnimationEnd: () {
        debugPrint("On Scale End");
      },
      nextScreen: const _RootDecisionWidget(),
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
    // Use a post frame callback to let GoRouter handle the redirection logic
    // defined in route_manager.dart by navigating to root.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
