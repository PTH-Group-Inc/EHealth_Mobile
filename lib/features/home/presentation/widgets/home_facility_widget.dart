import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/dio_client.dart';

class HomeFacilityWidget extends StatefulWidget {
  const HomeFacilityWidget({super.key});

  @override
  State<HomeFacilityWidget> createState() => _HomeFacilityWidgetState();
}

class _HomeFacilityWidgetState extends State<HomeFacilityWidget> {
  List listPokemon = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      // Khởi tạo DioClient
      final Dio dioClient = DioClient().dio;

      final response = await dioClient.get('/products');

      setState(() {
        listPokemon = response.data;
      });

      print(listPokemon);
    } catch (e) {
      debugPrint("Lỗi tải sản phẩm: $e");
    }
  }

  String baseUrl = '${dotenv.env['BASE_URL']}/';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      // color: Colors.red,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cơ sở y tế",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3c81c6),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/all-facility'),
                child: Text(
                  "Xem tất cả >>",
                  style: TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                    color: Color(0xFF3c81c6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listPokemon.length,
              itemBuilder: (context, index) {
                final listPokeIndex = listPokemon[index];
                return Container(
                  width: 300,
                  padding: const EdgeInsets.only(right: 5),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(width: 1.4, color: Color(0xFFcce5f9)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: CachedNetworkImage(
                                    width: 50,
                                    height: 50,
                                    imageUrl: "$baseUrl${listPokeIndex["HinhAnhDaiDienSP"]}",
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  listPokeIndex['TenSanPham'],
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsetsGeometry.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFfefce8),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color(0xFFeab308),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      color: Color(0xFFeab308),
                                      Icons.star_outlined,
                                      size: 16,
                                    ),
                                    Text(
                                      '${listPokeIndex["Rating"]} (1.8k)',
                                      style: TextStyle(
                                        color: Color(0xFFeab308),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsetsGeometry.all(8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF63acf5),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
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
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
