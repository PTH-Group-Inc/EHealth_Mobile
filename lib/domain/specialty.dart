import 'package:equatable/equatable.dart';
import 'package:e_health/domain/pagination.dart';


class Specialty extends Equatable {
  final String? id;
  final String? code;
  final String? name;
  final String? description;
  final String? logoUrl;

  const Specialty({
    this.id,
    this.code,
    this.name,
    this.description,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [id, code, name, description, logoUrl];
}

class SpecialtyList extends Equatable {
  final List<Specialty> items;
  final Pagination? pagination;

  const SpecialtyList({
    required this.items,
    this.pagination,
  });

  @override
  List<Object?> get props => [items, pagination];
}

