import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import '../../widgets/feedback/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'cubit/all_speciality_cubit.dart';
import 'cubit/all_speciality_state.dart';
import './widgets/specialty_card.dart';


class AllSpecialityScreen extends StatefulWidget {
  final String? branchId;

  const AllSpecialityScreen({super.key, this.branchId});

  @override
  State<AllSpecialityScreen> createState() => _AllSpecialityScreenState();
}

class _AllSpecialityScreenState extends State<AllSpecialityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllSpecialityCubit>().loadDepartments(
        branchId: widget.branchId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
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
            // Scrollable list
            Expanded(
              child: AppRefresh(
                onRefresh: () async {
                  await context.read<AllSpecialityCubit>().loadDepartments(
                    branchId: widget.branchId,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: BlocBuilder<AllSpecialityCubit, AllSpecialityState>(
                    builder: (context, state) {
                      if (state is AllSpecialityLoading) {
                        return const Center(child: AppLoadingWidget());
                      }
                      if (state is AllSpecialityError) {
                        return EmptyStateWidget(
                          icon: Icons.error_outline_rounded,
                          title: "Đã xảy ra lỗi",
                          subtitle: state.message,
                          onAction: () => context
                              .read<AllSpecialityCubit>()
                              .loadDepartments(branchId: widget.branchId),
                          actionLabel: "Thử lại",
                        );
                      }
                      if (state is AllSpecialityLoaded) {
                        final departments = state.departments;
                        if (departments.isEmpty) {
                          return const EmptyStateWidget(
                            icon: Icons.medical_services_outlined,
                            title: "Chi nhánh chưa có chuyên khoa",
                            subtitle:
                                "Hiện tại chi nhánh này đang cập nhật dữ liệu chuyên khoa. Vui lòng quay lại sau.",
                          );
                        }
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: departments.length,
                          itemBuilder: (context, index) {
                            return SpecialtyCard(
                              department: departments[index],
                            );
                          },
                        );
                      }
                      return const SizedBox();
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
