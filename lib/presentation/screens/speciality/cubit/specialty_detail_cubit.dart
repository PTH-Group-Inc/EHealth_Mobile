import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:e_health/data/network/dio/failure.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/specialty.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/presentation/screens/speciality/cubit/specialty_detail_state.dart';
import 'package:intl/intl.dart';

import 'package:injectable/injectable.dart';

@injectable
class SpecialtyDetailCubit extends Cubit<SpecialtyDetailState> {
  static final _repository = getIt<Repository>();

  SpecialtyDetailCubit() : super(const SpecialtyDetailState());

  Future<void> loadDepartmentDetail(String id) async {
    emit(
      state.copyWith(
        status: SpecialtyDetailStatus.loading,
        clearError: true,
        servicePage: 1,
        hasReachedMaxServices: false,
        isFetchingMoreServices: false,
        calendarMonth: DateTime.now().month,
        calendarYear: DateTime.now().year,
      ),
    );

    final results = await Future.wait([
      _repository.getDepartmentDetail(id),
      _repository.getDepartmentSpecialties(id),
    ]);

    final deptResult = results[0] as Either<Failure, Department>;
    final specialtiesResult = results[1] as Either<Failure, List<Specialty>>;

    Department? department;
    List<Specialty>? specialties;
    String? errorMessage;

    deptResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => department = data,
    );

    if (errorMessage != null) {
      emit(
        state.copyWith(
          status: SpecialtyDetailStatus.failure,
          errorMessage: errorMessage!,
        ),
      );
      return;
    }

    specialtiesResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => specialties = data,
    );

    if (errorMessage != null || department == null) {
      emit(
        state.copyWith(
          status: SpecialtyDetailStatus.failure,
          errorMessage: errorMessage ?? "Lỗi không xác định",
        ),
      );
      return;
    }

    // Fetch Branch Detail to get address
    if (department!.branchId != null) {
      final branchResult = await _repository.getBranchDetail(
        department!.branchId!,
      );
      branchResult.fold(
        (failure) => null, // Just ignore branch error for now
        (branch) {
          department = department!.copyWith(branchName: branch.address);
          emit(state.copyWith(branch: branch));
        },
      );
    }

    emit(
      state.copyWith(
        status: SpecialtyDetailStatus.success,
        department: department,
        specialties: specialties,
        selectedSpecialty: specialties!.isNotEmpty ? specialties!.first : null,
        isLoadingServices: true,
      ),
    );

    // Fetch dịch vụ theo Department và Facility ngay lập tức
    final facilityId = department!.facilityId;
    final departmentId = department!.departmentsId;

    if (facilityId != null && departmentId != null) {
      // Load initial calendar data as well
      loadCalendarData(month: state.calendarMonth, year: state.calendarYear);

      final serviceResult = await _repository.getFacilityServices(
        facilityId,
        departmentId: departmentId,
        isActive: true,
        page: 1,
        limit: 20,
      );

      serviceResult.fold(
        (failure) => emit(state.copyWith(isLoadingServices: false)),
        (services) => emit(
          state.copyWith(
            isLoadingServices: false,
            services: services,
            hasReachedMaxServices: services.length < 20,
          ),
        ),
      );
    } else {
      emit(state.copyWith(isLoadingServices: false));
    }
  }

  Future<void> loadCalendarData({int? month, int? year}) async {
    final facilityId = state.department?.facilityId;
    if (facilityId == null) return;

    final currentMonth = month ?? state.calendarMonth;
    final currentYear = year ?? state.calendarYear;

    emit(
      state.copyWith(
        isLoadingCalendar: true,
        calendarMonth: currentMonth,
        calendarYear: currentYear,
      ),
    );

    final result = await _repository.getFacilityCalendar(
      facilityId: facilityId,
      month: currentMonth,
      year: currentYear,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingCalendar: false, errorMessage: failure.message),
      ),
      (data) {
        final availabilityMap = {
          for (var item in data)
            DateTime(item.date.year, item.date.month, item.date.day):
                item.isOpen,
        };
        emit(
          state.copyWith(
            isLoadingCalendar: false,
            calendarAvailability: availabilityMap,
          ),
        );
      },
    );
  }

  Future<void> selectDate(DateTime date) async {
    emit(
      state.copyWith(
        appointmentDate: date,
        clearDate:
            false, // Keep the list of slots if needed, but we typically refresh
      ),
    );
    await _loadSlotsForDate(date);
  }

  Future<void> _loadSlotsForDate(DateTime date) async {
    final facilityId = state.department?.facilityId;
    if (facilityId == null) return;

    emit(state.copyWith(isLoadingDateSlots: true));

    final String dateFormatted = DateFormat("yyyy-MM-dd").format(date);

    final result = await _repository.getAvailableSlots(
      date: dateFormatted,
      facilityId: facilityId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingDateSlots: false,
          errorMessage: failure.message,
        ),
      ),
      (data) {
        emit(
          state.copyWith(isLoadingDateSlots: false, availableDateSlots: data),
        );
      },
    );
  }

  Future<void> loadMoreServices() async {
    final facilityId = state.department?.facilityId;
    final departmentId = state.department?.departmentsId;

    if (facilityId == null ||
        departmentId == null ||
        state.isFetchingMoreServices ||
        state.hasReachedMaxServices) {
      return;
    }

    emit(state.copyWith(isFetchingMoreServices: true));

    final nextPage = state.servicePage + 1;
    final result = await _repository.getFacilityServices(
      facilityId,
      departmentId: departmentId,
      isActive: true,
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(isFetchingMoreServices: false)),
      (newServices) {
        if (newServices.isEmpty) {
          emit(
            state.copyWith(
              isFetchingMoreServices: false,
              hasReachedMaxServices: true,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isFetchingMoreServices: false,
              services: [...state.services, ...newServices],
              servicePage: nextPage,
              hasReachedMaxServices: newServices.length < 20,
            ),
          );
        }
      },
    );
  }

  Future<void> selectSpecialty(Specialty specialty) async {
    emit(state.copyWith(selectedSpecialty: specialty));
  }
}
