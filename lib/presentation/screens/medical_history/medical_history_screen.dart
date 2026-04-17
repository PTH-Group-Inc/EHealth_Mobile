import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/medical_history/cubit/medical_history_cubit.dart';
import 'package:e_health/presentation/screens/medical_history/cubit/medical_history_state.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import './widgets/medical_history_card.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const MedicalHistoryScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<MedicalHistoryCubit>().loadMedicalHistory(widget.patientId);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MedicalHistoryCubit>().loadMoreMedicalHistory(widget.patientId);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lịch sử khám bệnh",
              style: TextStyle(
                color: AppColors.textHeader,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.patientName,
              style: TextStyle(
                color: AppColors.textSlate.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textHeader),
          onPressed: () => context.pop(),
        ),
      ),
      body: AppRefresh(
        onRefresh: () async {
          await context.read<MedicalHistoryCubit>().loadMedicalHistory(widget.patientId);
        },
        child: BlocBuilder<MedicalHistoryCubit, MedicalHistoryState>(
          builder: (context, state) {
            if (state.status == MedicalHistoryStatus.loading && state.histories.isEmpty) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500,
                  child: Center(child: AppLoadingWidget()),
                ),
              );
            }

            if (state.status == MedicalHistoryStatus.failure && state.histories.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500,
                  child: EmptyStateWidget(
                    icon: Icons.error_outline_rounded,
                    title: "Lỗi tải dữ liệu",
                    subtitle: state.errorMessage ?? "Đã xảy ra lỗi không xác định",
                    onAction: () => context
                        .read<MedicalHistoryCubit>()
                        .loadMedicalHistory(widget.patientId),
                    actionLabel: "Thử lại",
                  ),
                ),
              );
            }

            if (state.histories.isEmpty && state.status == MedicalHistoryStatus.success) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 500,
                  child: EmptyStateWidget(
                    icon: Icons.history_rounded,
                    title: "Chưa có lịch sử",
                    subtitle: "Bệnh nhân này chưa có lịch sử khám bệnh nào.",
                  ),
                ),
              );
            }

            return ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: state.histories.length + (state.isFetchingMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index < state.histories.length) {
                  return MedicalHistoryCard(history: state.histories[index]);
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
    );
  }
}
