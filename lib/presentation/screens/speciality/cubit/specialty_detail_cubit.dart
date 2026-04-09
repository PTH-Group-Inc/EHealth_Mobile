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

    deptResult.fold(
      (failure) => emit(SpecialtyDetailError(message: failure.message)),
      (department) {
        specialtiesResult.fold(
          (failure) => emit(SpecialtyDetailError(message: failure.message)),
          (specialties) {
            final loadedState = SpecialtyDetailLoaded(
              department: department,
              specialties: specialties,
              selectedSpecialty: specialties.isNotEmpty ? specialties.first : null,
            );
            emit(loadedState);
            
            // Auto-load services for the first specialty if available
            if (specialties.isNotEmpty) {
              selectSpecialty(specialties.first);
            }
          },
        );
      },
    );
  }

  Future<void> selectSpecialty(Specialty specialty) async {
    final currentState = state;
    if (currentState is! SpecialtyDetailLoaded) return;

    emit(currentState.copyWith(
      selectedSpecialty: specialty,
      isLoadingServices: true,
      services: [],
    ));

    final result = await _repository.getSpecialtyServices(specialty.id!);

    result.fold(
      (failure) => emit(currentState.copyWith(
        isLoadingServices: false,
        selectedSpecialty: specialty,
      )),
      (services) => emit(currentState.copyWith(
        isLoadingServices: false,
        selectedSpecialty: specialty,
        services: services,
      )),
    );
  }
}
