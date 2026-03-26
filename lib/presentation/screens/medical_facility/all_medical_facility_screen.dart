import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/domain/medical_facility.dart';
import 'package:e_health/presentation/screens/medical_facility/cubit/all_medical_facility_cubit.dart';
import 'package:e_health/presentation/screens/medical_facility/cubit/all_medical_facility_state.dart';

class AllMedicalFacilityScreen extends StatefulWidget {
  const AllMedicalFacilityScreen({super.key});

  @override
  State<AllMedicalFacilityScreen> createState() =>
      _AllMedicalFacilityScreenState();
}

class _AllMedicalFacilityScreenState extends State<AllMedicalFacilityScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AllMedicalFacilityCubit>()..loadFacilities(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textDark,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Đặt lịch khám',
            style: TextStyle(
              color: AppColors.textDark,
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
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable list
            Expanded(
              child: AppRefresh(
                onRefresh: () async {
                  await context
                      .read<AllMedicalFacilityCubit>()
                      .loadFacilities();
                },
                child:
                    BlocBuilder<
                      AllMedicalFacilityCubit,
                      AllMedicalFacilityState
                    >(
                      builder: (context, state) {
                        if (state is AllMedicalFacilityLoading) {
                          return const SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 500,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is AllMedicalFacilityError) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 500,
                              child: Center(child: Text(state.message)),
                            ),
                          );
                        }
                        if (state is AllMedicalFacilityLoaded) {
                          final facilities = state.facilities;
                          if (facilities.isEmpty) {
                            return const SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: SizedBox(
                                height: 500,
                                child: Center(child: Text("Không có dữ liệu")),
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: facilities.length,
                            itemBuilder: (context, index) {
                              return _buildFacilityCard(facilities[index]);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityCard(MedicalFacility facility) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                child: facility.logoUrl != null && facility.logoUrl!.isNotEmpty
                    ? Image.network(
                        facility.logoUrl!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      )
                    : Container(
                        height: 180,
                        color: Colors.grey[200],
                        width: double.infinity,
                        child: const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
              ),
              // Status Badge
              if (facility.status != null)
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: facility.status == 'ACTIVE'
                          ? AppColors.success
                          : AppColors.textLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      facility.status!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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
                  facility.name ?? "Tên cơ sở y tế",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        facility.headquartersAddress ??
                            "Địa chỉ không xác định",
                        style: const TextStyle(
                          color: AppColors.textSlate,
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
                    // Phone info
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 16,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          facility.phone ?? "N/A",
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    // Action button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
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
}
