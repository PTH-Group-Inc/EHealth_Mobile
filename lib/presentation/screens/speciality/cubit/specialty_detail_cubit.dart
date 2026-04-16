import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../data/network/dio/failure.dart';
import '../../../../domain/department.dart';
import '../../../../domain/specialty.dart';
import '../../../../data/repository.dart';
import 'specialty_detail_state.dart';

import 'package:injectable/injectable.dart';

@injectable
class SpecialtyDetailCubit extends Cubit<SpecialtyDetailState> {
  static final _repository = getIt<Repository>();

  SpecialtyDetailCubit() : super(const SpecialtyDetailState());

  Future<void> loadDepartmentDetail(String id) async {
    emit(state.copyWith(
      status: SpecialtyDetailStatus.loading,
      clearError: true,
      servicePage: 1,
      hasReachedMaxServices: false,
      isFetchingMoreServices: false,
    ));

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
      emit(state.copyWith(
        status: SpecialtyDetailStatus.failure,
        errorMessage: errorMessage!,
      ));
      return;
    }

    specialtiesResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => specialties = data,
    );

    if (errorMessage != null || department == null) {
      emit(state.copyWith(
        status: SpecialtyDetailStatus.failure,
        errorMessage: errorMessage ?? "Lỗi không xác định",
      ));
      return;
    }

    emit(state.copyWith(
      status: SpecialtyDetailStatus.success,
      department: department,
      specialties: specialties,
      selectedSpecialty: specialties!.isNotEmpty ? specialties!.first : null,
      isLoadingServices: true,
    ));

    // Fetch dịch vụ theo Department và Facility ngay lập tức
    final facilityId = department!.facilityId;
    final departmentId = department!.departmentsId;

    if (facilityId != null && departmentId != null) {
      final serviceResult = await _repository.getFacilityServices(
        facilityId,
        departmentId: departmentId,
        isActive: true,
        page: 1,
        limit: 20,
      );

      serviceResult.fold(
        (failure) => emit(state.copyWith(isLoadingServices: false)),
        (services) => emit(state.copyWith(
          isLoadingServices: false,
          services: services,
          hasReachedMaxServices: services.length < 20,
        )),
      );
    } else {
      emit(state.copyWith(isLoadingServices: false));
    }
  }

  Future<void> loadMoreServices() async {
    final facilityId = state.department?.facilityId;
    final departmentId = state.department?.departmentsId;

    if (facilityId == null ||
        departmentId == null ||
        state.isFetchingMoreServices ||
        state.hasReachedMaxServices) return;

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
          emit(state.copyWith(
            isFetchingMoreServices: false,
            hasReachedMaxServices: true,
          ));
        } else {
          emit(state.copyWith(
            isFetchingMoreServices: false,
            services: [...state.services, ...newServices],
            servicePage: nextPage,
            hasReachedMaxServices: newServices.length < 20,
          ));
        }
      },
    );
  }

  Future<void> selectSpecialty(Specialty specialty) async {
    // Chip chuyên khoa chỉ để hiển thị, không gọi API fetch lại
    emit(state.copyWith(
      selectedSpecialty: specialty,
    ));
  }
}
