import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AllMedicalFacilityScreen extends StatefulWidget {
  const AllMedicalFacilityScreen({super.key});

  @override
  State<AllMedicalFacilityScreen> createState() =>
      _AllMedicalFacilityScreenState();
}

class _AllMedicalFacilityScreenState extends State<AllMedicalFacilityScreen> {
  // Dữ liệu giả nâng cao cho Cơ sở y tế
  final List<Map<String, dynamic>> facilities = [
    {
      'name': 'Bệnh viện Đa khoa Quốc tế Vinmec',
      'address': 'Times City, Minh Khai, Hà Nội',
      'rating': '4.9',
      'status': 'ĐANG MỞ CỬA',
      'statusColor': const Color(0xFF2DD4BF),
      'experts': 'Hơn 50 chuyên gia',
      'image':
          'https://img.freepik.com/premium-photo/modern-hospital-building-hospital-exterior-design-hospital-building-background_662214-4366.jpg',
    },
    {
      'name': 'Phòng khám Da liễu Tâm Anh',
      'address': '108 Hoàng Như Tiếp, Long Biên',
      'rating': '4.7',
      'status': 'HẸN TRƯỚC',
      'statusColor': const Color(0xFF94A3B8),
      'experts': 'Chuyên sâu thẩm mỹ',
      'image':
          'https://as1.ftcdn.net/v2/jpg/02/11/15/66/1000_F_211156623_6vGf7zVpS6vH4v9Z8v4z7z7z7z7z7z7z.jpg',
    },
    {
      'name': 'Trung tâm Xét nghiệm Medlatec',
      'address': '42 Nghĩa Dũng, Ba Đình, Hà Nội',
      'rating': '4.8',
      'status': 'ĐANG MỞ CỬA',
      'statusColor': const Color(0xFF2DD4BF),
      'experts': 'Xét nghiệm tại nhà',
      'image':
          'https://img.freepik.com/premium-photo/3d-hospital-building-design_670399-52.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B),
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Cơ sở y tế',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Cơ sở nổi bật",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  "Xem tất cả",
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF2DD4BF).withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Scrollable list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: facilities.length,
              itemBuilder: (context, index) {
                return _buildFacilityCard(facilities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(Map<String, dynamic> facility) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image part with Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.network(
                  facility['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Status Badge
              Positioned(
                bottom: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: facility['statusColor'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    facility['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Rating Badge
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
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
                          fontSize: 13,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content part
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility['name'],
                  style: const TextStyle(
                    fontSize: 18,
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
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        facility['address'],
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Footer: Experts & Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Experts info (Mock)
                    Row(
                      children: [
                        // Stack of avatars (Placeholder)
                        _buildStackAvatars(),
                        const SizedBox(width: 10),
                        Text(
                          facility['experts'],
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    // Action button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2DD4BF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Đặt lịch",
                        style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildStackAvatars() {
    return SizedBox(
      width: 60,
      height: 25,
      child: Stack(
        children: [
          for (int i = 0; i < 3; i++)
            Positioned(
              left: i * 15.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
