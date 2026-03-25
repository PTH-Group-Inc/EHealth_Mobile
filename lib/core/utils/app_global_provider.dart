import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injection.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/presentation/screens/cubit/navigation_cubit.dart';

class AppGlobalProvider extends StatelessWidget {
  final Widget child;

  const AppGlobalProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => NavigationCubit()),
        // Thêm các Provider khác ở đây khi cần thiết
      ],
      child: child,
    );
  }
}
