import '../../widgets/feedback/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_color.dart';
import 'cubit/all_branch_cubit.dart';
import 'cubit/all_branch_state.dart';
import '../../widgets/feedback/empty_state_widget.dart';
import '../../widgets/feedback/app_loading_widget.dart';
import './widgets/branch_card.dart';

import '../../../domain/booking_model.dart';

class AllBranchScreen extends StatefulWidget {
  final BookingModel? bookingModel;

  const AllBranchScreen({super.key, this.bookingModel});

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
                    "Chi nhánh",
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
                        child: SizedBox(height: 500, child: AppLoadingWidget()),
                      );
                    }
                    if (state is AllBranchError) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: EmptyStateWidget(
                          icon: Icons.error_outline_rounded,
                          title: "Đã xảy ra lỗi",
                          subtitle: state.message,
                          onAction: () =>
                              context.read<AllBranchCubit>().loadBranches(),
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
                            subtitle:
                                "Hiện tại hệ thống không tìm thấy chi nhánh nào gần khu vực này.",
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: branches.length,
                        itemBuilder: (context, index) {
                          return BranchCard(
                            branchItem: branches[index],
                            bookingModel: widget.bookingModel,
                          );
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
}
