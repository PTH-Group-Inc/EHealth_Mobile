import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/dependency_injection/configure_injectable.dart';
import '../../../../data/repository.dart';
import 'specialty_detail_state.dart';

class SpecialtyDetailCubit extends Cubit<SpecialtyDetailState> {
  static final _repository = getIt<Repository>();

  SpecialtyDetailCubit() : super(SpecialtyDetailInitial());

  Future<void> loadDepartmentDetail(String id) async {
    emit(SpecialtyDetailLoading());

    final result = await _repository.getDepartmentDetail(id);

    result.fold(
      (failure) => emit(SpecialtyDetailError(message: failure.message)),
      (department) => emit(SpecialtyDetailLoaded(department: department)),
    );
  }
}
