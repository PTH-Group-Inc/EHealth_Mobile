import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:dio/dio.dart';
import 'package:e_health/core/network/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class AllMedicalFacilityScreen extends StatefulWidget {
  const AllMedicalFacilityScreen({super.key});

  @override
  State<AllMedicalFacilityScreen> createState() =>
      _AllMedicalFacilityScreenState();
}

class _AllMedicalFacilityScreenState extends State<AllMedicalFacilityScreen> {
  List<dynamic> allMedicalFacility = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllMedicalFacility();
  }

  void fetchAllMedicalFacility() async {
    try {
      final Dio dio = DioClient().dio;

      final response = await dio.get('/products');

      setState(() {
        allMedicalFacility = response.data;
      });

      print(allMedicalFacility);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf8fafc),
      appBar: AppBar(
        flexibleSpace: Image.asset(
          'assets/360_F_466415129_mTSxvYJ6ugmN2UBv6ZYsxTYdQGj0p2YM.jpg',
          fit: BoxFit.cover,
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back_outlined,
            color: Color(0xFF3c81c6),
            size: 28,
          ),
        ),
        title: Text(
          'Cơ sở y tế',
          style: TextStyle(
            color: Color(0xFF3c81c6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 180,
                ),
                itemCount: allMedicalFacility.length,
                itemBuilder: (context, index) {
                  final allFacilityIndex = allMedicalFacility[index];
                  if (allFacilityIndex == null) {
                    return Text('Đã có lỗi xảy ra');
                  }
                  return Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Color(0xFFcfe6f9)),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${dotenv.env['BASE_URL']}/${allFacilityIndex["HinhAnhDaiDienSP"]}',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error), // Xử lý khi lỗi ảnh
                              ),
                            ),
                            Expanded(
                              child: Column(
                                spacing: 5,
                                children: [
                                  Text(
                                    allFacilityIndex["TenSanPham"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                      ),
                                      Expanded(
                                        child: Text(
                                          allFacilityIndex["GiaBaseSP"]
                                              .toString()
                                              .toVND(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 5,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF63acf5),
                                  ),
                                ),
                                child: Text(
                                  'Xem chi tiết',
                                  style: TextStyle(
                                    color: Color(0xFF63acf5),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF3c81c6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Đặt khám ngay',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
