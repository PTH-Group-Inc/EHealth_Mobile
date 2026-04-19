import 'package:equatable/equatable.dart';
import 'package:e_health/domain/medical_history.dart';

enum MedicalHistoryStatus { initial, loading, success, failure }

class MedicalHistoryState extends Equatable {
  final MedicalHistoryStatus status;
  final List<MedicalHistory> histories;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;

  const MedicalHistoryState({
    this.status = MedicalHistoryStatus.initial,
    this.histories = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  MedicalHistoryState copyWith({
    MedicalHistoryStatus? status,
    List<MedicalHistory>? histories,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    bool? isFetchingMore,
  }) {
    return MedicalHistoryState(
      status: status ?? this.status,
      histories: histories ?? this.histories,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [
        status,
        histories,
        errorMessage,
        page,
        hasReachedMax,
        isFetchingMore,
      ];
}
