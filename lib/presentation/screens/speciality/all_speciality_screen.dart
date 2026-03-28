import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import '../../../../domain/department.dart';
import 'cubit/all_speciality_cubit.dart';
import 'cubit/all_speciality_state.dart';

class AllSpecialityScreen extends StatefulWidget {
  final String? branchId;

  const AllSpecialityScreen({super.key, this.branchId});

  @override
  State<AllSpecialityScreen> createState() => _AllSpecialityScreenState();
}

class _AllSpecialityScreenState extends State<AllSpecialityScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AllSpecialityCubit>()..loadDepartments(branchId: widget.branchId),
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
            'Chọn chuyên khoa',
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
                  Text(
                    widget.branchId != null
                        ? "Chuyên khoa tại chi nhánh"
                        : "Tất cả chuyên khoa",
                    style: const TextStyle(
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
                      .read<AllSpecialityCubit>()
                      .loadDepartments(branchId: widget.branchId);
                },
                child: BlocBuilder<AllSpecialityCubit, AllSpecialityState>(
                  builder: (context, state) {
                    if (state is AllSpecialityLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.success,
                        ),
                      );
                    }
                    if (state is AllSpecialityError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is AllSpecialityLoaded) {
                      final departments = state.departments;
                      if (departments.isEmpty) {
                        return const Center(child: Text("Không có dữ liệu"));
                      }
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: departments.length,
                        itemBuilder: (context, index) {
                          return _buildDepartmentCard(departments[index]);
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

  Widget _buildDepartmentCard(Department department) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    department.name ?? "Tên chuyên khoa",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    department.code ?? "N/A",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              department.branchName ?? "Chi nhánh",
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              department.description ?? "Nội dung đang được cập nhật",
              style: const TextStyle(
                color: AppColors.textSlate,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next step or show development toast
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
                    "Chọn",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
