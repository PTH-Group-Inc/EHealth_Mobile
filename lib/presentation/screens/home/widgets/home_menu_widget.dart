import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeMenuWidget extends StatelessWidget {
  const HomeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color iconBackgroundColor = Color.fromARGB(255, 226, 247, 252);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Đặt lịch khám
              GestureDetector(
                onTap: () => context.pushNamed('all-branch'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppShadow.cardShadow,
                      ),
                      child: const Image(
                        image: AssetImage(
                          "assets/calendar-year-month-date-health-schedule-hospital-svgrepo-com.png",
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Đặt lịch\nkhám',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Lịch sử khám bệnh
              GestureDetector(
                onTap: () => AppToast.showInfo(
                  context,
                  "Tính năng đang được phát triển",
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppShadow.cardShadow,
                      ),
                      child: const Image(
                        image: AssetImage(
                          "assets/clipboard-note-paper-document-hospital-result-medical-svgrepo-com.png",
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Lịch sử\nkhám bệnh',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Nhắc nhở thuốc
              GestureDetector(
                onTap: () => AppToast.showInfo(
                  context,
                  "Tính năng đang được phát triển",
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppShadow.cardShadow,
                      ),
                      child: const Image(
                        image: AssetImage(
                          "assets/medicine-herbal-natural-medical-drug-leaf-health-svgrepo-com.png",
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Nhắc nhở\nthuốc',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Gói chăm sóc toàn diện
              GestureDetector(
                onTap: () => AppToast.showInfo(
                  context,
                  "Tính năng đang được phát triển",
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppShadow.cardShadow,
                      ),
                      child: const Image(
                        image: AssetImage(
                          'assets/medical-health-care-doctor-hospital-medicine-healthcare-svgrepo-com.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gói chăm sóc\ntoàn diện',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
