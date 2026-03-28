import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repository.dart';
import 'all_branch_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class AllBranchCubit extends Cubit<AllBranchState> {
  final Repository _repository;

  AllBranchCubit(this._repository) : super(AllBranchInitial());

  Future<void> loadBranches() async {
    emit(AllBranchLoading());
    final result = await _repository.getBranches();
    result.fold(
      (failure) => emit(AllBranchError(message: failure.message)),
      (branches) => emit(AllBranchLoaded(branches: branches)),
    );
  }
}
