import 'package:equatable/equatable.dart';
import 'package:e_health/domain/branch.dart';

abstract class AllBranchState extends Equatable {
  const AllBranchState();

  @override
  List<Object?> get props => [];
}

class AllBranchInitial extends AllBranchState {}

class AllBranchLoading extends AllBranchState {}

class AllBranchLoaded extends AllBranchState {
  final List<Branch> branches;

  const AllBranchLoaded({required this.branches});

  @override
  List<Object?> get props => [branches];
}

class AllBranchError extends AllBranchState {
  final String message;

  const AllBranchError({required this.message});

  @override
  List<Object?> get props => [message];
}
