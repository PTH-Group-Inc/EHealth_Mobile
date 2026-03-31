import 'package:equatable/equatable.dart';
import '../../../../domain/department.dart';
import '../../../../domain/doctor.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  final SearchStatus status;
  final List<Department> departments;
  final List<Doctor> doctors;
  final String? errorMessage;
  final int doctorPage;
  final bool hasReachedMaxDoctors;
  final bool isFetchingMoreDoctors;
  final String lastQuery;

  const SearchState({
    this.status = SearchStatus.initial,
    this.departments = const [],
    this.doctors = const [],
    this.errorMessage,
    this.doctorPage = 1,
    this.hasReachedMaxDoctors = false,
    this.isFetchingMoreDoctors = false,
    this.lastQuery = '',
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Department>? departments,
    List<Doctor>? doctors,
    String? errorMessage,
    int? doctorPage,
    bool? hasReachedMaxDoctors,
    bool? isFetchingMoreDoctors,
    String? lastQuery,
  }) {
    return SearchState(
      status: status ?? this.status,
      departments: departments ?? this.departments,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage ?? this.errorMessage,
      doctorPage: doctorPage ?? this.doctorPage,
      hasReachedMaxDoctors: hasReachedMaxDoctors ?? this.hasReachedMaxDoctors,
      isFetchingMoreDoctors: isFetchingMoreDoctors ?? this.isFetchingMoreDoctors,
      lastQuery: lastQuery ?? this.lastQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        departments,
        doctors,
        errorMessage,
        doctorPage,
        hasReachedMaxDoctors,
        isFetchingMoreDoctors,
        lastQuery,
      ];
}
