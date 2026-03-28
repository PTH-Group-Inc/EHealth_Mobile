import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/repository.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import 'all_speciality_state.dart';

@injectable
class AllSpecialityCubit extends Cubit<AllSpecialityState> {
  static final _repository = getIt<Repository>();

  AllSpecialityCubit() : super(AllSpecialityInitial());

  Future<void> loadDepartments({String? branchId, String? search}) async {
    emit(AllSpecialityLoading());
    final result = await _repository.getDepartments(
      branchId: branchId,
      search: search,
    );
    result.fold(
      (failure) => emit(AllSpecialityError(message: failure.message)),
      (departments) => emit(AllSpecialityLoaded(departments: departments)),
    );
  }
}
