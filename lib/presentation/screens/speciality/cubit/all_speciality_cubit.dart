import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import 'all_speciality_state.dart';

@injectable
class AllSpecialityCubit extends Cubit<AllSpecialityState> {
  static final _repository = getIt<Repository>();

  AllSpecialityCubit() : super(const AllSpecialityState());

  Future<void> loadDepartments({String? branchId, String? search}) async {
    emit(state.copyWith(
      status: AllSpecialityStatus.loading,
      page: 1,
      hasReachedMax: false,
      isFetchingMore: false,
      clearError: true,
    ));

    final result = await _repository.getDepartments(
      branchId: branchId,
      search: search,
      page: 1,
      limit: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AllSpecialityStatus.failure,
        errorMessage: failure.message,
      )),
      (departments) => emit(state.copyWith(
        status: AllSpecialityStatus.success,
        departments: departments,
        hasReachedMax: departments.length < 20,
      )),
    );
  }

  Future<void> loadMoreDepartments({String? branchId, String? search}) async {
    if (state.isFetchingMore || state.hasReachedMax) return;

    emit(state.copyWith(isFetchingMore: true));

    final nextPage = state.page + 1;
    final result = await _repository.getDepartments(
      branchId: branchId,
      search: search,
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isFetchingMore: false,
        errorMessage: failure.message,
      )),
      (newDepartments) {
        if (newDepartments.isEmpty) {
          emit(state.copyWith(
            isFetchingMore: false,
            hasReachedMax: true,
          ));
        } else {
          emit(state.copyWith(
            status: AllSpecialityStatus.success,
            isFetchingMore: false,
            departments: [...state.departments, ...newDepartments],
            page: nextPage,
            hasReachedMax: newDepartments.length < 20,
          ));
        }
      },
    );
  }
}
