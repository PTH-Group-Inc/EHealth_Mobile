import 'package:equatable/equatable.dart';
import '../../../../domain/department.dart';

abstract class AllSpecialityState extends Equatable {
  const AllSpecialityState();

  @override
  List<Object?> get props => [];
}

class AllSpecialityInitial extends AllSpecialityState {}

class AllSpecialityLoading extends AllSpecialityState {}

class AllSpecialityLoaded extends AllSpecialityState {
  final List<Department> departments;

  const AllSpecialityLoaded({required this.departments});

  @override
  List<Object?> get props => [departments];
}

class AllSpecialityError extends AllSpecialityState {
  final String message;

  const AllSpecialityError({required this.message});

  @override
  List<Object?> get props => [message];
}
