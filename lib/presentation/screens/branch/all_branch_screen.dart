import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/domain/branch.dart';
import 'package:e_health/presentation/screens/branch/cubit/all_branch_cubit.dart';
import 'package:e_health/presentation/screens/branch/cubit/all_branch_state.dart';

class AllBranchScreen extends StatefulWidget {
  const AllBranchScreen({super.key});

  @override
  State<AllBranchScreen> createState() => _AllBranchScreenState();
}

class _AllBranchScreenState extends State<AllBranchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AllBranchCubit>()..loadBranches(),
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
            'Chọn chi nhánh',
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
                    "Chi nhánh nổi bật",
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
                  await context.read<AllBranchCubit>().loadBranches();
                },
                child: BlocBuilder<AllBranchCubit, AllBranchState>(
                  builder: (context, state) {
                    if (state is AllBranchLoading) {
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
                    if (state is AllBranchError) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: 500,
                          child: Center(child: Text(state.message)),
                        ),
                      );
                    }
                    if (state is AllBranchLoaded) {
                      final branches = state.branches;
                      if (branches.isEmpty) {
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
                        itemCount: branches.length,
                        itemBuilder: (context, index) {
                          return _buildBranchCard(branches[index]);
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

  Widget _buildBranchCard(Branch branch) {
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
          // Content part
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name ?? "Tên chi nhánh",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  branch.facilityName ?? "Cơ sở y tế",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
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
                        branch.address ?? "Địa chỉ không xác định",
                        style: const TextStyle(
                          color: AppColors.textSlate,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Footer: Phone & Action
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
                          branch.phone ?? "N/A",
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    // Action button
                    ElevatedButton(
                      onPressed: () {
                        context.pushNamed(
                          'all-specialty',
                          queryParameters: {'branchId': branch.id},
                        );
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
