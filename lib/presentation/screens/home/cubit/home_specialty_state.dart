import 'package:equatable/equatable.dart';
import 'package:e_health/domain/specialty.dart';

abstract class HomeSpecialtyState extends Equatable {
  const HomeSpecialtyState();

  @override
  List<Object?> get props => [];
}

class HomeSpecialtyInitial extends HomeSpecialtyState {}

class HomeSpecialtyLoading extends HomeSpecialtyState {}

class HomeSpecialtyLoaded extends HomeSpecialtyState {
  final List<Specialty> specialties;

  const HomeSpecialtyLoaded({required this.specialties});

  @override
  List<Object?> get props => [specialties];
}

class HomeSpecialtyError extends HomeSpecialtyState {
  final String message;

  const HomeSpecialtyError({required this.message});

  @override
  List<Object?> get props => [message];
}
