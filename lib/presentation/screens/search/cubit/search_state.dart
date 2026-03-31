import 'package:equatable/equatable.dart';
import '../../../../domain/department.dart';
import '../../../../domain/doctor.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Department> results;
  final List<Doctor> doctors;

  const SearchLoaded({
    required this.results,
    required this.doctors,
  });

  @override
  List<Object?> get props => [results, doctors];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
