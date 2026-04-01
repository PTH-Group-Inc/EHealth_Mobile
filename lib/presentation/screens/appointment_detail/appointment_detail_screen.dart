import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:e_health/presentation/screens/appointment_detail/cubit/appointment_detail_cubit.dart';
import 'package:e_health/presentation/screens/appointment_detail/cubit/appointment_detail_state.dart';
import 'package:e_health/presentation/screens/appointment_detail/widgets/appointment_audit_timeline.dart';
import 'package:e_health/presentation/screens/appointment_detail/widgets/appointment_info_card.dart';
import 'package:e_health/presentation/screens/appointment_detail/widgets/appointment_status_badge.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentDetailCubit>().getAppointmentDetail(widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Chi tiết lịch khám",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
      ),
      body: BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
        builder: (context, state) {
          if (state.status == AppointmentDetailStatus.loading) {
            return const Center(child: AppLoadingWidget());
          }

          if (state.status == AppointmentDetailStatus.failure) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              title: "Lỗi tải dữ liệu",
              subtitle: state.errorMessage ?? "Đã xảy ra lỗi không xác định",
              onAction: () => context
                  .read<AppointmentDetailCubit>()
                  .getAppointmentDetail(widget.appointmentId),
              actionLabel: "Thử lại",
            );
          }

          if (state.status == AppointmentDetailStatus.success &&
              state.appointment != null) {
            final appointment = state.appointment!;
            return RefreshIndicator(
              onRefresh: () => context
                  .read<AppointmentDetailCubit>()
                  .getAppointmentDetail(widget.appointmentId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    AppointmentStatusBadge(status: appointment.appointment.status),
                    const SizedBox(height: 16),

                    // Main Info Card
                    AppointmentDetailInfoCard(appointment: appointment),
                    const SizedBox(height: 24),

                    // Audit Timeline
                    const Text(
                      "Lịch sử trạng thái",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppointmentAuditTimeline(auditLogs: appointment.auditLogs),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
