import '../../../../domain/department.dart';
import '../../../../domain/specialty.dart';
import 'package:equatable/equatable.dart';

abstract class SpecialtyDetailState extends Equatable {
  const SpecialtyDetailState();

  @override
  List<Object?> get props => [];
}

class SpecialtyDetailInitial extends SpecialtyDetailState {}

class SpecialtyDetailLoading extends SpecialtyDetailState {}

class SpecialtyDetailLoaded extends SpecialtyDetailState {
  final Department department;
  final List<Specialty> specialties;

  const SpecialtyDetailLoaded({
    required this.department,
    required this.specialties,
  });

  @override
  List<Object?> get props => [department, specialties];
}

class SpecialtyDetailError extends SpecialtyDetailState {
  final String message;

  const SpecialtyDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
