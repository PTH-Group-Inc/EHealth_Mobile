import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
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
    final result = await _repository.getDepartments(search: query);
    
    result.fold(
      (failure) => emit(SearchError(message: failure.message)),
      (departments) => emit(SearchLoaded(results: departments)),
    );
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
