import 'package:e_health/domain/doctor.dart';

enum AllDoctorStatus { initial, loading, success, failure }

class AllDoctorState {
  final AllDoctorStatus status;
  final List<Doctor> doctors;
  final String? errorMessage;
  final bool isFetchingMore;
  final bool hasReachedMax;
  final int currentPage;
  final String query;

  const AllDoctorState({
    this.status = AllDoctorStatus.initial,
    this.doctors = const [],
    this.errorMessage,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.query = "",
  });

  AllDoctorState copyWith({
    AllDoctorStatus? status,
    List<Doctor>? doctors,
    String? errorMessage,
    bool? isFetchingMore,
    bool? hasReachedMax,
    int? currentPage,
    String? query,
  }) {
    return AllDoctorState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      errorMessage: errorMessage ?? this.errorMessage,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      query: query ?? this.query,
    );
  }
}
