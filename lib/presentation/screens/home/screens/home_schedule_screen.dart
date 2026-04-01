import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_color.dart';
import '../../../../app/theme/app_shadow.dart';
import '../../../../domain/booked_appointment.dart';
import '../../../widgets/feedback/app_loading_widget.dart';
import '../../../widgets/feedback/app_refresh.dart';
import '../../../widgets/feedback/empty_state_widget.dart';
import '../cubit/home_schedule_cubit.dart';
import '../cubit/home_schedule_state.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';

class HomeScheduleScreen extends StatefulWidget {
  const HomeScheduleScreen({super.key});

  @override
  State<HomeScheduleScreen> createState() => _HomeScheduleScreenState();
}

class _HomeScheduleScreenState extends State<HomeScheduleScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    // Refresh data when screen is first built in a session
    context.read<HomeScheduleCubit>().getMyAppointments();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeScheduleCubit>().loadMoreAppointments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.status != AuthStatus.success &&
          current.status == AuthStatus.success,
      listener: (context, state) {
        // Refresh when user logs in/identity changes
        context.read<HomeScheduleCubit>().getMyAppointments();
      },
      child: BlocBuilder<HomeScheduleCubit, HomeScheduleState>(
        builder: (context, state) {
          return AppRefresh(
            onRefresh: () async {
              await context.read<HomeScheduleCubit>().getMyAppointments();
            },
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(HomeScheduleState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            "Lịch khám",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Expanded(child: _buildContent(state)),
      ],
    );
  }

  Widget _buildContent(HomeScheduleState state) {
    if (state.status == HomeScheduleStatus.loading &&
        state.appointments.isEmpty) {
      return const Center(child: AppLoadingWidget());
    }

    if (state.isNotLinked) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: EmptyStateWidget(
            icon: Icons.person_add_outlined,
            title: "Chưa có hồ sơ y tế",
            subtitle: "Bạn chưa có hồ sơ y tế nào thêm ngay",
            onAction: () => context.push('/create-medical-record'),
            actionLabel: "Thêm ngay",
          ),
        ),
      );
    }

    if (state.status == HomeScheduleStatus.failure &&
        state.appointments.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: EmptyStateWidget(
            icon: Icons.error_outline_rounded,
            title: "Lỗi tải lịch khám",
            subtitle: state.errorMessage ?? "Đã xảy ra lỗi không xác định",
            onAction: () =>
                context.read<HomeScheduleCubit>().getMyAppointments(),
            actionLabel: "Thử lại",
          ),
        ),
      );
    }

    if (state.appointments.isEmpty) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: EmptyStateWidget(
          icon: Icons.calendar_today_outlined,
          title: "Chưa có lịch khám",
          subtitle:
              "Bạn chưa có lịch khám nào sắp tới. Hãy đặt lịch ngay để được chăm sóc sức khỏe tốt nhất.",
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
      itemCount: state.appointments.length + (state.isFetchingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index < state.appointments.length) {
          final appointment = state.appointments[index];
          return _buildAppointmentCard(appointment);
        }
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: AppLoadingWidget(size: 24)),
        );
      },
    );
  }

  Widget _buildAppointmentCard(BookedAppointment appointment) {
    final statusColor = _getStatusColor(appointment.status);
    final statusText = _getStatusText(appointment.status);
    final date = appointment.appointmentDate != null
        ? DateTime.tryParse(appointment.appointmentDate!)
        : null;

    return GestureDetector(
      onTap: () => context.push('/appointment-detail/${appointment.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadow.cardShadow,
          border: Border.all(color: AppColors.grey200, width: 0.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Date column
              Container(
                width: 80,
                color: AppColors.primaryBackground,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      date != null ? DateFormat('dd').format(date) : '--',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      date != null
                          ? DateFormat('MMM').format(date).toUpperCase()
                          : '--',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        appointment.slotStartTime?.substring(0, 5) ?? '--:--',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              appointment.serviceName ?? 'Dịch vụ khám',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildStatusBadge(statusText, statusColor),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        appointment.doctorName ?? 'Đang cập nhật Bác sĩ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSlate,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.branchName ?? '-',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSlate,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.meeting_room_outlined,
                            size: 14,
                            color: AppColors.textSlate,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.roomName ?? 'Đang cập nhật phòng',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSlate,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 14,
                            color: AppColors.textSlate,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.patientName ??
                                  "Đang cập nhật bệnh nhân",
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSlate,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              size: 12,
                              color: AppColors.textSlate,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Mã: ${appointment.code}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSlate,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'CONFIRMED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'NO_SHOW':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Chờ xác nhận';
      case 'CONFIRMED':
        return 'Đã xác nhận';
      case 'COMPLETED':
        return 'Đã hoàn thành';
      case 'CANCELLED':
        return 'Đã hủy';
      case 'NO_SHOW':
        return 'Không đến';
      default:
        return status;
    }
  }
}
