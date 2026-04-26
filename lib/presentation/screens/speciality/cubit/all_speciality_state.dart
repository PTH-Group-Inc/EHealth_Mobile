import 'package:equatable/equatable.dart';
import 'package:e_health/domain/department.dart';

enum AllSpecialityStatus { initial, loading, success, failure }

class AllSpecialityState extends Equatable {
  final AllSpecialityStatus status;
  final List<Department> departments;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;
  final String? searchQuery;

  const AllSpecialityState({
    this.status = AllSpecialityStatus.initial,
    this.departments = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
    this.searchQuery,
  });

  AllSpecialityState copyWith({
    AllSpecialityStatus? status,
    List<Department>? departments,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    bool? isFetchingMore,
    String? searchQuery,
    bool clearError = false,
  }) {
    return AllSpecialityState(
      status: status ?? this.status,
      departments: departments ?? this.departments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        departments,
        errorMessage,
        page,
        hasReachedMax,
        isFetchingMore,
        searchQuery,
      ];
}
