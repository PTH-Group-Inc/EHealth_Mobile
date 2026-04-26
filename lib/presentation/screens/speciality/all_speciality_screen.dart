import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/presentation/screens/speciality/cubit/all_speciality_cubit.dart';
import 'package:e_health/presentation/screens/speciality/cubit/all_speciality_state.dart';
import 'package:e_health/presentation/screens/speciality/widgets/specialty_card.dart';

class AllSpecialityScreen extends StatefulWidget {
  final String? branchId;

  const AllSpecialityScreen({super.key, this.branchId});

  @override
  State<AllSpecialityScreen> createState() => _AllSpecialityScreenState();
}

class _AllSpecialityScreenState extends State<AllSpecialityScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllSpecialityCubit>().loadDepartments(
        branchId: widget.branchId,
      );
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AllSpecialityCubit>().loadMoreDepartments(
        branchId: widget.branchId,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Tất cả chuyên khoa",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
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
                  Text(
                    widget.branchId != null
                        ? "Chuyên khoa chi nhánh"
                        : "Tất cả chuyên khoa",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textHeader,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.branchId != null
                        ? "Danh sách các khoa đang hoạt động tại đây"
                        : "Khám phá các chuyên khoa trong hệ thống",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSlate.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => context
                    .read<AllSpecialityCubit>()
                    .loadDepartments(branchId: widget.branchId, search: value),
                decoration: InputDecoration(
                  hintText: "Tìm kiếm chuyên khoa...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSlate,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primaryBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primaryBorder),
                  ),
                ),
              ),
            ),
            // Scrollable list
            Expanded(
              child: AppRefresh(
                onRefresh: () async {
                  await context.read<AllSpecialityCubit>().loadDepartments(
                    branchId: widget.branchId,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: BlocBuilder<AllSpecialityCubit, AllSpecialityState>(
                    builder: (context, state) {
                      if (state.status == AllSpecialityStatus.loading &&
                          state.departments.isEmpty) {
                        return const Center(child: AppLoadingWidget());
                      }
                      if (state.status == AllSpecialityStatus.failure &&
                          state.departments.isEmpty) {
                        return EmptyStateWidget(
                          icon: Icons.error_outline_rounded,
                          title: "Đã xảy ra lỗi",
                          subtitle:
                              state.errorMessage ??
                              "Đã xảy ra lỗi không xác định",
                          onAction: () => context
                              .read<AllSpecialityCubit>()
                              .loadDepartments(branchId: widget.branchId),
                          actionLabel: "Thử lại",
                        );
                      }

                      final departments = state.departments;
                      if (departments.isEmpty &&
                          state.status == AllSpecialityStatus.success) {
                        return EmptyStateWidget(
                          icon: Icons.medical_services_outlined,
                          title: state.searchQuery?.isNotEmpty ?? false
                              ? "Không tìm thấy kết quả"
                              : "Chi nhánh chưa có chuyên khoa",
                          subtitle: state.searchQuery?.isNotEmpty ?? false
                              ? "Thử tìm kiếm với từ khóa khác"
                              : "Hiện tại chi nhánh này đang cập nhật dữ liệu chuyên khoa. Vui lòng quay lại sau.",
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        itemCount:
                            departments.length + (state.isFetchingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < departments.length) {
                            return SpecialtyCard(
                              department: departments[index],
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: AppLoadingWidget(size: 24)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
