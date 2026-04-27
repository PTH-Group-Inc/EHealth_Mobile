import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/domain/booking_model.dart';
import 'package:e_health/presentation/screens/appointment/widgets/stepper_widget.dart';
import 'package:e_health/presentation/screens/appointment/widgets/header_info_section.dart';
import 'package:e_health/presentation/screens/appointment/widgets/booking_form_section.dart';
import 'package:e_health/presentation/screens/appointment/widgets/notes_section.dart';
import 'package:e_health/presentation/screens/appointment/widgets/bottom_action_bar.dart';
import 'package:e_health/presentation/screens/appointment/widgets/service_selector_sheet.dart';
import 'package:e_health/presentation/screens/appointment/widgets/shift_selector_sheet.dart';
import 'package:e_health/presentation/screens/appointment/widgets/slot_selector_sheet.dart';
import 'package:e_health/presentation/screens/appointment/widgets/calendar_selector_sheet.dart';
import 'package:e_health/presentation/screens/appointment/widgets/booking_summary_sheet.dart';
import 'package:e_health/presentation/screens/appointment/widgets/doctor_selector_sheet.dart';

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
        doctorId: _model.doctorId,
        doctorName: _model.doctorName,
        doctorAvatar: _model.doctorAvatar,
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
        if (state.isSubmitted && state.preBookingResult != null) {
          context.push('/booking-payment-qr', extra: state.preBookingResult);
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StepperWidget(state: state),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              HeaderInfoSection(model: _model),
                              const SizedBox(height: 32),
                              BookingFormSection(
                                state: state,
                                onSelectService: () =>
                                    _showServiceSelector(context),
                                onSelectDate: _selectDate,
                                onSelectShift: () =>
                                    _showShiftSelector(context),
                                onSelectSlot: () {
                                  if (state.selectedShift == null) {
                                    AppToast.showInfo(
                                      context,
                                      "Vui lòng chọn ca khám trước",
                                    );
                                    return;
                                  }
                                  _showSlotSelector(context);
                                },
                                onSelectDoctor: () {
                                  if (state.selectedService == null) {
                                    AppToast.showInfo(
                                      context,
                                      "Vui lòng chọn dịch vụ khám trước",
                                    );
                                    return;
                                  }
                                  _showDoctorSelector(context);
                                },
                              ),
                              const SizedBox(height: 32),
                              NotesSection(
                                reasonController: _reasonController,
                                notesController: _notesController,
                              ),
                              const SizedBox(height: 140),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BottomActionBar(
                    isSubmitting: state.isSubmitting,
                    onConfirm: _confirmBooking,
                  ),
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
    );
  }

  void _selectDate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CalendarSelectorSheet(),
    );
  }

  void _confirmBooking() {
    final state = context.read<BookAppointmentCubit>().state;

    if (state.selectedSlot == null) {
      AppToast.showInfo(context, "Vui lòng chọn khung giờ khám");
      return;
    }

    final cubit = context.read<BookAppointmentCubit>();
    cubit.updateForm(_reasonController.text, _notesController.text);

    _showSummaryBottomSheet(context, state);
  }

  void _showSummaryBottomSheet(
    BuildContext context,
    BookAppointmentState state,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BookingSummarySheet(
        state: state,
        model: _model,
        onConfirm: () {
          context.read<BookAppointmentCubit>().submitAppointment(
            patientId: _model.patientId,
            branchId: _model.branchId,
            slotId: state.selectedSlot!.id,
          );
          Navigator.pop(context);
        },
      ),
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
      builder: (_) => ServiceSelectorSheet(
        facilityId: _model.facilityId,
        departmentId: _model.departmentId,
        searchController: _searchServiceController,
      ),
    );
  }

  void _showShiftSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      builder: (_) => const ShiftSelectorSheet(),
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
      builder: (_) => const SlotSelectorSheet(),
    );
  }

  void _showDoctorSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (_) => const DoctorSelectorSheet(),
    );
  }
}
