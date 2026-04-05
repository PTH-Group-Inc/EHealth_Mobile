import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/booked_appointment.dart';
import 'package:e_health/presentation/screens/appointment_detail/cubit/appointment_detail_cubit.dart';
import 'package:e_health/presentation/screens/appointment_detail/cubit/appointment_detail_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/appointment_detail_card.dart';
import 'widgets/appointment_horizontal_stepper.dart';
import 'widgets/appointment_qr_section.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String appointmentId;

  const AppointmentDetailScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentDetailCubit>().getAppointmentDetail(
        widget.appointmentId,
      );
    });
  }

  Future<void> _addToCalendar(BookedAppointment appointment) async {
    try {
      if (appointment.appointmentDate == null ||
          appointment.slotStartTime == null ||
          appointment.slotEndTime == null) {
        AppToast.showError(context, "Thiếu thông tin thời gian để thêm vào lịch");
        return;
      }

      // Parse date: "2024-05-20"
      final dateParts = appointment.appointmentDate!.split('-');
      if (dateParts.length != 3) return;
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      // Parse time: "08:30:00"
      final startParts = appointment.slotStartTime!.split(':');
      final endParts = appointment.slotEndTime!.split(':');

      final startDateTime = DateTime(
        year,
        month,
        day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      ).toLocal();

      final endDateTime = DateTime(
        year,
        month,
        day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      ).toLocal();

      final event = Event(
        title: "Lịch khám: ${appointment.serviceName ?? 'Khám bệnh'}",
        description:
            "Mã lịch khám: ${appointment.code}\n"
            "Bác sĩ: ${appointment.doctorName ?? 'Chưa cập nhật'}\n"
            "Phòng: ${appointment.roomName ?? 'Chưa cập nhật'}\n"
            "Cơ sở: ${appointment.branchName ?? 'Chưa cập nhật'}\n"
            "Lý do: ${appointment.reasonForVisit ?? 'Không có'}",
        location: appointment.branchName ?? "Bệnh viện",
        startDate: startDateTime,
        endDate: endDateTime,
        iosParams: const IOSParams(
          reminder: Duration(minutes: 30),
        ),
        androidParams: const AndroidParams(
          emailInvites: [],
        ),
      );

      final success = await Add2Calendar.addEvent2Cal(event);
      if (success && mounted) {
        AppToast.showSuccess(context, "Đã mở ứng dụng lịch");
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, "Không thể thêm vào lịch: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
      builder: (context, state) {
        final detail = state.appointment;
        final appointment = detail?.appointment;
        final bool isConfirmed =
            appointment?.status.toUpperCase() == 'CONFIRMED';

        return Scaffold(
          backgroundColor: AppColors.primaryBackground,
          appBar: AppBar(
            title: const Text(
              "Chi tiết lịch khám",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textHeader,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
          body: _buildBody(state),
          floatingActionButton:
              (isConfirmed && appointment != null)
                  ? FloatingActionButton.extended(
                    onPressed: () => _addToCalendar(appointment),
                    backgroundColor: AppColors.primary,
                    icon: const Icon(Icons.calendar_today_rounded, color: Colors.white),
                    label: const Text(
                      "Thêm vào lịch",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : null,
        );
      },
    );
  }

  Widget _buildBody(AppointmentDetailState state) {
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
      final detail = state.appointment!;
      final appointment = detail.appointment;
      final String status = appointment.status.toUpperCase();

      // QR shows for CONFIRMED, CHECKED_IN, IN_PROGRESS, COMPLETED
      final bool showQR =
          status != 'PENDING' && status != 'CANCELLED' && status != 'NO_SHOW';

      return RefreshIndicator(
        onRefresh: () => context
            .read<AppointmentDetailCubit>()
            .getAppointmentDetail(widget.appointmentId),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Stepper
              const SizedBox(height: 8),
              AppointmentHorizontalStepper(currentStatus: status),
              const SizedBox(height: 20),

              // QR Section (Centered)
              if (showQR) ...[
                AppointmentQRSection(
                  qrData: detail.qrToken,
                  appointmentCode: detail.qrToken,
                ),
                const SizedBox(height: 32),
              ],

              // Info Card - Appointment Summary
              AppointmentDetailCard(
                title: "Chi tiết đặt lịch",
                icon: Icons.calendar_today_rounded,
                child: Column(
                  children: [
                    _buildDetailRow(
                      "Mã lịch khám",
                      appointment.code,
                      isBold: true,
                    ),
                    _buildDetailRow(
                      "Ngày khám",
                      appointment.appointmentDate ?? "---",
                    ),
                    _buildDetailRow(
                      "Thời gian",
                      "${appointment.slotStartTime ?? '--'} - ${appointment.slotEndTime ?? '--'}",
                    ),
                    _buildDetailRow(
                      "Phòng khám",
                      appointment.roomName ?? "Đang cập nhật",
                    ),
                    _buildDetailRow(
                      "Cơ sở",
                      appointment.branchName ?? "Đang cập nhật",
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Card - Service & Doctor
              AppointmentDetailCard(
                title: "Dịch vụ & Bác sĩ",
                icon: Icons.medical_services_rounded,
                child: Column(
                  children: [
                    _buildDetailRow(
                      "Dịch vụ",
                      appointment.serviceName ?? "---",
                    ),
                    _buildDetailRow(
                      "Bác sĩ phụ trách",
                      appointment.doctorName ?? "Đang cập nhật",
                    ),
                    _buildDetailRow(
                      "Độ ưu tiên",
                      appointment.priority ?? "Thường",
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Card - Patient Information
              AppointmentDetailCard(
                title: "Thông tin bệnh nhân",
                icon: Icons.person_rounded,
                child: Column(
                  children: [
                    _buildDetailRow(
                      "Tên bệnh nhân",
                      appointment.patientName ?? "---",
                      isBold: true,
                    ),
                    _buildDetailRow(
                      "Kênh đặt lịch",
                      appointment.bookingChannel ?? "Ứng dụng",
                    ),
                    _buildDetailRow(
                      "Số thứ tự",
                      appointment.queueNumber?.toString() ?? "Chưa cấp",
                    ),
                    _buildDetailRow(
                      "Lý do khám",
                      appointment.reasonForVisit ?? "Không có",
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Card - Symptoms/Notes
              if (appointment.symptomsNotes != null &&
                  appointment.symptomsNotes!.isNotEmpty) ...[
                AppointmentDetailCard(
                  title: "Triệu chứng & Ghi chú",
                  icon: Icons.note_alt_rounded,
                  child: Text(
                    appointment.symptomsNotes!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Info Card - Audit Info (Dates)
              AppointmentDetailCard(
                title: "Hồ sơ lịch khám",
                icon: Icons.history_rounded,
                child: Column(
                  children: [
                    if (detail.confirmedAt != null)
                      _buildDetailRow(
                        "Xác nhận lúc",
                        _formatDate(detail.confirmedAt!),
                      ),
                    if (detail.checkedInAt != null)
                      _buildDetailRow(
                        "Check-in lúc",
                        _formatDate(detail.checkedInAt!),
                      ),
                    if (detail.startedAt != null)
                      _buildDetailRow(
                        "Bắt đầu khám",
                        _formatDate(detail.startedAt!),
                      ),
                    if (detail.completedAt != null)
                      _buildDetailRow(
                        "Hoàn tất lúc",
                        _formatDate(detail.completedAt!),
                      ),
                    if (detail.cancelledAt != null)
                      _buildDetailRow(
                        "Hủy lúc",
                        _formatDate(detail.cancelledAt!),
                        isLast: true,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isLast = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSlate.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: isBold ? AppColors.primary : AppColors.textHeader,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} - ${date.day}/${date.month}/${date.year}";
  }
}
