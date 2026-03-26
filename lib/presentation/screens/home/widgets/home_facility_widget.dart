import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeFacilityWidget extends StatefulWidget {
  const HomeFacilityWidget({super.key});

  @override
  State<HomeFacilityWidget> createState() => _HomeFacilityWidgetState();
}

class _HomeFacilityWidgetState extends State<HomeFacilityWidget> {
  // Dữ liệu giả (Mock data)
  final List<Map<String, dynamic>> facilities = [
    {
      'name': 'Bệnh viện Đa khoa Tâm Anh',
      'address': 'Quận Long Biên, Hà Nội',
      'rating': '4.9',
      'image':
          'https://img.freepik.com/premium-photo/modern-hospital-building-hospital-exterior-design-hospital-building-background_662214-4366.jpg',
    },
    {
      'name': 'Phòng khám Đa khoa Clinic',
      'address': 'Quận 7, TP. Hồ Chí Minh',
      'rating': '4.8',
      'image':
          'https://as1.ftcdn.net/v2/jpg/02/11/15/66/1000_F_211156623_6vGf7zVpS6vH4v9Z8v4z7z7z7z7z7z7z.jpg',
    },
    {
      'name': 'Bệnh viện Vinmec',
      'address': 'Quận Hai Bà Trưng, Hà Nội',
      'rating': '5.0',
      'image':
          'https://img.freepik.com/premium-photo/3d-hospital-building-design_670399-52.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 0, top: 5),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cơ sở y tế nổi bật",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.push('/all-facility'),
                  child: const Text(
                    "Xem tất cả",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3c81c6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                final facility = facilities[index];
                return _buildFacilityCard(context, facility);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(
    BuildContext context,
    Map<String, dynamic> facility,
  ) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Color(0xFFF5F5F5)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần hình ảnh và Rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  facility['image'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(Icons.business, color: Colors.grey),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.23),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        facility['rating'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Phần thông tin
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        facility['address'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
