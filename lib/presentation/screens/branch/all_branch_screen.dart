import '../../widgets/feedback/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_color.dart';
import '../../../app/theme/app_shadow.dart';
import '../../../domain/branch.dart';
import 'cubit/all_branch_cubit.dart';
import 'cubit/all_branch_state.dart';
import '../../widgets/feedback/empty_state_widget.dart';

class AllBranchScreen extends StatefulWidget {
  const AllBranchScreen({super.key});

  @override
  State<AllBranchScreen> createState() => _AllBranchScreenState();
}

class _AllBranchScreenState extends State<AllBranchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllBranchCubit>().loadBranches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: AppColors.textHeader,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(color: AppColors.background),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cơ sở y tế",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textHeader,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Vui lòng chọn chi nhánh gần bạn nhất",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSlate.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
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
                        child: EmptyStateWidget(
                          icon: Icons.error_outline_rounded,
                          title: "Đã xảy ra lỗi",
                          subtitle: state.message,
                          onAction: () => context.read<AllBranchCubit>().loadBranches(),
                          actionLabel: "Thử lại",
                        ),
                      );
                    }
                    if (state is AllBranchLoaded) {
                      final branches = state.branches;
                      if (branches.isEmpty) {
                        return const SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: EmptyStateWidget(
                            icon: Icons.location_off_rounded,
                            title: "Không tìm thấy chi nhánh",
                            subtitle: "Hiện tại hệ thống không tìm thấy chi nhánh nào gần khu vực này.",
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
        border: Border.all(
          color: AppColors.primaryBorder.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: AppShadow.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: branch.logoUrl != null &&
                                branch.logoUrl!.isNotEmpty
                            ? Image.network(
                                branch.logoUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              )
                            : const Icon(
                                Icons.location_on_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branch.name ?? "Tên chi nhánh",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textHeader,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              branch.facilityName ?? "Hệ thống E-Health",
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.map_outlined,
                        color: AppColors.textSlate,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          branch.address ?? "Địa chỉ không xác định",
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_in_talk_outlined,
                        color: AppColors.textSlate,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        branch.phone ?? "N/A",
                        style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushNamed(
                          'all-specialty',
                          queryParameters: {'branchId': branch.id},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primary.withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Đặt lịch ngay",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
