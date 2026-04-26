import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:e_health/presentation/screens/auth/cubit/auth_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/home_specialty_cubit.dart';
import 'package:e_health/presentation/screens/home/cubit/notification_cubit.dart';
import 'package:e_health/presentation/screens/home/widgets/home_menu_widget.dart';
import 'package:e_health/presentation/screens/home/widgets/home_news_widget.dart';
import 'package:e_health/presentation/screens/home/widgets/home_specialties_widget.dart';
import 'package:e_health/presentation/screens/home/widgets/home_doctors_widget.dart';
import 'package:e_health/presentation/screens/home/cubit/home_doctor_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _reloadData() async {
    await Future.wait([
      context.read<HomeSpecialtyCubit>().loadSpecialties(),
      context.read<NotificationCubit>().loadNotifications(),
      context.read<HomeDoctorCubit>().loadDoctors(),
      context.read<AuthCubit>().checkAuthStatus(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AppRefresh(
      onRefresh: _reloadData,
      child: SingleChildScrollView(
        key: const PageStorageKey('home_scroll_view'),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const HomeMenuWidget(),
            const HomeDoctorsWidget(),
            const SizedBox(height: 10),
            const HomeSpecialtiesWidget(),
            GestureDetector(
              onTap: () {
                AppToast.showInfo(context, "Tính năng đang được xây dựng");
              },
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Image(
                  image: NetworkImage(
                    'https://i.postimg.cc/DfMV9TTm/image.png',
                  ),
                ),
              ),
            ),
            const HomeNewsWidget(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
