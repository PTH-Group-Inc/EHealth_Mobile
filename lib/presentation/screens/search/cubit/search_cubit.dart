import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import '../../../../data/network/dio/failure.dart';
import '../../../../domain/department.dart';
import '../../../../domain/doctor.dart';
import '../../../../data/repository.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  static final _repository = getIt<Repository>();

  SearchCubit() : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await Future.wait([
        _repository.getDepartments(search: query),
        _repository.searchDoctors(search: query),
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
        emit(SearchError(message: errorMessage!));
      } else {
        emit(SearchLoaded(results: departments, doctors: doctors));
      }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
