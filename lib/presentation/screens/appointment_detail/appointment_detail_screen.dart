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
        AppToast.showError(
          context,
          "Thiếu thông tin thời gian để thêm vào lịch",
        );
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
        iosParams: const IOSParams(reminder: Duration(minutes: 30)),
        androidParams: const AndroidParams(emailInvites: []),
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

        return BlocListener<AppointmentDetailCubit, AppointmentDetailState>(
          listenWhen: (previous, current) =>
              previous.navigateToPayment != current.navigateToPayment ||
              previous.errorMessage != current.errorMessage ||
              previous.cancelSuccess != current.cancelSuccess,
          listener: (context, state) {
            if (state.cancelSuccess) {
              AppToast.showSuccess(context, "Huỷ lịch khám thành công");
              context.read<AppointmentDetailCubit>().clearCancelState();
            }
            if (state.navigateToPayment &&
                state.invoice != null &&
                state.encounter != null) {
              context.push(
                '/payment-qr',
                extra: {'invoice': state.invoice, 'encounter': state.encounter},
              );
              context.read<AppointmentDetailCubit>().clearNavigation();
            } else if (state.errorMessage != null &&
                !state.isPreparingPayment) {
              AppToast.showError(context, state.errorMessage!);
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.primaryBackground,
            appBar: AppBar(
              title: const Text(
                "Chi tiết lịch khám",
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
                    colors: [AppColors.primary, Color(0xFF1E40AF)],
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
            body: _buildBody(state),
            floatingActionButton: (appointment != null)
                ? (appointment.status.toUpperCase() == 'CONFIRMED'
                      ? FloatingActionButton.extended(
                          onPressed: () => _addToCalendar(appointment),
                          backgroundColor: AppColors.primary,
                          icon: const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Thêm vào lịch",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : (appointment.status.toUpperCase() == 'COMPLETED'
                            ? FloatingActionButton.extended(
                                onPressed: state.isPreparingPayment
                                    ? null
                                    : () => context
                                          .read<AppointmentDetailCubit>()
                                          .preparePayment(appointment.id),
                                backgroundColor: AppColors.primary,
                                icon: state.isPreparingPayment
                                    ? const AppLoadingWidget(
                                        size: 18,
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.payment_rounded,
                                        color: Colors.white,
                                      ),
                                label: Text(
                                  state.isPreparingPayment
                                      ? "Đang xử lý..."
                                      : "Thanh toán ngay",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : (['PENDING', 'CONFIRMED', 'CHECKED_IN'].contains(appointment.status.toUpperCase())
                                ? FloatingActionButton.extended(
                                    onPressed: () => _showCancelDialog(
                                      context,
                                      appointment.id,
                                      appointment.status.toUpperCase(),
                                    ),
                                    backgroundColor: Colors.redAccent,
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Huỷ lịch",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null)))
                : null,
          ),
        );
      },
    );
  }

  void _showCancelDialog(
    BuildContext context,
    String appointmentId,
    String status,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        bool showReasonInput = false;
        final TextEditingController reasonController = TextEditingController();
        String? errorText;

        return StatefulBuilder(
          builder: (context, setState) {
            if (!showReasonInput) {
              return AlertDialog(
                title: const Text(
                  "Thông báo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text("Bạn có muốn thực sự huỷ lịch?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Không",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showReasonInput = true;
                      });
                    },
                    child: const Text(
                      "Huỷ",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }

            return AlertDialog(
              title: const Text(
                "Lý do huỷ lịch (*)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   TextField(
                    controller: reasonController,
                    decoration: InputDecoration(
                      hintText: "Nhập lý do huỷ...",
                      border: const OutlineInputBorder(),
                      errorText: errorText,
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      if (errorText != null) {
                        setState(() => errorText = null);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final reason = reasonController.text.trim();
                      if (reason.isEmpty) {
                        setState(() {
                          errorText = "vui lòng nhập lý do huỷ";
                        });
                        return;
                      }

                      // Check FE status again as requested
                      if (['COMPLETED', 'CANCELLED', 'IN_PROGRESS'].contains(
                        status,
                      )) {
                        AppToast.showError(
                          context,
                          "Trạng thái hiện tại không cho phép huỷ lịch",
                        );
                        Navigator.pop(context);
                        return;
                      }

                      context.read<AppointmentDetailCubit>().cancelAppointment(
                        appointmentId,
                        reason,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Xác nhận huỷ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text(
                    "Mã QR checkin của bạn",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AppointmentQRSection(
                  qrData: detail.qrToken,
                  appointmentCode: detail.qrToken,
                ),
                const SizedBox(height: 12),
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
