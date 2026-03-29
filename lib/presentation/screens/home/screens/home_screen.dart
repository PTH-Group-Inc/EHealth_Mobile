import '../../../widgets/feedback/app_refresh.dart';
import '../widgets/home_specialties_widget.dart';
import '../widgets/home_news_widget.dart';
import '../../../widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';

import '../widgets/home_menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int refreshFacility = 0;

  Future<void> _reloadData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Delay refresh
    setState(() {
      refreshFacility++; // Load lại sản phẩm
      debugPrint("Dữ liệu đã reload hehehe");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppRefresh(
      onRefresh: _reloadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeMenuWidget(),
            SizedBox(height: 10),
            HomeSpecialtiesWidget(key: ValueKey(refreshFacility)),
            GestureDetector(
              onTap: () {
                AppToast.showInfo(context, "Tính năng đang được xây dựng");
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Image(
                  image: NetworkImage(
                    'https://i.postimg.cc/DfMV9TTm/image.png',
                  ),
                ),
              ),
            ),
            HomeNewsWidget(),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
