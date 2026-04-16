import 'package:equatable/equatable.dart';
import '../../../../domain/department.dart';

enum AllSpecialityStatus { initial, loading, success, failure }

class AllSpecialityState extends Equatable {
  final AllSpecialityStatus status;
  final List<Department> departments;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const AllSpecialityState({
    this.status = AllSpecialityStatus.initial,
    this.departments = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  AllSpecialityState copyWith({
    AllSpecialityStatus? status,
    List<Department>? departments,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    bool? isFetchingMore,
    bool clearError = false,
  }) {
    return AllSpecialityState(
      status: status ?? this.status,
      departments: departments ?? this.departments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
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
      ];
}
