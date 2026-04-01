import 'package:equatable/equatable.dart';
import '../../../../domain/booked_appointment.dart';

enum HomeScheduleStatus { initial, loading, success, failure }

class HomeScheduleState extends Equatable {
  final HomeScheduleStatus status;
  final List<BookedAppointment> appointments;
  final String? errorMessage;
  final int page;
  final bool hasReachedMax;
  final bool isFetchingMore;
  final bool isNotLinked;

  const HomeScheduleState({
    this.status = HomeScheduleStatus.initial,
    this.appointments = const [],
    this.errorMessage,
    this.page = 1,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
    this.isNotLinked = false,
  });

  HomeScheduleState copyWith({
    HomeScheduleStatus? status,
    List<BookedAppointment>? appointments,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    bool? isFetchingMore,
    bool? isNotLinked,
    bool clearError = false,
  }) {
    return HomeScheduleState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      isNotLinked: isNotLinked ?? this.isNotLinked,
    );
  }

  @override
  List<Object?> get props => [
        status,
        appointments,
        errorMessage,
        page,
        hasReachedMax,
        isFetchingMore,
        isNotLinked,
      ];
}
