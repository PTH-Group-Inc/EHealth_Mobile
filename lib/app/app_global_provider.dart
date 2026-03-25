import 'package:e_health/presentation/screens/auth/cubit/auth_cubit.dart';
import 'package:e_health/presentation/screens/home/screens/cubit/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dependency_injection/configure_injectable.dart';

class AppGlobalProvider extends StatelessWidget {
  final Widget child;

  const AppGlobalProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => NavigationCubit()),
      ],
      child: child,
    );
  }
}
