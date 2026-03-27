import 'package:equatable/equatable.dart';
import 'package:e_health/domain/user_profile.dart';

enum EditProfileStatus { initial, loading, success, failure }

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final UserProfile? profile;
  final String? errorMessage;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserProfile? profile,
    String? errorMessage,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
