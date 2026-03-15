import 'package:e_health/features/home/presentation/widgets/home_facility_widget.dart';
import 'package:e_health/features/home/presentation/widgets/home_news_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      print("Dữ liệu đã reload hehehe");
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reloadData,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HomeMenuWidget(),
            SizedBox(height: 10),
            HomeFacilityWidget(key: ValueKey(refreshFacility)),
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Tính năng này đang được xây dựng",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Color(0xFFd2f5fc),
                  textColor: Color(0xFF3c81c6),
                  fontSize: 16.0,
                );
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Image(
                  image: NetworkImage(
                    'https://cdn.discordapp.com/attachments/1154654203751432248/1461302051752513546/image.png?ex=6975ec96&is=69749b16&hm=a956cb8abb0af2fabe7731c17f59cc78cad4853888c0f6ed420b690279fc74dd',
                  ),
                ),
              ),
            ),
            HomeNewsWidget(),
          ],
        ),
      ),
    );
  }
}
