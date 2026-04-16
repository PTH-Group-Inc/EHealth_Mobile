import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/domain/booking_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  final BookingModel bookingModel;

  const BookAppointmentScreen({super.key, required this.bookingModel});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _searchServiceController =
      TextEditingController();

  BookingModel get _model => widget.bookingModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookAppointmentCubit>().reset();
      context.read<BookAppointmentCubit>().loadInitialData(
        _model.facilityId,
        departmentId: _model.departmentId,
      );
    });

    _reasonController.addListener(_onFormChange);
    _notesController.addListener(_onFormChange);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    _searchServiceController.dispose();
    super.dispose();
  }

  void _onFormChange() {
    context.read<BookAppointmentCubit>().updateForm(
      _reasonController.text,
      _notesController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookAppointmentCubit, BookAppointmentState>(
      listener: (context, state) {
        if (state.error != null) {
          AppToast.showError(context, state.error!);
        }
        if (state.isSubmitted && state.bookedAppointment != null) {
          _showSuccessDialog(context, state.bookedAppointment!.code);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: _buildAppBar(),
        body: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
          builder: (context, state) {
            if (state.isLoading) return const AppLoadingWidget();

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<BookAppointmentCubit>().loadInitialData(
                      _model.facilityId,
                      departmentId: _model.departmentId,
                    );
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: 24),
                        _buildFormSection(state),
                        const SizedBox(height: 24),
                        _buildNotesSection(),
                        const SizedBox(height: 120), // Spacer for bottom button
                      ],
                    ),
                  ),
                  _buildBottomAction(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Đặt lịch khám",
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
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        _buildInfoCard(
          icon: Icons.person_rounded,
          title: "Bệnh nhân",
          subtitle: _model.patientName,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          icon: Icons.location_city_rounded,
          title: "Chi nhánh",
          subtitle: _model.branchName ?? "Chưa chọn chi nhánh",
        ),
        if (_model.departmentName != null) ...[
          const SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.local_hospital_rounded,
            title: "Khoa",
            subtitle: _model.departmentName!,
          ),
        ],
      ],
    );
  }

  Widget _buildFormSection(BookAppointmentState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thông tin lịch khám",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 16),
        _buildSelectorField(
          label: "Dịch vụ khám",
          value: state.selectedService?.serviceName ?? "Chọn dịch vụ khám",
          icon: Icons.medical_services_outlined,
          isEmpty: state.selectedService == null,
          onTap: () => _showServiceSelector(context),
        ),
        const SizedBox(height: 16),
        _buildSelectorField(
          label: "Ngày khám",
          value: state.appointmentDate != null
              ? DateFormat("dd/MM/yyyy").format(state.appointmentDate!)
              : "Chọn ngày khám",
          icon: Icons.calendar_today_rounded,
          isEmpty: state.appointmentDate == null,
          onTap: _selectDate,
        ),
        const SizedBox(height: 16),
        _buildSelectorField(
          label: "Ca khám",
          value: state.selectedShift?.name ?? "Chọn ca khám",
          icon: Icons.access_time_rounded,
          isEmpty: state.selectedShift == null,
          onTap: () => _showShiftSelector(context),
        ),
        const SizedBox(height: 16),
        _buildSelectorField(
          label: "Khung giờ khám",
          value: state.selectedSlot != null
              ? "${state.selectedSlot!.startTime.substring(0, 5)} - ${state.selectedSlot!.endTime.substring(0, 5)}"
              : "Chọn khung giờ khám",
          icon: Icons.more_time_rounded,
          isEmpty: state.selectedSlot == null,
          onTap: () {
            if (state.selectedShift == null) {
              AppToast.showInfo(context, "Vui lòng chọn ca khám trước");
              return;
            }
            _showSlotSelector(context);
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lý do & Ghi chú",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _reasonController,
          label: "Lý do đến khám (Tùy chọn)",
          hint: "Vd: Đau đầu, sốt nhẹ...",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _notesController,
          label: "Ghi chú triệu chứng (Tùy chọn)",
          hint: "Mô tả cụ thể triệu chứng của bạn...",
        ),
      ],
    );
  }

  Widget _buildBottomAction(BookAppointmentState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.isSubmitting ? null : _confirmBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            ),
            child: state.isSubmitting
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    "Xác nhận đặt lịch",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }

  // --- Helper Methods ---

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date != null && mounted) {
      context.read<BookAppointmentCubit>().selectDate(date);
    }
  }

  void _confirmBooking() {
    final state = context.read<BookAppointmentCubit>().state;

    if (state.selectedSlot == null) {
      AppToast.showInfo(context, "Vui lòng chọn khung giờ khám");
      return;
    }

    final cubit = context.read<BookAppointmentCubit>();
    cubit.updateForm(_reasonController.text, _notesController.text);

    cubit.submitAppointment(
      patientId: _model.patientId,
      branchId: _model.branchId,
      slotId: state.selectedSlot!.id,
    );
  }

  void _showServiceSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => _ServiceSelectorSheet(
        facilityId: _model.facilityId,
        searchController: _searchServiceController,
      ),
    );
  }

  void _showShiftSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => const _ShiftSelectorSheet(),
    );
  }

  void _showSlotSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => const _SlotSelectorSheet(),
    );
  }

  void _showSuccessDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _BookingSuccessDialog(appointmentCode: code),
    );
  }

  // --- Reusable Small UI Widgets ---

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeader,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorField({
    required String label,
    required String value,
    required IconData icon,
    required bool isEmpty,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isEmpty ? AppColors.textSlate : AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSlate,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: isEmpty ? Colors.grey[400] : AppColors.textDark,
                      fontWeight: isEmpty ? FontWeight.normal : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textSlate,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Internal Sheet Components ---

class _ServiceSelectorSheet extends StatefulWidget {
  final String? facilityId;
  final String? departmentId;
  final TextEditingController searchController;

  const _ServiceSelectorSheet({
    required this.facilityId,
    this.departmentId,
    required this.searchController,
  });

  @override
  State<_ServiceSelectorSheet> createState() => _ServiceSelectorSheetState();
}

class _ServiceSelectorSheetState extends State<_ServiceSelectorSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) {
        // Add scroll listener for pagination
        controller.addListener(() {
          if (controller.position.pixels >=
              controller.position.maxScrollExtent - 200) {
            context.read<BookAppointmentCubit>().loadMoreServices(
                  widget.facilityId,
                  departmentId: widget.departmentId,
                );
          }
        });

        return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Chọn Dịch vụ Khám",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: widget.searchController,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm dịch vụ...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSlate,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (val) => context
                        .read<BookAppointmentCubit>()
                        .searchServices(widget.facilityId, val),
                  ),
                  const SizedBox(height: 16),
                  if (state.isSearchingServices)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.services.isEmpty)
                    const Expanded(
                      child: Center(child: Text("Không tìm thấy dịch vụ nào")),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        controller: controller,
                        itemCount: state.services.length + (state.isFetchingMoreServices ? 1 : 0),
                        separatorBuilder: (_, _) =>
                            const Divider(color: AppColors.border),
                        itemBuilder: (ctx, index) {
                          if (index < state.services.length) {
                             final service = state.services[index];
                             return ListTile(
                              onTap: () {
                                context
                                    .read<BookAppointmentCubit>()
                                    .selectService(service);
                                Navigator.pop(ctx);
                              },
                              title: Text(
                                service.serviceName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                "${service.estimatedDurationMinutes} phút • Mã: ${service.serviceCode}",
                              ),
                              trailing: Text(
                                NumberFormat.currency(
                                  locale: 'vi',
                                  symbol: 'đ',
                                ).format(double.parse(service.basePrice)),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ShiftSelectorSheet extends StatelessWidget {
  const _ShiftSelectorSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Chọn Ca Khám",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeader,
                ),
              ),
              const SizedBox(height: 16),
              if (state.shifts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Không có ca khám khả dụng"),
                )
              else
                ...state.shifts.map(
                  (shift) => ListTile(
                    onTap: () {
                      context.read<BookAppointmentCubit>().selectShift(shift);
                      Navigator.pop(context);
                    },
                    leading: const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      shift.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${shift.startTime} - ${shift.endTime}"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _SlotSelectorSheet extends StatelessWidget {
  const _SlotSelectorSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.8,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Chọn Khung Giờ Khám",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.isLoadingSlots)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.slots.isEmpty)
                    const Expanded(
                      child: Center(child: Text("Không có khung giờ khả dụng")),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: state.slots.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final slot = state.slots[index];
                          final isAvailable = slot.isAvailable;
                          final isSelected = state.selectedSlot?.id == slot.id;

                          // Format Date and Weekday
                          final date = state.appointmentDate ?? DateTime.now();
                          final weekday = DateFormat(
                            "EEEE",
                            "vi_VN",
                          ).format(date);
                          final dateStr = DateFormat("dd/MM/yyyy").format(date);

                          return InkWell(
                            onTap: isAvailable
                                ? () {
                                    context
                                        .read<BookAppointmentCubit>()
                                        .selectSlot(slot);
                                    Navigator.pop(ctx);
                                  }
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: !isAvailable
                                    ? Colors.grey[50]
                                    : isSelected
                                    ? AppColors.primary.withValues(alpha: 0.05)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: !isAvailable
                                      ? AppColors.border.withValues(alpha: 0.5)
                                      : isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Opacity(
                                opacity: isAvailable ? 1.0 : 0.5,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          weekday.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textHeader,
                                          ),
                                        ),
                                        Text(
                                          dateStr,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSlate,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    if (!isAvailable)
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          "Hết chỗ",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !isAvailable
                                            ? Colors.grey[300]
                                            : isSelected
                                            ? AppColors.primary
                                            : AppColors.primary.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "${slot.startTime.substring(0, 5)} - ${slot.endTime.substring(0, 5)}",
                                        style: TextStyle(
                                          color: !isAvailable
                                              ? Colors.grey[600]
                                              : isSelected
                                              ? Colors.white
                                              : AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BookingSuccessDialog extends StatelessWidget {
  final String appointmentCode;

  const _BookingSuccessDialog({required this.appointmentCode});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 64,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Đặt lịch thành công!",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textHeader,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Mã phiếu khám của bạn là:",
            style: TextStyle(color: AppColors.textSlate.withValues(alpha: 0.8)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              appointmentCode,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => context.go('/home'),
              child: const Text(
                "Về trang chủ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
