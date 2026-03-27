import 'package:equatable/equatable.dart';

class Specialty extends Equatable {
  final String? id;
  final String? code;
  final String? name;
  final String? description;

  const Specialty({
    this.id,
    this.code,
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, code, name, description];
}
