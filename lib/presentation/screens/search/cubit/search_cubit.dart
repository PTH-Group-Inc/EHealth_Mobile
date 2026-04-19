import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:e_health/data/network/dio/failure.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/data/repository.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';
import 'package:e_health/presentation/screens/search/cubit/search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  static final _repository = getIt<Repository>();

  SearchCubit() : super(const SearchState());

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(
      status: SearchStatus.loading,
      doctorPage: 1,
      hasReachedMaxDoctors: false,
      departmentPage: 1,
      hasReachedMaxDepartments: false,
      lastQuery: trimmedQuery,
      isFetchingMoreDoctors: false,
      isFetchingMoreDepartments: false,
      errorMessage: null,
    ));

    try {
      final results = await Future.wait([
        _repository.getDepartments(search: trimmedQuery, page: 1, limit: 20),
        _repository.searchDoctors(search: trimmedQuery, page: 1, limit: 20),
      ]);

      final departmentResult = results[0] as Either<Failure, List<Department>>;
      final doctorResult = results[1] as Either<Failure, List<Doctor>>;

      List<Department> departments = [];
      List<Doctor> doctors = [];
      String? errorMessage;

      departmentResult.fold(
        (failure) => errorMessage = failure.message,
        (data) => departments = data,
      );

      doctorResult.fold(
        (failure) => errorMessage ??= failure.message,
        (data) => doctors = data,
      );

      if (errorMessage != null && departments.isEmpty && doctors.isEmpty) {
        emit(state.copyWith(
          status: SearchStatus.failure,
          errorMessage: errorMessage!,
        ));
      } else {
        emit(state.copyWith(
          status: SearchStatus.success,
          departments: departments,
          doctors: doctors,
          hasReachedMaxDoctors: doctors.length < 20,
          hasReachedMaxDepartments: departments.length < 20,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> loadMoreDoctors() async {
    if (state.isFetchingMoreDoctors || state.hasReachedMaxDoctors) return;
    if (state.lastQuery.isEmpty) return;

    emit(state.copyWith(isFetchingMoreDoctors: true));
    
    final nextPage = state.doctorPage + 1;
    final result = await _repository.searchDoctors(
      search: state.lastQuery,
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isFetchingMoreDoctors: false,
        errorMessage: failure.message,
      )),
      (newDoctors) {
        if (newDoctors.isEmpty) {
          emit(state.copyWith(
            isFetchingMoreDoctors: false,
            hasReachedMaxDoctors: true,
          ));
        } else {
          emit(state.copyWith(
            isFetchingMoreDoctors: false,
            doctors: [...state.doctors, ...newDoctors],
            doctorPage: nextPage,
            hasReachedMaxDoctors: newDoctors.length < 20,
          ));
        }
      },
    );
  }

  Future<void> loadMoreDepartments() async {
    if (state.isFetchingMoreDepartments || state.hasReachedMaxDepartments) return;
    if (state.lastQuery.isEmpty) return;

    emit(state.copyWith(isFetchingMoreDepartments: true));
    
    final nextPage = state.departmentPage + 1;
    final result = await _repository.getDepartments(
      search: state.lastQuery,
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isFetchingMoreDepartments: false,
        errorMessage: failure.message,
      )),
      (newDepartments) {
        if (newDepartments.isEmpty) {
          emit(state.copyWith(
            isFetchingMoreDepartments: false,
            hasReachedMaxDepartments: true,
          ));
        } else {
          emit(state.copyWith(
            isFetchingMoreDepartments: false,
            departments: [...state.departments, ...newDepartments],
            departmentPage: nextPage,
            hasReachedMaxDepartments: newDepartments.length < 20,
          ));
        }
      },
    );
  }

  void clearSearch() {
    emit(const SearchState());
  }
}
