import '../../../../domain/booked_appointment.dart';

abstract class HomeScheduleState {}

class HomeScheduleInitial extends HomeScheduleState {}

class HomeScheduleLoading extends HomeScheduleState {}

class HomeScheduleLoaded extends HomeScheduleState {
  final List<BookedAppointment> appointments;

  HomeScheduleLoaded({required this.appointments});
}

class HomeScheduleError extends HomeScheduleState {
  final String message;

  HomeScheduleError({required this.message});
}
