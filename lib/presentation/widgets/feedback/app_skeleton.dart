import 'package:e_health/domain/avatar.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/presentation/screens/speciality/widgets/specialty_card.dart';
import 'package:e_health/presentation/widgets/data_display/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DoctorListSkeleton extends StatelessWidget {
  final int itemCount;
  const DoctorListSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final dummyDoctor = Doctor(
      userId: "1",
      fullName: "Bác sĩ Nguyễn Văn A",
      title: "Bác sĩ chuyên khoa II",
      specialtyName: "Chuyên khoa Nội tổng quát",
      phone: "0123456789",
      avatarUrl: [Avatar(url: "", publicId: "dummy")],
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DoctorCard(doctor: dummyDoctor),
        ),
      ),
    );
  }
}

class SpecialityListSkeleton extends StatelessWidget {
  final int itemCount;
  const SpecialityListSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    final dummyDepartment = Department(
      departmentsId: "1",
      name: "Khoa Nội tổng quát",
      code: "KNTQ",
      description: "Mô tả chi tiết về chuyên khoa này sẽ được hiển thị tại đây để người dùng có cái nhìn tổng quan.",
      branchName: "Bệnh viện Đa khoa Trung ương",
      logoUrl: "",
    );

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
        itemCount: itemCount,
        itemBuilder: (context, index) => SpecialtyCard(department: dummyDepartment),
      ),
    );
  }
}
