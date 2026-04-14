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

  SpecialtyDetailCubit() : super(SpecialtyDetailInitial());

  Future<void> loadDepartmentDetail(String id) async {
    emit(SpecialtyDetailLoading());

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
      emit(SpecialtyDetailError(message: errorMessage!));
      return;
    }

    specialtiesResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => specialties = data,
    );

    if (errorMessage != null || department == null) {
      emit(SpecialtyDetailError(message: errorMessage ?? "Lỗi không xác định"));
      return;
    }

    // Khởi tạo state Loaded và bắt đầu load dịch vụ
    final loadedState = SpecialtyDetailLoaded(
      department: department!,
      specialties: specialties!,
      selectedSpecialty: specialties!.isNotEmpty ? specialties!.first : null,
      isLoadingServices: true,
    );
    emit(loadedState);

    // Fetch dịch vụ theo Department và Facility ngay lập tức
    final facilityId = department!.facilityId;
    final departmentId = department!.departmentsId;

    if (facilityId != null && departmentId != null) {
      final serviceResult = await _repository.getFacilityServices(
        facilityId,
        departmentId: departmentId,
        isActive: true,
      );

      serviceResult.fold(
        (failure) => emit(loadedState.copyWith(isLoadingServices: false)),
        (services) => emit(loadedState.copyWith(
          isLoadingServices: false,
          services: services,
        )),
      );
    } else {
      emit(loadedState.copyWith(isLoadingServices: false));
    }
  }

  Future<void> selectSpecialty(Specialty specialty) async {
    final currentState = state;
    if (currentState is! SpecialtyDetailLoaded) return;

    // Chip chuyên khoa chỉ để hiển thị, không gọi API fetch lại
    emit(currentState.copyWith(
      selectedSpecialty: specialty,
    ));
  }
}
