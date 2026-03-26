import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';

class HomeNotificationScreen extends StatefulWidget {
  const HomeNotificationScreen({super.key});

  @override
  State<HomeNotificationScreen> createState() => _HomeNotificationScreenState();
}

class _HomeNotificationScreenState extends State<HomeNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return AppRefresh(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thông báo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(50, 50, 93, 0.25),
                  blurRadius: 5,
                  spreadRadius: -1,
                  offset: Offset(0, 2),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  blurRadius: 3,
                  spreadRadius: -1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 50,
                  color: AppColors.primary,
                ),
                SizedBox(height: 10),
                const Text(
                  "Hiện tại bạn chưa có thông báo nào",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const Text(
                  "Chúng tôi sẽ thông báo cho bạn khi có cập nhật mới",
                  style: const TextStyle(fontSize: 16, color: AppColors.textDark),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 120),
      ],
    ),
  ),
);
  }
}
