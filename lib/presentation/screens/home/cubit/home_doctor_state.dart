import 'package:equatable/equatable.dart';
import 'package:e_health/domain/doctor.dart';

enum HomeDoctorStatus { initial, loading, success, failure }

class HomeDoctorState extends Equatable {
  final HomeDoctorStatus status;
  final List<Doctor> doctors;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const HomeDoctorState({
    this.status = HomeDoctorStatus.initial,
    this.doctors = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  HomeDoctorState copyWith({
    HomeDoctorStatus? status,
    List<Doctor>? doctors,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    bool? isFetchingMore,
    bool clearError = false,
  }) {
    return HomeDoctorState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        doctors,
        errorMessage,
        page,
        hasReachedMax,
        isFetchingMore,
      ];
}
